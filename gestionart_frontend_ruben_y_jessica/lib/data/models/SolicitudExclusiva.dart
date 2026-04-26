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
  
  Long getId() {
    return id;
  } 
  Long getIdComprador() {
    return idComprador;
  }
  Long getIdArticulo() {
    return idArticulo;
  }
  Long getIdVendedor() {
    return idVendedor;
  }
  String getMensage() {
    return mensage;
  }
  Estadosolicitud getEstado() {
    return estado;
  }
  DateTime getFecha() {
    return fecha;
  }
  


  factory Solicitudexclusiva.fromJson(Map<String, dynamic> json) {
    return Solicitudexclusiva(
      id: json['id'],
      idComprador: json['idComprador'],
      idArticulo: json['idArticulo'],
      idVendedor: json['idVendedor'],
      mensage: json['mensage'],
      estado: Estadosolicitud.values.firstWhere((e) => e.toString() == 'Estadosolicitud.' + json['estado']),
      fecha: DateTime.parse(json['fecha'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idComprador': idComprador,
      'idArticulo': idArticulo,
      'idVendedor': idVendedor,
      'mensage': mensage,
      'estado': estado.toString().split('.').last,
      'fecha': fecha.toIso8601String()
    };
  }
}