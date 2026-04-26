import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';

class Notificacion {
  final Long id;
  final Long vendedorId;
  final Tiponotificacion tipo;
  final bool leido;
  final DateTime fecha;

  Notificacion({required this.id, required this.vendedorId, required this.tipo, required this.leido, required this.fecha});
  
  Long getId() {
    return id;
  }
  Long getVendedorId() {
    return vendedorId;
  }
  Tiponotificacion getTipo() {
    return tipo;
  }
  bool isLeido() {
    return leido;
  }
  DateTime getFecha() {
    return fecha;
  }

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'],
      vendedorId: json['vendedorId'],
      tipo: Tiponotificacion.values.firstWhere((e) => e.toString() == 'Tiponotificacion.' + json['tipo']),
      leido: json['leido'],
      fecha: DateTime.parse(json['fecha'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendedorId': vendedorId,
      'tipo': tipo.toString().split('.').last,
      'leido': leido,
      'fecha': fecha.toIso8601String()
    };
  }


}