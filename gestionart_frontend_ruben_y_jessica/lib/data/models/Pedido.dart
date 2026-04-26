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

  Long getId() {
    return id;
  }
  Long getIdComprador() {
    return idComprador;
  }
  Long getIdVendedor() {
    return idVendeodr;
  }
  Estadopedido getEstado() {
    return estado;
  }
  List<Lineapedido> getLineas() {
    return lineas;
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      idComprador: json['idComprador'],
      idVendeodr: json['idVendedor'],
      estado: Estadopedido.values.firstWhere((e) => e.toString() == 'Estadopedido.' + json['estado']),
      lineas: (json['lineas'] as List).map((json) => Lineapedido.fromJson(json)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idComprador': idComprador,
      'idVendedor': idVendeodr,
      'estado': estado.toString().split('.').last,
      'lineas': lineas.map((linea) => linea.toJson()).toList()
    };
  }


}
