import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:provider/provider.dart';

class DashboardVentasView extends StatefulWidget {
  final Vendedor vendedor;
  const DashboardVentasView({super.key, required this.vendedor});

  @override
  State<DashboardVentasView> createState() => _DashboardVentasViewState();
}

class _DashboardVentasViewState extends State<DashboardVentasView> {
  bool _isLoading = true;
  List<Lineapedido> _lineas = [];
  Map<int, String> _correosComprador = {};

  @override
  void initState() {
    super.initState();
    _cargarLineas();
  }

  Future<void> _cargarLineas() async {
    setState(() => _isLoading = true);
    try {
      final lineaPedidoProvider = context.read<Lineapedidoprovider>();
      final pedidoProvider = context.read<Pedidoprovider>();
      final compradorProvider = context.read<Compradorprovider>();
      
      // Obtener todas las líneas del vendedor
      final lineas = await lineaPedidoProvider.fetchLineasPorVendedor(widget.vendedor.id);
      
      // Obtener correo del comprador para cada línea
      final Map<int, String> correosTemp = {};
      for (var linea in lineas) {
        if (!correosTemp.containsKey(linea.idPedido)) {
          try {
            final pedido = await pedidoProvider.fetchPedidoPorId(linea.idPedido);
            final comprador = await compradorProvider.obtenerComprador(pedido.idComprador);
            if (comprador != null) {
              correosTemp[linea.idPedido] = comprador.correoElectronico;
            } else {
              correosTemp[linea.idPedido] = "No disponible";
            }
          } catch (e) {
            correosTemp[linea.idPedido] = "No disponible";
          }
        }
      }
      
      setState(() {
        _lineas = lineas;
        _correosComprador = correosTemp;
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando lineas: $e");
      setState(() => _isLoading = false);
      if (mounted) {
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
              onRefresh: _cargarLineas,
              child: _lineas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColores.colorPrimario.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 60,
                              color: AppColores.colorPrimario,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "No hay ventas",
                            style: AppEstiloTexto.textoPrincipal.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Las ventas aparecerán aquí",
                            style: AppEstiloTexto.textoSecundario,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _lineas.length,
                      itemBuilder: (context, index) => _buildLineaCard(_lineas[index]),
                    ),
            ),
    );
  }

  Widget _buildLineaCard(Lineapedido linea) {
    final subtotal = linea.cantidad * linea.precioUnitario;
    final correoComprador = _correosComprador[linea.idPedido] ?? "Cargando...";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColores.colorFondo,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la línea de pedido
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
              
              const SizedBox(height: 20),
              
              // Detalles del producto
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColores.colorPrimario.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColores.colorPrimario.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
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
                    const SizedBox(height: 12),
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
              
              const SizedBox(height: 16),
              
              // Correo del comprador
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColores.colorSecundario.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: AppColores.colorSecundario,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Comprador",
                            style: AppEstiloTexto.textoSecundario.copyWith(
                              fontSize: 11,
                            ),
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
            ],
          ),
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
        Icon(
          icon,
          size: 16,
          color: AppColores.colorSecundario,
        ),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: AppEstiloTexto.textoSecundario.copyWith(
            fontSize: 13,
          ),
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