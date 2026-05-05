

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoSolicitud.dart';

class Solicitudexclusiva {
  final int id;
  final int idComprador;
  final int idArticulo;
  final int idVendedor;
  final String mensage;
  final Estadosolicitud estado;
  final DateTime fecha;

  Solicitudexclusiva({required this.id, required this.idComprador, required this.idArticulo, required this.idVendedor, required this.mensage, required this.estado, required this.fecha});
  
  int getId() {
    return id;
  } 
  int getIdComprador() {
    return idComprador;
  }
  int getIdArticulo() {
    return idArticulo;
  }
  int getIdVendedor() {
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
      id: json['id'] ?? 0,
      idComprador: json['idComprador'] ?? 0,
      idArticulo: json['idArticulo'] ?? 0,
      idVendedor: json['idVendedor'] ?? 0,
      mensage: json['mensage'] ?? '',
      estado: Estadosolicitud.values.firstWhere((e) => e.toString().split('.').last == 'Estadosolicitud.' + (json['estado'] ?? ''), orElse: () => Estadosolicitud.values.first),
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String())
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idComprador': idComprador ?? 0,
      'idArticulo': idArticulo ?? 0,
      'idVendedor': idVendedor ?? 0,
      'mensage': mensage ?? '',
      'estado': estado.toString().split('.').last ?? Estadosolicitud.values.first.toString().split('.').last,
      'fecha': fecha.toIso8601String() ?? DateTime.now().toIso8601String()
    };
  }
}