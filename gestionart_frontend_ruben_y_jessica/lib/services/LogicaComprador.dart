import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';

class LogicaComprador { // Implementa una lista de compradores y métodos sobre esta lista para manejar y "persistir" la información en tiempo de ejecuccion
  static final List<Comprador>  _listaComprador = [
    Comprador(
      correoElectronico: "ejemplo@ejemplo.com", 
      nombre: "Jessi", 
      imagen: null, 
      contrasena: "a", 
      direccion: "c-c2-2-c-12345"
    )
  ];
  static void anadirComprador(Comprador comprador){
    _listaComprador.add(comprador);
  }
  static List<Comprador> getListaCompradores(){
    return _listaComprador;
  }
}