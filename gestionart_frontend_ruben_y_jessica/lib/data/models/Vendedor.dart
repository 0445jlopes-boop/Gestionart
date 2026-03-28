import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';

class Vendedor extends Usuario { // Clase vendedor
  final String descripcionPerfil;

  Vendedor({required super.id, required super.correoElectronico, required super.nombre, required super.imagen, required super.contrasena, required super.contrasena2, required super.rol, required this.descripcionPerfil});
  
}
