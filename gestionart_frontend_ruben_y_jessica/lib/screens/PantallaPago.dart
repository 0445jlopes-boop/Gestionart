import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/NotificacionProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/StripeProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/PantallaInicioComprador.dart';
import 'package:provider/provider.dart';

class pago_view extends StatefulWidget {
  const pago_view({
    super.key, 
    required this.pago,
    required this.importe,
    this.comprador,
    this.vendedor,
    this.anuncio,
    this.pedido,
  });
  
  final Tipopago pago;
  final double importe;
  final Comprador? comprador;
  final Vendedor? vendedor;
  final Anuncio? anuncio;
  final Pedido? pedido;

  @override
  State<pago_view> createState() => _pago_viewState();
}

class _pago_viewState extends State<pago_view> {
  final _formKey = GlobalKey<FormState>();

  final numeroController = TextEditingController();
  final nombreController = TextEditingController();
  final fechaController = TextEditingController();
  final cvvController = TextEditingController();
  
  bool _isProcessing = false;
  Comprador? _compradorActualizado;

  String _getTipoPagoText() {
    switch (widget.pago) {
      case Tipopago.PEDIDO:
        return "pedido";
      case Tipopago.SUSCRIPCION:
        return "suscripción premium";
      case Tipopago.PUBLICIDAD:
        return "publicidad";
    }
  }
  
  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  String _getEstadoTexto(String estado) {
    switch (estado) {
      case "PENDIENTE": return "Pendiente";
      case "CONFIRMADO": return "Confirmado";
      case "PROCESANDO": return "Procesando";
      case "FINALIZADO": return "Finalizado";
      default: return estado;
    }
  }

  void _navegarAInicio(Comprador comprador) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Pantallainiciocomprador(
          comprador: comprador,
        ),
      ),
      (route) => false,
    );
  }

  Future<void> _procesarPago() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.pedido!.estado.toString().split('.').last == "FINALIZADO") {
      if (mounted) {
        _mostrarDialogoExito(
          "Pedido ya procesado",
          "Este pedido ya ha sido procesado anteriormente.",
          Icons.info,
          () {
            Navigator.pop(context, true);
          },
        );
      }
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final stripeProvider = context.read<Stripeprovider>();
      
      final pagoExitoso = await stripeProvider.crearPago();
      
      if (pagoExitoso) {
        switch (widget.pago) {
          case Tipopago.PEDIDO:
            await _procesarPagoPedido();
            break;

          case Tipopago.SUSCRIPCION:
            await _procesarSuscripcion();
            break;

          case Tipopago.PUBLICIDAD:
            await _procesarPublicidad();
            break;
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error en el pago. Inténtalo de nuevo."),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al procesar el pago: $e"), backgroundColor: Colors.red),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _procesarPagoPedido() async {
  try {
    if (widget.pedido == null) {
      throw Exception("No se encontró el pedido");
    }

    final pedidoProvider = context.read<Pedidoprovider>();
    final articuloProvider = context.read<Articuloprovider>();
    final lineaPedidoProvider = context.read<Lineapedidoprovider>();
    final notificacionProvider = context.read<NotificacionProvider>();

    // 1. Cambiar estado del pedido
    await pedidoProvider.cambiarEstado(widget.pedido!.id);
    final pedidoActualizado = await pedidoProvider.cambiarEstado(widget.pedido!.id);

    // 2. Obtener las líneas del pedido
    final lineas = await lineaPedidoProvider.fetchLineasPedidoPorPedido(widget.pedido!.id);
    
    // 3. Obtener el vendedor del primer artículo de la línea
    int? idVendedor = null;
    if (lineas.isNotEmpty) {
      final articulo = await articuloProvider.obtenerArticulo(lineas.first.idArticulo);
      if (articulo != null) {
        idVendedor = articulo.idVendedor;
        print("🔍 Vendedor obtenido del artículo: $idVendedor");
      }
    }

    // 4. Disminuir stock
    for (var linea in lineas) {
      final articulo = await articuloProvider.obtenerArticulo(linea.idArticulo);
      if (articulo != null && mounted) {
        final nuevoStock = articulo.stock - linea.cantidad;
        if (nuevoStock >= 0) {
          await articuloProvider.actualizarArticulo(
            articulo.id, articulo.titulo, articulo.descripcion,
            articulo.precio, articulo.imagen, articulo.categoria, nuevoStock,
          );
        }
      }
    }

    // 5. Crear notificación para el vendedor (solo si tenemos idVendedor)
    if (idVendedor != null && idVendedor > 0) {
      await notificacionProvider.crearNotificacion(
        idVendedor,
        Tiponotificacion.NUEVO_PEDIDO,
      );
      print("✅ Notificación enviada al vendedor $idVendedor");
    } else {
      print("⚠️ No se pudo obtener el vendedor, notificación no enviada");
    }

    if (mounted) {
      _mostrarDialogoExito(
        "¡Pedido completado!",
        "Tu pedido #${widget.pedido!.id} ha sido procesado correctamente.\n\n"
        "Total pagado: ${widget.importe.toStringAsFixed(2)} €",
        Icons.shopping_bag,
        () {
          Navigator.pop(context, true);
        },
      );
    }
  } catch (e) {
    print("❌ Error al procesar pedido: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
      setState(() => _isProcessing = false);
    }
  }
}

  Future<void> _procesarSuscripcion() async {
    try {
      final compradorProvider = context.read<Compradorprovider>();

      final activado = await compradorProvider.activarPremium(widget.comprador!.id);

      if (activado) {
        _compradorActualizado = await compradorProvider.obtenerComprador(widget.comprador!.id);

        if (mounted) {
          _mostrarDialogoExito(
            "¡Suscripción Premium Activada!",
            "Disfruta de todos los beneficios premium durante 3 meses.\n\n"
            "Fecha de inicio: ${_formatearFecha(_compradorActualizado!.fechaInicioPremium!)}\n"
            "Fecha de fin: ${_formatearFecha(_compradorActualizado!.fechafinPremium!)}",
            Icons.star,
            () {
              Navigator.pop(context, _compradorActualizado);
            },
          );
        }
      } else {
        if (mounted) {
          _mostrarDialogoExito(
            "¡Pago completado!",
            "El pago fue exitoso, pero hubo un problema activando el premium. Contacta con soporte.",
            Icons.warning,
            () {
              Navigator.pop(context, widget.comprador);
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _mostrarDialogoExito(
          "¡Pago completado!",
          "Error al activar premium: $e",
          Icons.warning,
          () {
            Navigator.pop(context, widget.comprador);
          },
        );
      }
    }
  }

  Future<void> _procesarPublicidad() async {
    try {
      if (mounted) {
        _mostrarDialogoExito(
          "¡Pago completado!",
          "El pago de ${widget.importe.toStringAsFixed(2)}€ se ha procesado correctamente.\n\nAhora puedes publicar tu anuncio.",
          Icons.campaign,
          () {
            Navigator.pop(context, true);
          },
        );
      }
    } catch (e) {
      print("❌ Error en pago de publicidad: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  void _mostrarDialogoExito(String titulo, String mensaje, IconData icono, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(
                icono,
                size: 60,
                color: AppColores.colorPrimario,
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                style: AppEstiloTexto.textoPrincipal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            mensaje,
            style: AppEstiloTexto.textoSecundario,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColores.colorPrimario,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text("PROCESE SU PAGO", style: AppEstiloTexto.encabezado),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                Text(
                  "PAGO MEDIANTE TARJETA DE CRÉDITO",
                  style: AppEstiloTexto.textoPrincipal,
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColores.colorPrimario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColores.colorPrimario.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColores.colorPrimario,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Va a pagar ${widget.importe.toStringAsFixed(2)} € por ${_getTipoPagoText()}",
                        style: AppEstiloTexto.textoPrincipal.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.pago == Tipopago.PEDIDO && widget.pedido != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Pedido #${widget.pedido!.id}",
                            style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColores.colorFondo,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColores.colorSecundario.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Total a pagar:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.importe.toStringAsFixed(2)} €",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColores.colorSecundario,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: numeroController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Número de tarjeta",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        validator: validarNumeroTarjeta,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nombreController,
                        decoration: const InputDecoration(
                          labelText: "Nombre del titular",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Introduce el nombre" : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: fechaController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: "MM/AA",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: validarFecha,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: cvvController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "CVV",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                              ),
                              validator: validarCVV,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _procesarPago,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColores.colorSecundario,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Pagar ahora",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    numeroController.dispose();
    nombreController.dispose();
    fechaController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  // VALIDACIONES
  String? validarNumeroTarjeta(String? value) {
    if (value == null || value.isEmpty) {
      return "Introduce el número de tarjeta";
    }
    String cleaned = value.replaceAll(' ', '');
    if (cleaned.length < 13 || cleaned.length > 19) {
      return "Número inválido (13-19 dígitos)";
    }
    if (!_luhnCheck(cleaned)) {
      return "Tarjeta no válida";
    }
    return null;
  }

  bool _luhnCheck(String number) {
    int sum = 0;
    bool alternate = false;
    for (int i = number.length - 1; i >= 0; i--) {
      int n = int.parse(number[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }

  String? validarFecha(String? value) {
    if (value == null || value.isEmpty) return "Introduce la fecha";
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!regex.hasMatch(value)) return "Formato inválido (MM/AA)";
    final parts = value.split('/');
    int mes = int.parse(parts[0]);
    int anio = int.parse(parts[1]) + 2000;
    final now = DateTime.now();
    final fechaTarjeta = DateTime(anio, mes, 28);
    if (fechaTarjeta.isBefore(DateTime(now.year, now.month, 1))) {
      return "Tarjeta caducada";
    }
    return null;
  }

  String? validarCVV(String? value) {
    if (value == null || value.isEmpty) return "Introduce el CVV";
    if (value.length < 3 || value.length > 4) return "CVV inválido (3-4 dígitos)";
    return null;
  }
}