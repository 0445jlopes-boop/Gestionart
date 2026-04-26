import 'dart:ffi';

class Lineapedido {
  final Long id;
  final Long idPedido;
  final Long idArticulo;
  final int cantidad;
  final double precioUnitario;

  Lineapedido({required this.id, required this.idPedido, required this.idArticulo, required this.cantidad, required this.precioUnitario});

  Long getId() {
    return id;
  }
  Long getIdPedido() {
    return idPedido;
  }
  Long getIdArticulo() {
    return idArticulo;
  }
  int getCantidad() {
    return cantidad;
  }
  double getPrecioUnitario() {
    return precioUnitario;
  }

  factory Lineapedido.fromJson(Map<String, dynamic> json) {
    return Lineapedido(
      id: json['id'],
      idPedido: json['idPedido'],
      idArticulo: json['idArticulo'],
      cantidad: json['cantidad'],
      precioUnitario: json['precioUnitario']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPedido': idPedido,
      'idArticulo': idArticulo,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario
    };
  }
  
}