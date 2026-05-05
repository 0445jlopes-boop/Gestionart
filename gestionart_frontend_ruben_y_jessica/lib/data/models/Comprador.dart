import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Rol.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoCuentaComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';

class Comprador extends Usuario{ //Clase comprador
  String direccion;
  Tipocuentacomprador tipoCuenta;
  DateTime fechaInicioPremium;
  DateTime fechafinPremium;

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
    required this.fechafinPremium,
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
    // Función auxiliar para fechas
    DateTime parseFecha(String? fechaStr) {
      if (fechaStr == null || fechaStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(fechaStr);
      } catch (e) {
        return DateTime.now(); // Fallback seguro
      }
    }

    return Comprador(
      id: json['id'] ?? 0,
      correoElectronico: json['correoElectronico'] ?? '',
      nombre: json['nombre'] ?? '',
      imagen: json['imagen'] ?? '',
      contrasena: json['contrasena'] ?? '',
      rol: Rol.COMPRADOR,
      direccion: json['direccion'] ?? '',
      tipoCuenta: Tipocuentacomprador.values.firstWhere(
        (e) => e.toString().split('.').last == (json['tipoCuenta'] ?? 'NORMAL'),
        orElse: () => Tipocuentacomprador.NORMAL,
      ),
      fechaInicioPremium: parseFecha(json['fechaInicioPremium']),
      fechafinPremium: parseFecha(json['fechafinPremium']),
      contrasena2: '', // Considerar si realmente necesario
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
      'rol': rol != null ? rol.toString() : 'COMPRADOR',
      'direccion': direccion ?? '',
      'tipoCuenta': tipoCuenta != null
          ? tipoCuenta.toString().split('.').last 
          : 'NORMAL',
      'fechaInicioPremium': fechaInicioPremium != null
          ? fechaInicioPremium!.toIso8601String()
          : DateTime.now().toIso8601String(),
      'fechafinPremium': fechafinPremium != null
          ? fechafinPremium!.toIso8601String()
          : DateTime.now().toIso8601String(),
    };
  }
}
