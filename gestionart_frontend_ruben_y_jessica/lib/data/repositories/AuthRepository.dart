import 'package:dio/dio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Authrepository {

  final ApiService _apiService;
  Authrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<String?> login(String correoElectronico, String contrasena) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/auth/login", data: {"correoElectronico": correoElectronico,"contrasena": contrasena
      }, 
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioException){
        print("STATUS: ${e.response?.statusCode}");
    print("DATA: ${e.response?.data}");
    print("URL: ${e.requestOptions.uri}");
    print("HEADERS: ${e.requestOptions.headers}");
    print(e.requestOptions.uri);
      } else {print ("Error : $e");}
      throw Exception("Error");
    }
  }

  Future<bool> registerComprador(String correoElectronico, String contrasena, String nombre, String direccion, String imagen) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/auth/registerComprador", data: {
        "correoElectronico": correoElectronico,
        "contrasena": contrasena,
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
     