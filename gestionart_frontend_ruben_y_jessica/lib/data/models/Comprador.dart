import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoCuentaComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';

class Comprador extends Usuario{ //Clase comprador
 final String direccion;
 final Tipocuentacomprador tipoCuenta;
 final DateTime fechaInicioPremium;
 final DateTime fechafinPremium;

  Comprador({
    required super.id, 
    required super.correoElectronico, 
    required super.nombre, 
    required super.imagen, 
    required super.contrasena, 
    required super.contrasena2, 
    required super.rol, 
    required this.direccion, 
    required this.tipoCuenta, 
    required this.fechaInicioPremium, 
    required this.fechafinPremium
  });
 
}
