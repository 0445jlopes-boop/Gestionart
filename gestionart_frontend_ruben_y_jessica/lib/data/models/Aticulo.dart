import 'dart:ffi';

class Articulo { //Calse de articulos
  final Long id;
  final String titulo;
  final String categoria;
  final double precio;
  final String imagen;
  final String descripcion;
  final int stock;
  final Long idVendedor;

  Articulo({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.descripcion, 
    required this.stock, 
    required this.idVendedor,
  });
}
