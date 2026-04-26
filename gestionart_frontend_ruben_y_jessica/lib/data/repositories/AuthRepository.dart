import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Authrepository {

  final ApiService _apiService;
  Authrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<bool> login(String correoElectronico, String contrasena) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/auth/login", data: {
        "correoElectronico": correoElectronico,
        "contrasena": contrasena
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error al iniciar sesión: $e");
    }
  }

  Future<bool> registerComprador(String correoElectronico, String nombre, String direccion, String imagen) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/auth/registerComprador", data: {
        "correoElectronico": correoElectronico,
        "nombre": nombre,
        "direccion": direccion,
        "imagen": imagen
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error al registrar usuario: $e");
    }
  }

  Future<bool> registerVendedor(String correoElectronico, String nombre, String descripcionPerfil, String imagen) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/auth/registerVendedor", data: {
        "correoElectronico": correoElectronico,
        "nombre": nombre,
        "descripcionPerfil": descripcionPerfil,
        "imagen": imagen
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error al registrar usuario: $e");
    }
  }

}
     