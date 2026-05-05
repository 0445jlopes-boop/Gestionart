

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';

class Notificacion {
  final int id;
  final int vendedorId;
  final Tiponotificacion tipo;
  final bool leido;
  final DateTime fecha;

  Notificacion({required this.id, required this.vendedorId, required this.tipo, required this.leido, required this.fecha});
  
  int getId() {
    return id;
  }
  int getVendedorId() {
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
      id: json['id'] ?? 0,
      vendedorId: json['vendedorId'] ?? 0,
      tipo: Tiponotificacion.values.firstWhere((e) => e.toString() == 'Tiponotificacion.' + (json['tipo'] ?? ''), orElse: () => Tiponotificacion.values.first),
      leido: json['leido'] ?? false,
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String())
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'vendedorId': vendedorId ?? 0,
      'tipo': tipo.toString().split('.').last ?? Tiponotificacion.values.first.toString().split('.').last,
      'leido': leido ?? false,
      'fecha': fecha.toIso8601String() ?? DateTime.now().toIso8601String()
    };
  }


}