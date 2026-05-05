

class Articulo { //Calse de articulos
  final int id;
  final String titulo;
  final String categoria;
  final double precio;
  final String imagen;
  final String descripcion;
  final int stock;
  final int idVendedor;

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

  int getId() {
    return id;
  }
  String getTitulo() {
    return titulo;
  }
  String getCategoria() {
    return categoria;
  }
  double getPrecio() {
    return precio;
  }
  String getImagen() {
    return imagen;
  }
  String getDescripcion() {
    return descripcion;
  }
  int getStock() {
    return stock;
  }
  int getIdVendedor() {
    return idVendedor;
  }

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      categoria: json['categoria'] ?? '',
      precio: (double.tryParse(json['precio'])) ?? 0.0,
      imagen: json['imagen'] ?? '',
      descripcion: json['descripcion'] ?? '',
      stock: json['stock'] ?? 0,
      idVendedor: json['idVendedor'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'titulo': titulo ?? '',
      'categoria': categoria ?? '',
      'precio': precio ?? 0.0,
      'imagen': imagen ?? '',
      'descripcion': descripcion ?? '',
      'stock': stock ?? 0,
      'idVendedor': idVendedor ?? 0
    };
  }
  

}
