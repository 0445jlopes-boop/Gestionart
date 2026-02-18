import 'package:gestionart_frontend_ruben_y_jessica/models/Aticulo.dart';

class LogicaArticulo {
  static final List<Articulo> _listArticulos = [
  Articulo(titulo: 'Digital Dreams', categoria: 'Arte Digital', precio: 150, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Neon Future', categoria: 'Arte Digital', precio: 180, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Soft Portrait', categoria: 'Ilustración', precio: 90, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Fantasy Sketch', categoria: 'Ilustración', precio: 110, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Samurai Spirit', categoria: 'Anime / Manga', precio: 120, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Kawaii World', categoria: 'Anime / Manga', precio: 130, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'True Face', categoria: 'Realismo', precio: 200, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Urban Reality', categoria: 'Realismo', precio: 210, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Color Storm', categoria: 'Abstracto', precio: 170, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Broken Shapes', categoria: 'Abstracto', precio: 160, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Less is More', categoria: 'Minimalismo', precio: 95, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'White Silence', categoria: 'Minimalismo', precio: 100, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Concrete Jungle', categoria: 'Street Art', precio: 220, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'City Lights', categoria: 'Street Art', precio: 240, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Wild Letters', categoria: 'Graffiti', precio: 190, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Spray Revolution', categoria: 'Graffiti', precio: 210, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Stone Soul', categoria: 'Escultura', precio: 350, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Metal Form', categoria: 'Escultura', precio: 380, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Virtual Shape', categoria: 'Arte 3D', precio: 260, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Digital Sculpture', categoria: 'Arte 3D', precio: 280, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Green Harmony', categoria: 'Arte Ecológico', precio: 200, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Recycled Beauty', categoria: 'Arte Ecológico', precio: 215, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Live the Life', categoria: 'Indie', precio: 100, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Indie Mood', categoria: 'Indie', precio: 115, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Electric Vibes', categoria: 'Rock Art', precio: 140, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Rebel Sound', categoria: 'Rock Art', precio: 155, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Hidden Meaning', categoria: 'Conceptual', precio: 175, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Deep Thought', categoria: 'Conceptual', precio: 190, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Funny Faces', categoria: 'Caricatura', precio: 85, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Comic Style', categoria: 'Caricatura', precio: 95, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Floral Dream', categoria: 'Cottagecore', precio: 130, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Pastel Garden', categoria: 'Cottagecore', precio: 145, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Neon Sunset', categoria: 'Vaporwave', precio: 160, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Retro Future', categoria: 'Vaporwave', precio: 175, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Hero Tribute', categoria: 'Fan Art', precio: 150, imagen: '/assets/images/defaultArticulo.png'),
  Articulo(titulo: 'Fantasy Tribute', categoria: 'Fan Art', precio: 165, imagen: '/assets/images/defaultArticulo.png'),

]; 
static List<Articulo> obtenerPorCategoria(String categoria) {
  return _listArticulos.where((articulo) => articulo.categoria.toLowerCase() == categoria).toList(); //Operacion Lambda para agilizar el proceso de búsqueda
}


}