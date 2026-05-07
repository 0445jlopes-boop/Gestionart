import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';

class Notificacion {
  final int id;
  final int vendedorId;
  final Tiponotificacion tipo;
  final bool leido;
  final DateTime fecha;

  Notificacion({
    required this.id, 
    required this.vendedorId, 
    required this.tipo, 
    required this.leido, 
    required this.fecha
  });
  
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
      tipo: Tiponotificacion.values.firstWhere(
        (e) => e.toString().split('.').last == (json['tipo'] ?? 'NUEVO_PEDIDO'),
        orElse: () => Tiponotificacion.NUEVO_PEDIDO,
      ),
      leido: json['leido'] ?? false,
      fecha: json['fecha'] != null 
          ? DateTime.parse(json['fecha']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendedorId': vendedorId,
      'tipo': tipo.toString().split('.').last,
      'leido': leido,
      'fecha': fecha.toIso8601String(),
    };
  }
}