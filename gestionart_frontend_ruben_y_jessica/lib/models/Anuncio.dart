class Anuncio { //Calse de anuncios
  int? id;
  String titulo;
  String categoria;
  double precio;
  String imagen;
  String tiempo;

  Anuncio({
    this.id,
    required this.titulo,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.tiempo,
  });
}
