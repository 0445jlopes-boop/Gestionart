import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class ArticuloRepository {
  final ApiService _apiService;
  
  ArticuloRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();  

  // ✅ CORREGIDO - Retornar bool
  Future<bool> actualizarArticulo(
    int id, 
    String titulo, 
    String descripcion, 
    double precio, 
    String imagen, 
    String categoria, 
    int stock
  ) async {
    try {
      final response = await _apiService.dio.put("/articulos/$id", data: {
        "titulo": titulo,
        "descripcion": descripcion,
        "precio": precio,
        "imagen": imagen,
        "categoria": categoria, 
        "stock": stock
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Error al actualizar el artículo: $e");
      return false;
    }
  }

  // ✅ CORREGIDO - Retornar bool
  Future<bool> crearArticulo(
    String titulo, 
    String descripcion, 
    double precio, 
    String imagen, 
    String categoria, 
    int stock
  ) async {
    try {
      final response = await _apiService.dio.post("/articulos", data: {
        "titulo": titulo,
        "descripcion": descripcion,
        "precio": precio,
        "imagen": imagen,
        "categoria": categoria, 
        "stock": stock
      });
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error al crear el artículo: $e");
      return false;
    }
  }

  Future<Articulo?> obtenerArticulo(int id) async {
    try {
      final response = await _apiService.dio.get("/articulos/$id");
      if (response.statusCode == 200) {
        return Articulo.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error al obtener el artículo: $e");
      return null;
    }
  }

  Future<List<Articulo>> obtenerArticulos() async {
    try {
      final response = await _apiService.dio.get("/articulos");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error al obtener los artículos: $e");
      return [];
    }
  }

  Future<List<Articulo>> articulosPorCategoria(String categoria) async {
    try {
      final response = await _apiService.dio.get("/articulos/categoria/$categoria");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error al obtener los artículos por categoría: $e");
      return [];
    }
  }

  Future<List<Articulo>> articulosPorVendedor(int vendedorId) async {
    try {
      final response = await _apiService.dio.get("/articulos/vendedor/$vendedorId");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error al obtener los artículos por vendedor: $e");
      return [];
    }
  }

  // ✅ CORREGIDO - Retornar bool
  Future<bool> eliminarArticulo(int id) async {
    try {
      final response = await _apiService.dio.delete("/articulos/$id");
      return response.statusCode == 200;
    } catch (e) {
      print("Error al eliminar el artículo: $e");
      return false;
    }
  }
}
