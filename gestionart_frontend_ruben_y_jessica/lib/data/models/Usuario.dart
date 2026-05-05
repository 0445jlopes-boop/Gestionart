

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Rol.dart';

class Usuario {
  final int id;
  String correoElectronico;
 String nombre;
 String imagen;
 String contrasena;
 String contrasena2;
 Rol rol;

  Usuario({
    required this.id, 
    required this.correoElectronico, 
    required this.nombre, 
    required this.imagen, 
    required this.contrasena, 
    required this.contrasena2, 
    required this.rol
  });

  int getId() {
    return id;
  }

  String getCorreoElectronico() {
    return correoElectronico;
  }

  String getNombre() {
    return nombre;
  }

  String getImagen() {
    return imagen;
  }

  String getContrasena() {
    return contrasena;
  }

  String getContrasena2() {
    return contrasena2;
  }

  Rol getRol() {
    return rol;
  }


  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      correoElectronico: json['correoElectronico'] ?? '',
      nombre: json['nombre'] ?? '',
      imagen: json['imagen'] ?? '',
      contrasena: json['contrasena'] ?? '',
      contrasena2: json['contrasena2'] ?? '',
     rol: Rol.values.firstWhere(
        (e) => e.toString().split('.').last == (json['rol'] ?? 'COMPRADOR'),
        orElse: () => Rol.COMPRADOR,
      ),
    );
  } 

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'correoElectronico': correoElectronico ?? '',
      'nombre': nombre ?? '',
      'imagen': imagen ?? '',
      'contrasena': contrasena ?? '',
      'contrasena2': contrasena2 ?? '',
      'rol': rol.toString().split('.').last ?? Rol.COMPRADOR.toString(),
    };
  }

}