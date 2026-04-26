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

  Long getId() {
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
  Long getIdVendedor() {
    return idVendedor;
  }

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id'],
      titulo: json['titulo'],
      categoria: json['categoria'],
      precio: json['precio'],
      imagen: json['imagen'],
      descripcion: json['descripcion'],
      stock: json['stock'],
      idVendedor: json['idVendedor']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'precio': precio,
      'imagen': imagen,
      'descripcion': descripcion,
      'stock': stock,
      'idVendedor': idVendedor
    };
  }
  

}
