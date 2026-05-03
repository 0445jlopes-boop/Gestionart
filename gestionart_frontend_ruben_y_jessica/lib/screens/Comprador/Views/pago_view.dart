import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:provider/provider.dart';

class pago_view extends StatefulWidget {
  const pago_view({super.key, required this.pago});
  final Tipopago pago;

  @override
  State<pago_view> createState() => _pago_viewState();
}

class _pago_viewState extends State<pago_view> {
  @override
  Widget build(BuildContext context) {
    final compradorProvider = Provider.of<Compradorprovider>(context);
    return SingleChildScrollView(
    );
  }
}