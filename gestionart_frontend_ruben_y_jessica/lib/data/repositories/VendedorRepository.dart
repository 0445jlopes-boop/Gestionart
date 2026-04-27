import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Vendedorrepository {

  final ApiService apiService;
  Vendedorrepository(ApiService? apiService) : apiService = apiService ?? ApiService();

  Future<void> actualizarVendedor(Long id, String correoElectronico, String nombre, String descripcionPerfil, String imagen, String contrasena) async {
    try {
      final response = await apiService.dio.put("http://localhost:8080/vendedores/$id", data: {
        "correoElectronico": correoElectronico,
        "nombre": nombre,
        "descripcionPerfil": descripcionPerfil,
        "imagen": imagen,
        "contrasena": contrasena
      });
      if (response.statusCode != 200) {
        throw Exception("Error al actualizar el vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al actualizar el vendedor: $e");
    }
  }

  Future<List<Vendedor>> getVendedores() async {
    try {
      final response = await apiService.dio.get("http://localhost:8080/vendedores");
      if (response.statusCode == 200) {
        List<Vendedor> vendedores = [];
        for (var item in response.data) {
          vendedores.add(Vendedor.fromJson(item));
        }
        return vendedores;
      } else {
        throw Exception("Error al obtener los vendedores: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los vendedores: $e");
    }
  }
  Future<Vendedor> getVendedorPorId(Long id) async {
    try {
      final response = await apiService.dio.get("http://localhost:8080/vendedores/$id");
      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el vendedor por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el vendedor por ID: $e");
    }
  }

  Future<Vendedor> getVendedorPorCorreoElectronico(String correoElectronico) async {
    try {
      final response = await apiService.dio.get("http://localhost:8080/vendedores/correo/$correoElectronico");
      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el vendedor por correo electrónico: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el vendedor por correo electrónico: $e");
    }
  }

  Future<Vendedor> getVendedorPorNombre(String nombre) async {
    try {
      final response = await apiService.dio.get("http://localhost:8080/vendedores/nombre/$nombre");
      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el vendedor por nombre: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el vendedor por nombre: $e");
    }
  }

  Future<void> eliminarVendedor(Long id) async {
    try {
      final response = await apiService.dio.delete("http://localhost:8080/vendedores/$id");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar el vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar el vendedor: $e");
    }
  }
  
}