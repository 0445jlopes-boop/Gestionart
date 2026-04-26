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
  DateTime getFechaInicio() {
    return fechaInicio;
  }
  DateTime getFechaFin() {
    return fechaFin;
  }
  Long getIdVendedor() {
    return idVendedor;
  }
  bool getActivo() {
    return activo;
  }

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    return Anuncio(
      id: json['id'],
      titulo: json['titulo'],
      categoria: json['categoria'],
      precio: json['precio'],
      imagen: json['imagen'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
      idVendedor: json['idVendedor'],
      activo: json['activo']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'precio': precio,
      'imagen': imagen,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'idVendedor': idVendedor,
      'activo': activo
    };
  }
  

}
