import 'dart:ffi';

class Suscripcion {
  final Long id;
  final Long idComprador;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool activa;

  Suscripcion({required this.id, required this.idComprador, required this.fechaInicio, required this.fechaFin, required this.activa});
  
}