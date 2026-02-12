import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/LogicaComprador.dart';
class Controllercomprador { // Controlador que permite gestionar los Compradores de la aplicación.
  static bool compradorExiste(String nombre, String contrasena){ // Verifico si un comprador exixte
    bool esta = false;
    LogicaComprador.getListaCompradores().forEach((comprador)
    {
      if(comprador.getNombre()==nombre && comprador.getContrasena()==contrasena ){
        esta=true;
      }
    });
    return esta;
  }
  static Comprador? extraerComprador(String nombre, String contrasena){ // Busco al comprador concreto según el nombre y la contraseña y lo recupero
    for (var i = 0; i < LogicaComprador.getListaCompradores().length; i++) {
      if(LogicaComprador.getListaCompradores()[i].getNombre()==nombre && LogicaComprador.getListaCompradores()[i].getContrasena()==contrasena){
        return LogicaComprador.getListaCompradores()[i];
      }
    }
    return null;
  }
}