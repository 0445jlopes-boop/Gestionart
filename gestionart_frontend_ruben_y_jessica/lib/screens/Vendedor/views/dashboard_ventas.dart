import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/NotificacionProvider.dart';
import 'package:provider/provider.dart';

class DashboardVentasView extends StatefulWidget {
  final Vendedor vendedor;
  const DashboardVentasView({super.key, required this.vendedor});

  @override
  State<DashboardVentasView> createState() => _DashboardVentasViewState();
}

class _DashboardVentasViewState extends State<DashboardVentasView> {
  String _filtroEstado = "PENDIENTE";
  bool _isLoading = true;
  List<Pedido> _pedidos = [];

  final List<String> _estadosFiltro = ["PENDIENTE", "PROCESANDO", "FINALIZADO", "CANCELADO"];

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
      
      // Obtener pedidos del vendedor
      await pedidoProvider.fetchPedidosPorVedndedor(widget.vendedor.id);
      
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
      print("Error cargando pedidos: $e");
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

  Future<void> _aceptarPedido(Pedido pedido) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Aceptar pedido",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: Text(
          "¿Quieres aceptar el pedido #${pedido.id}?\n\nEl estado cambiará a PROCESANDO.",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: AppEstiloBotones.botonPrincipal,
            child: const Text("Aceptar pedido"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final pedidoProvider = context.read<Pedidoprovider>();
      final notificacionProvider = context.read<NotificacionProvider>();
      
      // Cambiar estado a PROCESANDO
      await pedidoProvider.cambiarEstado(pedido.id);
      
      // Crear notificación para el comprador (opcional)
      // await notificacionProvider.crearNotificacionComprador(...);
      
      await _cargarPedidos();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Pedido aceptado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al aceptar pedido: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rechazarPedido(Pedido pedido) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Rechazar pedido",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: Text(
          "¿Seguro que quieres rechazar el pedido #${pedido.id}?\n\nEl estado cambiará a CANCELADO.",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No, mantener"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Rechazar pedido"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final pedidoProvider = context.read<Pedidoprovider>();
      
      // Cancelar pedido
      await pedidoProvider.cancelarPedido(pedido.id);
      
      await _cargarPedidos();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Pedido rechazado"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al rechazar pedido: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _marcarEntregado(Pedido pedido) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Marcar como entregado",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: Text(
          "¿Confirmas que el pedido #${pedido.id} ha sido entregado?\n\nEl estado cambiará a FINALIZADO.",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Confirmar entrega"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final pedidoProvider = context.read<Pedidoprovider>();
      
      // Cambiar estado a FINALIZADO
      await pedidoProvider.cambiarEstado(pedido.id);
      
      await _cargarPedidos();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Pedido marcado como entregado"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getEstadoColor(String estado) {
    switch (estado) {
      case "PENDIENTE": return "#FF9800";
      case "PROCESANDO": return "#2196F3";
      case "FINALIZADO": return "#4CAF50";
      case "CANCELADO": return "#F44336";
      default: return "#757575";
    }
  }

  String _getEstadoIcon(String estado) {
    switch (estado) {
      case "PENDIENTE": return "🕐";
      case "PROCESANDO": return "⚙️";
      case "FINALIZADO": return "✅";
      case "CANCELADO": return "❌";
      default: return "📦";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text(
          "Dashboard de Ventas",
          style: AppEstiloTexto.encabezado,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtros
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
                        ),
                      );
                    },
                  ),
                ),
                
                // Lista de pedidos
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
                                Text("No hay pedidos", style: AppEstiloTexto.textoPrincipal),
                                const SizedBox(height: 8),
                                Text("Los pedidos aparecerán aquí", style: AppEstiloTexto.textoSecundario),
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
    final esPendiente = estadoStr == "PENDIENTE";
    final esProcesando = estadoStr == "PROCESANDO";
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
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
                    color: Color(int.parse(colorEstado.replaceFirst("#", "0xFF"))).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(int.parse(colorEstado.replaceFirst("#", "0xFF"))), width: 1),
                  ),
                  child: Text(
                    estadoStr,
                    style: TextStyle(color: Color(int.parse(colorEstado.replaceFirst("#", "0xFF"))), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Detalles
            Text(
              "Comprador ID: ${pedido.idComprador}",
              style: AppEstiloTexto.textoSecundario,
            ),
            const SizedBox(height: 8),
            Text(
              "${pedido.lineas.length} productos",
              style: AppEstiloTexto.textoSecundario,
            ),
            const SizedBox(height: 8),
            Text(
              "Total: ${total.toStringAsFixed(2)} €",
              style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 12),
            
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (esPendiente) ...[
                  ElevatedButton(
                    onPressed: () => _aceptarPedido(pedido),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _rechazarPedido(pedido),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text("Rechazar", style: TextStyle(color: Colors.white)),
                  ),
                ],
                if (esProcesando)
                  ElevatedButton(
                    onPressed: () => _marcarEntregado(pedido),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text("Marcar entregado", style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}