import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoSolicitud.dart';

class Solicitudexclusiva {
  final Long id;
  final Long idComprador;
  final Long idArticulo;
  final Long idVendedor;
  final String mensage;
  final Estadosolicitud estado;
  final DateTime fecha;

  Solicitudexclusiva({required this.id, required this.idComprador, required this.idArticulo, required this.idVendedor, required this.mensage, required this.estado, required this.fecha});
  
}