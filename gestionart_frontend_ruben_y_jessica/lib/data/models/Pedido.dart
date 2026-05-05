

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';

class Pedido { //Clase pedido
  final int id;
  final int idComprador;
  final int idVendeodr;
  final Estadopedido estado;
  final List<Lineapedido> lineas;

  Pedido({required this.id, required this.idComprador, required this.idVendeodr, required this.estado, required this.lineas});

  int getId() {
    return id;
  }
  int getIdComprador() {
    return idComprador;
  }
  int getIdVendedor() {
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
      id: json['id'] ?? 0,
      idComprador: json['idComprador'] ?? 0,
      idVendeodr: json['idVendedor'] ?? 0,
      estado: Estadopedido.values.firstWhere((e) => e.toString().split('.').last == 'Estadopedido.' + (json['estado'] ?? ''), orElse: () => Estadopedido.values.first),
      lineas: ((json['lineas'] as List?) ?? []).map((json) => Lineapedido.fromJson(json)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idComprador': idComprador ?? 0,
      'idVendedor': idVendeodr ?? 0,
      'estado': estado.toString().split('.').last ?? Estadopedido.CANCELADO,
      'lineas': (lineas ?? []).map((linea) => linea.toJson()).toList()
    };
  }


}
