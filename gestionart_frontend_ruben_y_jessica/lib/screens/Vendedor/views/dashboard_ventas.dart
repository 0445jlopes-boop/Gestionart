import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoSolicitud.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/SolicitudExclusiva.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/SolicitudExclusivaProvider.dart';
import 'package:provider/provider.dart';

class DashboardVentasView extends StatefulWidget {
  final Vendedor vendedor;
  const DashboardVentasView({super.key, required this.vendedor});

  @override
  State<DashboardVentasView> createState() => _DashboardVentasViewState();
}

class _DashboardVentasViewState extends State<DashboardVentasView> {
  bool _isLoading = true;
  List<Solicitudexclusiva> _solicitudes = [];
  List<Lineapedido> _lineas = [];
  Map<int, String> _correosComprador = {};
  Map<int, String> _nombresComprador = {};
  Map<int, String> _titulosArticulo = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final solicitudProvider = context.read<SolicitudExclusivaProvider>();
      final lineaPedidoProvider = context.read<Lineapedidoprovider>();
      final pedidoProvider = context.read<Pedidoprovider>();
      final compradorProvider = context.read<Compradorprovider>();
      final articuloProvider = context.read<Articuloprovider>();
      
      // Cargar solicitudes exclusivas (solo pendientes)
      await solicitudProvider.fetchSolicitudesPorVendedor(widget.vendedor.id);
      _solicitudes = solicitudProvider.solicitudes
          .where((s) => s.estado == Estadosolicitud.PENDIENTE)
          .toList();
      
      // Obtener datos de compradores y artículos para las solicitudes
      final Map<int, String> nombresTemp = {};
      final Map<int, String> correosTemp = {};
      final Map<int, String> titulosTemp = {};
      
      for (var solicitud in _solicitudes) {
        // Obtener nombre y correo del comprador
        if (!nombresTemp.containsKey(solicitud.idComprador)) {
          final comprador = await compradorProvider.obtenerComprador(solicitud.idComprador);
          if (comprador != null) {
            nombresTemp[solicitud.idComprador] = comprador.nombre;
            correosTemp[solicitud.idComprador] = comprador.correoElectronico;
          } else {
            nombresTemp[solicitud.idComprador] = "No disponible";
            correosTemp[solicitud.idComprador] = "No disponible";
          }
        }
        
        // Obtener título del artículo
        if (!titulosTemp.containsKey(solicitud.idArticulo)) {
          final articulo = await articuloProvider.obtenerArticulo(solicitud.idArticulo);
          if (articulo != null) {
            titulosTemp[solicitud.idArticulo] = articulo.titulo;
          } else {
            titulosTemp[solicitud.idArticulo] = "Producto no disponible";
          }
        }
      }
      _nombresComprador = nombresTemp;
      _correosComprador = correosTemp;
      _titulosArticulo = titulosTemp;
      
      // Cargar líneas de pedido (solo para mostrar, sin acciones)
      final lineas = await lineaPedidoProvider.fetchLineasPorVendedor(widget.vendedor.id);
      
      setState(() {
        _lineas = lineas;
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando datos: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _aceptarSolicitud(Solicitudexclusiva solicitud) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Aceptar solicitud", style: AppEstiloTexto.textoPrincipal),
        content: Text(
          "¿Aceptar la solicitud exclusiva para '${_titulosArticulo[solicitud.idArticulo]}'?",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final solicitudProvider = context.read<SolicitudExclusivaProvider>();
      
      // ✅ Aceptar solicitud (la solicitud cambia a ACEPTADA)
      await solicitudProvider.actualizarEstadoSolicitud(
        solicitud.id,
        Estadosolicitud.ACEPTADA,
        idVendedor: widget.vendedor.id,
      );
      
      if (mounted) {
        // ✅ Recargar datos después de aceptar
        await _cargarDatos();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Solicitud aceptada correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _rechazarSolicitud(Solicitudexclusiva solicitud) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rechazar solicitud", style: AppEstiloTexto.textoPrincipal),
        content: Text(
          "¿Rechazar la solicitud exclusiva para '${_titulosArticulo[solicitud.idArticulo]}'?",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Rechazar"),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final solicitudProvider = context.read<SolicitudExclusivaProvider>();
      await solicitudProvider.actualizarEstadoSolicitud(
        solicitud.id,
        Estadosolicitud.RECHAZADA,
        idVendedor: widget.vendedor.id,
      );
      
      if (mounted) {
        // ✅ Recargar datos después de rechazar
        await _cargarDatos();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Solicitud rechazada"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
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
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarDatos,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _solicitudes.length + _lineas.length,
                itemBuilder: (context, index) {
                  // Primero mostrar solicitudes exclusivas pendientes
                  if (index < _solicitudes.length) {
                    return _buildSolicitudCard(_solicitudes[index]);
                  }
                  // Luego mostrar líneas de pedido (solo vista)
                  final lineaIndex = index - _solicitudes.length;
                  if (lineaIndex < _lineas.length) {
                    return _buildLineaCard(_lineas[lineaIndex]);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
    );
  }

  Widget _buildSolicitudCard(Solicitudexclusiva solicitud) {
    final nombreComprador = _nombresComprador[solicitud.idComprador] ?? "Cargando...";
    final correoComprador = _correosComprador[solicitud.idComprador] ?? "Cargando...";
    final tituloArticulo = _titulosArticulo[solicitud.idArticulo] ?? "Cargando...";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF3E0), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.star, color: Colors.amber, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Solicitud Exclusiva",
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: const Text(
                    "PENDIENTE",
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Título del artículo
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Artículo solicitado",
                    style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tituloArticulo,
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Nombre del comprador
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Comprador",
                    style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nombreComprador,
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Correo del comprador
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_outlined, size: 20, color: Colors.amber[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Correo electrónico",
                          style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 11),
                        ),
                        Text(
                          correoComprador,
                          style: AppEstiloTexto.textoPrincipal.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Mensaje
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mensaje del comprador",
                    style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    solicitud.mensage,
                    style: AppEstiloTexto.textoPrincipal,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _aceptarSolicitud(solicitud),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _rechazarSolicitud(solicitud),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Rechazar", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineaCard(Lineapedido linea) {
    final subtotal = linea.cantidad * linea.precioUnitario;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColores.colorPrimario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    size: 24,
                    color: AppColores.colorPrimario,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Línea de pedido #${linea.id}",
                        style: AppEstiloTexto.textoPrincipal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Pedido ID: ${linea.idPedido}",
                        style: AppEstiloTexto.textoSecundario.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColores.colorSecundario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${subtotal.toStringAsFixed(2)} €",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColores.colorSecundario,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Detalles
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.inventory_2,
                    label: "Artículo ID",
                    value: "${linea.idArticulo}",
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.numbers,
                    label: "Cantidad",
                    value: "${linea.cantidad}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.euro,
                    label: "Precio unitario",
                    value: "${linea.precioUnitario.toStringAsFixed(2)} €",
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.calculate,
                    label: "Subtotal",
                    value: "${subtotal.toStringAsFixed(2)} €",
                    isBold: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColores.colorSecundario),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 13),
        ),
        Text(
          value,
          style: isBold
              ? AppEstiloTexto.textoPrincipal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                )
              : AppEstiloTexto.textoSecundario.copyWith(
                  fontSize: 13,
                ),
        ),
      ],
    );
  }
}