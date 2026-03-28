import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';

class LogicaArticulo {
  static final List<Articulo> _listArticulos = [
]; 
static List<Articulo> obtenerPorCategoria(String categoria) {
  return _listArticulos.where((articulo) => articulo.categoria.toLowerCase() == categoria).toList(); //Operacion Lambda para agilizar el proceso de búsqueda
}


}