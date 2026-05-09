import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaPago.dart';
import 'package:provider/provider.dart';

class PedidosView extends StatefulWidget {
  final Comprador comprador;
  const PedidosView({super.key, required this.comprador});

  @override
  State<PedidosView> createState() => _PedidosViewState();
}

class _PedidosViewState extends State<PedidosView> {
  String _filtroEstado = "TODOS";
  bool _isLoading = true;
  List<Pedido> _pedidos = [];

  final List<String> _estadosFiltro = ["TODOS", "PENDIENTE", "PROCESANDO", "FINALIZADO"];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    setState(() => _isLoading = true);
    try {
      final pedidoProvider = context.read<Pedidoprovider>();
      final lineaPedidoProvider = context.read<Lineapedidoprovider>();
      
      await pedidoProvider.fetchPedidosPorComprador(widget.comprador.id);
      
      final pedidosConLineas = <Pedido>[];
      for (var pedido in pedidoProvider.pedidos) {
        final lineas = await lineaPedidoProvider.fetchLineasPedidoPorPedido(pedido.id);
        final pedidoConLineas = pedido.copyWith(lineas: lineas);
        pedidosConLineas.add(pedidoConLineas);
      }
      
      setState(() {
        _pedidos = pedidosConLineas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Pedido> get _pedidosFiltrados {
    if (_filtroEstado == "TODOS") return _pedidos;
    return _pedidos.where((p) => p.estado.toString().split('.').last == _filtroEstado).toList();
  }

  double _calcularTotalPedido(Pedido pedido) {
    return pedido.lineas.fold(0.0, (total, linea) => total + (linea.cantidad * linea.precioUnitario));
  }

  Future<void> _pagarPedido(Pedido pedido) async {
    final total = _calcularTotalPedido(pedido);
    
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => pago_view(
          pago: Tipopago.PEDIDO,
          importe: total,
          comprador: widget.comprador,
        ),
      ),
    );
    
    if (result == true && mounted) {
      await context.read<Pedidoprovider>().cambiarEstado(pedido.id);
      await context.read<Pedidoprovider>().cambiarEstado(pedido.id);
      await _cargarPedidos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Pedido pagado correctamente!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _eliminarPedido(Pedido pedido) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar pedido", style: AppEstiloTexto.textoPrincipal),
        content: Text("¿Seguro que quieres eliminar el pedido #${pedido.id}?", style: AppEstiloTexto.textoSecundario),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sí", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await context.read<Pedidoprovider>().eliminarPedido(pedido.id);
      await _cargarPedidos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pedido eliminado"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _verDetallePedido(Pedido pedido) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedidoView(
          pedido: pedido,
          comprador: widget.comprador,
          onPedidoActualizado: _cargarPedidos,
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case "PENDIENTE": 
        return AppColores.colorPrimario;
      case "PROCESANDO": 
        return AppColores.colorSecundario;
      case "FINALIZADO":
        return AppColores.colorDesactivado;
      default: 
        return AppColores.colorPrimario;
    }
  }

  String _getEstadoIcon(String estado) {
    switch (estado) {
      case "PENDIENTE": return "🕐";
      case "PROCESANDO": return "⚙️";
      case "FINALIZADO": return "✅";
      default: return "📦";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text("Mis Pedidos", style: AppEstiloTexto.encabezado),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _estadosFiltro.length,
                    itemBuilder: (context, index) {
                      final estado = _estadosFiltro[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(estado),
                          selected: _filtroEstado == estado,
                          onSelected: (_) => setState(() => _filtroEstado = estado),
                          backgroundColor: AppColores.colorFondo,
                          selectedColor: AppColores.colorPrimario.withOpacity(0.3),
                          checkmarkColor: AppColores.colorPrimario,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _cargarPedidos,
                    child: _pedidosFiltrados.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 80, color: AppColores.colorPrimario.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                Text("No tienes pedidos", style: AppEstiloTexto.textoPrincipal),
                                const SizedBox(height: 8),
                                Text("Cuando realices pedidos aparecerán aquí", style: AppEstiloTexto.textoSecundario),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _pedidosFiltrados.length,
                            itemBuilder: (context, index) => _buildPedidoCard(_pedidosFiltrados[index]),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPedidoCard(Pedido pedido) {
    final estadoStr = pedido.estado.toString().split('.').last;
    final total = _calcularTotalPedido(pedido);
    final colorEstado = _getEstadoColor(estadoStr);
    final estadoIcon = _getEstadoIcon(estadoStr);
    final puedeEliminar = estadoStr == "FINALIZADO";
    final puedePagar = estadoStr == "PENDIENTE";
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _verDetallePedido(pedido),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(estadoIcon, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        "Pedido #${pedido.id}",
                        style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorEstado.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorEstado, width: 1),
                    ),
                    child: Text(
                      estadoStr,
                      style: TextStyle(color: colorEstado, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text("${pedido.lineas.length} productos", style: AppEstiloTexto.textoSecundario),
                  const SizedBox(width: 16),
                  Icon(Icons.euro, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(total.toStringAsFixed(2), style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (puedePagar)
                    ElevatedButton(
                      onPressed: () => _pagarPedido(pedido),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text("Pagar", style: TextStyle(color: Colors.white)),
                    ),
                  if (puedeEliminar)
                    const SizedBox(width: 8),
                  if (puedeEliminar)
                    TextButton.icon(
                      onPressed: () => _eliminarPedido(pedido),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text("Eliminar"),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== DETALLE DEL PEDIDO ==========
class DetallePedidoView extends StatefulWidget {
  final Pedido pedido;
  final Comprador comprador;
  final VoidCallback onPedidoActualizado;
  const DetallePedidoView({super.key, required this.pedido, required this.comprador, required this.onPedidoActualizado});

  @override
  State<DetallePedidoView> createState() => _DetallePedidoViewState();
}

class _DetallePedidoViewState extends State<DetallePedidoView> {
  Map<int, String> _nombreArticulos = {};
  bool _cargandoArticulos = true;
  List<Lineapedido> _lineas = [];

  @override
  void initState() {
    super.initState();
    _cargarLineasYArticulos();
  }

  Future<void> _cargarLineasYArticulos() async {
    final lineaPedidoProvider = context.read<Lineapedidoprovider>();
    final articuloProvider = context.read<Articuloprovider>();
    
    final lineas = await lineaPedidoProvider.fetchLineasPedidoPorPedido(widget.pedido.id);
    
    setState(() {
      _lineas = lineas;
    });
    
    // Cargar nombres de los artículos
    for (var linea in lineas) {
      try {
        final articulo = await articuloProvider.obtenerArticulo(linea.idArticulo);
        if (articulo != null && mounted) {
          _nombreArticulos[linea.idArticulo] = articulo.titulo;
        }
      } catch (e) {
        _nombreArticulos[linea.idArticulo] = "Producto no disponible";
      }
    }
    if (mounted) setState(() => _cargandoArticulos = false);
  }

  double get _totalPedido {
    return _lineas.fold(0.0, (total, l) => total + (l.cantidad * l.precioUnitario));
  }

  Future<void> _pagarPedido() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => pago_view(
          pago: Tipopago.PEDIDO,
          importe: _totalPedido,
          comprador: widget.comprador,
        ),
      ),
    );
    
    if (result == true && mounted) {
      widget.onPedidoActualizado();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Pedido pagado correctamente!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _eliminarPedido() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar pedido"),
        content: Text("¿Eliminar pedido #${widget.pedido.id}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sí", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await context.read<Pedidoprovider>().eliminarPedido(widget.pedido.id);
      widget.onPedidoActualizado();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  String _getEstadoIcon(String estado) {
    switch (estado) {
      case "PENDIENTE": return "🕐";
      case "PROCESANDO": return "⚙️";
      case "FINALIZADO": return "✅";
      default: return "📦";
    }
  }

  @override
  Widget build(BuildContext context) {
    final estadoStr = widget.pedido.estado.toString().split('.').last;
    final puedeEliminar = estadoStr == "FINALIZADO";
    final puedePagar = estadoStr == "PENDIENTE";
    final estadoIcon = _getEstadoIcon(estadoStr);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text("Pedido #${widget.pedido.id}", style: AppEstiloTexto.encabezado),
        centerTitle: true,
        actions: [
          if (puedePagar)
            IconButton(
              icon: const Icon(Icons.payment, color: Colors.white),
              onPressed: _pagarPedido,
              tooltip: "Pagar pedido",
            ),
          if (puedeEliminar)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _eliminarPedido,
              tooltip: "Eliminar pedido",
            ),
        ],
      ),
      body: _cargandoArticulos
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColores.colorPrimario.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(estadoIcon, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Estado del pedido", style: AppEstiloTexto.textoSecundario),
                            const SizedBox(height: 4),
                            Text(estadoStr, style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Productos", style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _lineas.length,
                    itemBuilder: (context, index) => _buildLineaCard(_lineas[index]),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColores.colorSecundario.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColores.colorSecundario.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL", style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("${_totalPedido.toStringAsFixed(2)} €", style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, fontSize: 22, color: AppColores.colorSecundario)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (puedePagar)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _pagarPedido,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "PAGAR AHORA",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildLineaCard(Lineapedido linea) {
    final subtotal = linea.cantidad * linea.precioUnitario;
    final nombreArticulo = _nombreArticulos[linea.idArticulo] ?? "Cargando...";
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ✅ SOLO NOMBRE DEL ARTÍCULO (sin imagen)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombreArticulo,
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${linea.precioUnitario.toStringAsFixed(2)} € x ${linea.cantidad}",
                    style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              "${subtotal.toStringAsFixed(2)} €",
              style: AppEstiloTexto.textoPrincipal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}