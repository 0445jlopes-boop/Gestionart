

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Articulocontroller {

  final ApiService _apiService;
  Articulocontroller(ApiService? apiService) : _apiService = apiService ?? ApiService();  

  Future<void> actualizarArticulo(int id, String titulo, String descripcion, double precio, String imagen, String categoria, int stock  ) async {
    try {
      final response = await _apiService.dio.put("/articulos/$id", data: {
        "titulo": titulo,
        "descripcion": descripcion,
        "precio": precio,
        "imagen": imagen,
        "categoria": categoria, 
        "stock": stock

      });
      if (response.statusCode != 200) {
        throw Exception("Error al actualizar el artículo: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al actualizar el artículo: $e");
    }
  }

  Future<void> crearArticulo(String titulo, String descripcion, double precio, String imagen, String categoria, int stock) async {
    try {
      final response = await _apiService.dio.post("/articulos", data: {
        "titulo": titulo,
        "descripcion": descripcion,
        "precio": precio,
        "imagen": imagen,
        "categoria": categoria, 
        "stock": stock
      });
      if (response.statusCode != 201) {
        throw Exception("Error al crear el artículo: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear el artículo: $e");
    }
  }

  Future<Articulo> obtenerArticulo(int id) async {
    try {
      final response = await _apiService.dio.get("/articulos/$id");
      if (response.statusCode == 200) {
        return Articulo.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el artículo: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el artículo: $e");
    }
  }

  Future<List<Articulo>> obtenerArticulos() async {
    try {
      final response = await _apiService.dio.get("/articulos");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los artículos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los artículos: $e");
    }
  }

  Future<List<Articulo>> articulosPorCategoria(String categoria) async {
    try {
      final response = await _apiService.dio.get("/articulos/categoria/$categoria");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los artículos por categoría: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los artículos por categoría: $e");
    }
  }

  Future<List<Articulo>> articulosPorVendedor(int vendedorId) async {
    try {
      final response = await _apiService.dio.get("/articulos/vendedor/$vendedorId");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los artículos por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los artículos por vendedor: $e");
    }
  }


  Future<void> eliminarArticulo(int id) async {
    try {
      final response = await _apiService.dio.delete("/articulos/$id");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar el artículo: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar el artículo: $e");
    }
  }
  
}
