import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Rol.dart';
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

  String getDireccion() {
    return direccion;
  }
  Tipocuentacomprador getTipoCuenta() {
    return tipoCuenta;
  }
  DateTime getFechaInicioPremium() {
    return fechaInicioPremium;
  }
  DateTime getFechafinPremium() {
    return fechafinPremium;
  }

  factory Comprador.fromJson(Map<String, dynamic> json) {
    return Comprador(
      id: json['id'],
      correoElectronico: json['correoElectronico'],
      nombre: json['nombre'],
      imagen: json['imagen'],
      contrasena: json['contrasena'],
      contrasena2: json['contrasena2'],
      rol: Rol.values.firstWhere((e) => e.toString() == 'Rol.' + json['rol']),
      direccion: json['direccion'],
      tipoCuenta: Tipocuentacomprador.values.firstWhere((e) => e.toString() == 'Tipocuentacomprador.' + json['tipoCuenta']),
      fechaInicioPremium: DateTime.parse(json['fechaInicioPremium']),
      fechafinPremium: DateTime.parse(json['fechafinPremium'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correoElectronico': correoElectronico,
      'nombre': nombre,
      'imagen': imagen,
      'contrasena': contrasena,
      'contrasena2': contrasena2,
      'rol': rol.toString().split('.').last,
      'direccion': direccion,
      'tipoCuenta': tipoCuenta.toString().split('.').last,
      'fechaInicioPremium': fechaInicioPremium.toIso8601String(),
      'fechafinPremium': fechafinPremium.toIso8601String()
    };
  }
  
 
}
