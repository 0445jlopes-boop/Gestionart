class Articulo {
  int? id;
  String titulo;
  String categoria;
  double precio;
  String imagen;
  String? descripcion;

  Articulo({
    this.id,
    required this.titulo,
    required this.categoria,
    required this.precio,
    required this.imagen,
    this.descripcion,
  });
}
