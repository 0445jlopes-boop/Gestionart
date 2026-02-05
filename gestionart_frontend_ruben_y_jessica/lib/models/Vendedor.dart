import 'package:gestionart_frontend_ruben_y_jessica/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Aticulo.dart';

class Vendedor {
  String correoElectronico;
  String nombre;
  String imagen;
  String contrasena;
  List<Articulo> listaArticulos = [];
  List<Anuncio>? listaAnuncios = [];


  Vendedor({
    required this.correoElectronico,
    required this.nombre,
    required this.imagen,
    required this.contrasena,
    required this.listaAnuncios,
    required this.listaArticulos,
  });
}
