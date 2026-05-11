import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:provider/provider.dart' show ReadContext;


class DashboardVentasView extends StatefulWidget {
  final Vendedor vendedor;
  const DashboardVentasView({super.key, required this.vendedor});

  @override
  State<DashboardVentasView> createState() => _DashboardVentasViewState();
}

class _DashboardVentasViewState extends State<DashboardVentasView> {
  double _ventasTotales = 0;
  int _pedidosCompletados = 0;
  double _productosVendidos = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final pedidoProvider = context.read<Pedidoprovider>();
      final pedidos = await pedidoProvider.fetchPedidosPorVedndedor(widget.vendedor.id);
      
      _pedidosCompletados = pedidos.where((p) => 
        p.estado.toString().split('.').last == "FINALIZADO").length;
      
      for (var pedido in pedidos) {
        if (pedido.estado.toString().split('.').last == "FINALIZADO") {
          _ventasTotales += pedido.lineas.fold(0.0, (sum, l) => sum + (l.cantidad * l.precioUnitario));
          _productosVendidos += pedido.lineas.fold(0, (sum, l) => sum + l.cantidad).toInt();
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text("Dashboard de Ventas", style: AppEstiloTexto.encabezado),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTarjeta("Ventas Totales", "${_ventasTotales.toStringAsFixed(2)} €", Icons.euro, Colors.green),
                  const SizedBox(height: 16),
                  _buildTarjeta("Pedidos Completados", _pedidosCompletados.toString(), Icons.shopping_bag, Colors.blue),
                  const SizedBox(height: 16),
                  _buildTarjeta("Productos Vendidos", _productosVendidos.toString(), Icons.art_track, Colors.orange),
                ],
              ),
            ),
    );
  }

  Widget _buildTarjeta(String titulo, String valor, IconData icono, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icono, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppEstiloTexto.textoSecundario),
                  Text(valor, style: AppEstiloTexto.textoPrincipal.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}