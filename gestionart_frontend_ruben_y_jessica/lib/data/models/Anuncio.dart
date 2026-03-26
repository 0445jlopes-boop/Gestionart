import 'dart:ffi';

class Anuncio { //Calse de anuncios
  final Long id;
  final String titulo;
  final String categoria;
  final double precio;
  final String imagen;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final Long idVendedor;
  final bool activo;


  Anuncio({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.fechaInicio, 
    required this.fechaFin, 
    required this.idVendedor, 
    required this.activo,
  });
}
