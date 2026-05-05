import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Rol.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';

class Vendedor extends Usuario { // Clase vendedor
  final String descripcionPerfil;

  Vendedor({required super.id, required super.correoElectronico, required super.nombre, required super.imagen, required super.contrasena, required super.contrasena2, required super.rol, required this.descripcionPerfil});
  

  String getDescripcionPerfil() {
    return descripcionPerfil;
  }

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: json['id'] ?? 0,
      correoElectronico: json['correoElectronico'] ?? '',
      nombre: json['nombre'] ?? '',
      imagen: json['imagen'] ?? '',
      contrasena: json['contrasena'] ?? '',
      contrasena2: json['contrasena2'] ?? '',
      rol: Rol.VENDEDOR,
      descripcionPerfil: json['descripcionPerfil'] ?? ''
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
      'rol': Rol.VENDEDOR.toString(),
      'descripcionPerfil': descripcionPerfil ?? ''
    };
  }
}
