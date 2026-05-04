import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AnuincioProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/StripeProvider.dart';
import 'package:provider/provider.dart';

class pago_view extends StatefulWidget {
  const pago_view({super.key, required this.pago, required this.pedido});
  final Tipopago pago;
  final Pedido pedido;

  @override
  State<pago_view> createState() => _pago_viewState();
}
class _pago_viewState extends State<pago_view> {
  final _formKey = GlobalKey<FormState>();

  final numeroController = TextEditingController();
  final nombreController = TextEditingController();
  final fechaController = TextEditingController();
  final cvvController = TextEditingController();

  double obtenerImporte(Pedidoprovider provider) {
    switch (widget.pago) {
      case Tipopago.PEDIDO:
        return widget.pedido.lineas.fold(0.0, (total, linea)=> total + (linea.cantidad * linea.precioUnitario)); 
      case Tipopago.SUSCRIPCION:
        return 5;
      case Tipopago.PUBLICIDAD:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<Pedidoprovider>(context);
    final compradorProvider = Provider.of<Compradorprovider>(context);
    final stripeProvider = Provider.of<Stripeprovider>(context);
    final publicidadProvider = Provider.of<AnuncioProvider>(context);
    final importe = obtenerImporte(pedidoProvider);

    return Scaffold(
      appBar: AppBar( // Appbar con estilo predefinido 
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text("PROCESE SU PAGO", style: AppEstiloTexto.encabezado),
        ),
      ),
      body:SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "PAGO MEDIANTE TARJETA DE CRÉDITO",
                style: AppEstiloTexto.textoPrincipal,
              ),

              const SizedBox(height: 10),

              Text(
                "Total a pagar: ${importe.toStringAsFixed(2)} €",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: numeroController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de tarjeta",
                  border: OutlineInputBorder(),
                ),
                validator: validarNumeroTarjeta,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre del titular",
                  border: OutlineInputBorder(),
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
                      ),
                      validator: validarCVV,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && await stripeProvider.crearPago()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pago procesado correctamente")),
                    );
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pago no procesado")),
                    );
                  }
                },
                child: const Text("Pagar"),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }

  // VALIDACIONES

  String? validarNumeroTarjeta(String? value) {
    if (value == null || value.isEmpty) {
      return "Introduce el número de tarjeta";
    }

    String cleaned = value.replaceAll(' ', '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return "Número inválido";
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
    if (value == null || value.isEmpty) {
      return "Introduce la fecha";
    }

    final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!regex.hasMatch(value)) {
      return "Formato inválido";
    }

    final parts = value.split('/');
    int mes = int.parse(parts[0]);
    int anio = int.parse(parts[1]) + 2000;

    final now = DateTime.now();
    final fechaTarjeta = DateTime(anio, mes + 1, 0);

    if (fechaTarjeta.isBefore(now)) {
      return "Tarjeta caducada";
    }

    return null;
  }

  String? validarCVV(String? value) {
    if (value == null || value.isEmpty) {
      return "Introduce el CVV";
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV inválido";
    }

    return null;
  }
  
}