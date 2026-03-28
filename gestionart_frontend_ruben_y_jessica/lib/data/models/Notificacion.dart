import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';

class Notificacion {
  final Long id;
  final Long vendedorId;
  final Tiponotificacion tipo;
  final bool leido;
  final DateTime fecha;

  Notificacion({required this.id, required this.vendedorId, required this.tipo, required this.leido, required this.fecha});
  
}