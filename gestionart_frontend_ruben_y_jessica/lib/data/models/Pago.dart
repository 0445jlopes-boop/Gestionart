import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';

class Pago {
  final Long id;
  final Tipopago tipoPago;
  final Long referenciaId;
  final double importe;
  final Estadopago estado;
  final String referenciaExterna;
  final DateTime fecha;

  Pago({required this.id, required this.tipoPago, required this.referenciaId, required this.importe, required this.estado, required this.referenciaExterna, required this.fecha});
}