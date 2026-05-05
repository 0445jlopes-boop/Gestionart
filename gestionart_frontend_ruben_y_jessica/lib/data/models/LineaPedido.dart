

class Lineapedido {
  final int id;
  final int idPedido;
  final int idArticulo;
  final int cantidad;
  final double precioUnitario;

  Lineapedido({required this.id, required this.idPedido, required this.idArticulo, required this.cantidad, required this.precioUnitario});

  int getId() {
    return id;
  }
  int getIdPedido() {
    return idPedido;
  }
  int getIdArticulo() {
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
      id: json['id'] ?? 0,
      idPedido: json['idPedido'] ?? 0,
      idArticulo: json['idArticulo'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      precioUnitario: (double.tryParse(json['precioUnitario'])) ?? 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idPedido': idPedido ?? 0,
      'idArticulo': idArticulo ?? 0,
      'cantidad': cantidad ?? 0,
      'precioUnitario': precioUnitario ?? 0.0
    };
  }
  
}