import 'package:gestionart_frontend_ruben_y_jessica/services/LogicaComprador.dart';

class ControllerGeneral { // Controlamos parámetros generales.
  static bool nombreEnUso(String nombre){ // Comprobamos si un nombre ya está en uso
    bool esta=false;
    LogicaComprador.getListaCompradores().forEach((comprador){
      if(comprador.getNombre()==nombre ){
        esta= true;
      }
    });
    return esta;
  }
  static bool emailEnUso(String email){ // Comprobaos si la cuenta de gmail ya está iniciada
    bool esta=false;
    LogicaComprador.getListaCompradores().forEach((comprador){
      if(comprador.getCorreoElectronico()==email ){
        esta= true;
      }
    });
    return esta;
  }
}