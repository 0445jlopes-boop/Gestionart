import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Rol.dart';

class Usuario {
  final Long id;
  final String correoElectronico;
  final String nombre;
  final String imagen;
  final String contrasena;
  final String contrasena2;
  final Rol rol;

  Usuario({
    required this.id, 
    required this.correoElectronico, 
    required this.nombre, 
    required this.imagen, 
    required this.contrasena, 
    required this.contrasena2, 
    required this.rol
  });
}