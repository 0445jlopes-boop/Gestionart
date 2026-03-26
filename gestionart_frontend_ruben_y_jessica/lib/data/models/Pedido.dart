import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';

class Pedido { //Clase pedido
  final Long id;
  final Long idComprador;
  final Long idVendeodr;
  final Estadopedido estado;
  final List<Lineapedido> lineas;

  Pedido({required this.id, required this.idComprador, required this.idVendeodr, required this.estado, required this.lineas});
}
