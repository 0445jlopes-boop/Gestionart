import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Compradorrepository {

  final ApiService _apiService;
  Compradorrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<void> actualizarComprador(Long id, String correoElectronico, String nombre, String direccion, String imagen, String contrasena) async {
    try {
      final response = await _apiService.dio.put("http://localhost:8080/compradores/$id", data: {
        "correoElectronico": correoElectronico,
        "nombre": nombre,
        "direccion": direccion,
        "imagen": imagen,
        "contrasena": contrasena
      });
      if (response.statusCode != 200) {
        throw Exception("Error al actualizar el comprador: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al actualizar el comprador: $e");
    }
  }

  Future<void> activarPremium(Long id) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/compradores/$id/activar-premium");
      if (response.statusCode != 200) {
        throw Exception("Error al activar el premium: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al activar el premium: $e");
    }
  }

  Future<void> desactivarPremium(Long id) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/compradores/$id/desactivar-premium");
      if (response.statusCode != 200) {
        throw Exception("Error al desactivar el premium: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al desactivar el premium: $e");
    }
  }

  Future<List<Comprador>> getCompradores() async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/compradores");
      if (response.statusCode == 200) {
        List<Comprador> compradores = [];
        for (var item in response.data) {
          compradores.add(Comprador.fromJson(item));
        }
        return compradores;
      } else {
        throw Exception("Error al obtener los compradores: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los compradores: $e");
    }
  }

  Future<Comprador> getCompradorPorId(Long id) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/compradores/$id");
      if (response.statusCode == 200) {
        return Comprador.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el comprador por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el comprador por ID: $e");
    }
  }

  Future<Comprador> getCompradorPorCorreoElectronico(String correoElectronico) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/compradores/correo/$correoElectronico");
      if (response.statusCode == 200) {
        return Comprador.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el comprador por correo electrónico: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el comprador por correo electrónico: $e");
    }
  }

  Future<Comprador> getCompradorPorNombre(String nombre) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/compradores/nombre/$nombre");
      if (response.statusCode == 200) {
        return Comprador.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el comprador por nombre: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el comprador por nombre: $e");
    }
  }

  Future<void> eliminarComprador(Long id) async {
    try {
      final response = await _apiService.dio.delete("http://localhost:8080/compradores/$id");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar el comprador: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar el comprador: $e");
    }
  }

  
}