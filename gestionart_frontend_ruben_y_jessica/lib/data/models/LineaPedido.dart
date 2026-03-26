import 'dart:ffi';

class Lineapedido {
  final Long id;
  final Long idPedido;
  final Long idArticulo;
  final int cantidad;
  final double precioUnitario;

  Lineapedido({required this.id, required this.idPedido, required this.idArticulo, required this.cantidad, required this.precioUnitario});

  
}