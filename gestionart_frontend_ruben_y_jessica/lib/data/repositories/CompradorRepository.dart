

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Compradorrepository {

  final ApiService _apiService;
  Compradorrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<bool> actualizarComprador(int id, String correoElectronico, String nombre, String direccion, String imagen, String contrasena) async {
    try {
      final response = await _apiService.dio.put("/compradores/$id", data: {
        "correoElectronico": correoElectronico,
        "nombre": nombre,
        "direccion": direccion,
        "imagen": imagen,
        "contrasena": contrasena
      });
      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception("Error al actualizar el comprador: $e");
    }
  }

  Future<bool> activarPremium(int id) async {
    try {
      final response = await _apiService.dio.put("/compradores/$id/activar-premium");
      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception("Error al activar el premium: $e");
    }
  }

  Future<bool> desactivarPremium(int id) async {
    try {
      final response = await _apiService.dio.put("/compradores/$id/desactivar-premium");
      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception("Error al desactivar el premium: $e");
    }
  }

  Future<List<Comprador>?> getCompradores() async {
    try {
      final response = await _apiService.dio.get("/compradores");
          return (response.data as List)
          .map((json) => Comprador.fromJson(json))
          .toList();
      
    } catch (e) {
      throw Exception("Error al obtener los compradores: $e");
    }
  }

  Future<Comprador?> getCompradorPorId(int id) async {
    try {
      final response = await _apiService.dio.get("/compradores/$id");
      return Comprador.fromJson(response.data);

    } catch (e) {
      throw Exception("Error al obtener el comprador por ID: $e");
    }
  }

  Future<Comprador?> getCompradorPorCorreoElectronico(String correoElectronico) async {
    try {
      final response = await _apiService.dio.get("/compradores/correo/$correoElectronico");
      if (response.statusCode == 200) {
        return Comprador.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error al obtener el comprador por correo electrónico: $e");
    }
  }

  Future<Comprador?> getCompradorPorNombre(String nombre) async {
    try {
      final response = await _apiService.dio.get("/compradores/nombre/$nombre");
      if (response.statusCode == 200) {
        return Comprador.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error al obtener el comprador por nombre: $e");
    }
  }

  Future<bool> eliminarComprador(int id) async {
    try {
      final response = await _apiService.dio.delete("/compradores/$id");
      if (response.statusCode != 200) {
       return false;
      }
      return true;
    } catch (e) {
      throw Exception("Error al eliminar el comprador: $e");
    }
  }

  
}
