import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Vendedorrepository {

  final ApiService apiService;
  Vendedorrepository(ApiService? apiService) : apiService = apiService ?? ApiService();

  Future<bool> actualizarVendedor(int id, String correoElectronico, String nombre, String descripcionPerfil, String imagen, String contrasena) async {
    try {
      final response = await apiService.dio.put("/vendedores/$id", data: {
        "correoElectronico": correoElectronico,
        "nombre": nombre,
        "descripcionPerfil": descripcionPerfil,
        "imagen": imagen,
        "contrasena": contrasena
      });
      return response.statusCode == 204;
    } catch (e) {
      print("Error al actualizar el vendedor: $e");
      return false;
    }
  }

  Future<List<Vendedor>?> getVendedores() async {
    try {
      final response = await apiService.dio.get("/vendedores");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Vendedor.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error al obtener los vendedores: $e");
      return [];
    }
  }

  Future<Vendedor?> getVendedorPorId(int id) async {
    try {
      final response = await apiService.dio.get("/vendedores/$id");
      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error al obtener el vendedor por ID: $e");
      return null;
    }
  }

  Future<Vendedor?> getVendedorPorCorreoElectronico(String correoElectronico) async {
    try {
      final response = await apiService.dio.get("/vendedores/correo/$correoElectronico");
      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error al obtener el vendedor por correo: $e");
      return null;
    }
  }

  Future<Vendedor?> getVendedorPorNombre(String nombre) async {
    try {
      final response = await apiService.dio.get("/vendedores/nombre/$nombre");
      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error al obtener el vendedor por nombre: $e");
      return null;
    }
  }

  Future<bool> eliminarVendedor(int id) async {
    try {
      final response = await apiService.dio.delete("/vendedores/$id");
      return response.statusCode == 200;
    } catch (e) {
      print("Error al eliminar el vendedor: $e");
      return false;
    }
  }
}
