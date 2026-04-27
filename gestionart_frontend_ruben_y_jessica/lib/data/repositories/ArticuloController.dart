import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Articulocontroller {

  final ApiService _apiService;
  Articulocontroller(ApiService? apiService) : _apiService = apiService ?? ApiService();  

  Future<void> actualizarArticulo(Long id, String titulo, String descripcion, double precio, String imagen, String categoria, int stock  ) async {
    try {
      final response = await _apiService.dio.put("http://localhost:8080/articulos/$id", data: {
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
      final response = await _apiService.dio.post("http://localhost:8080/articulos", data: {
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

  Future<Articulo> obtenerArticulo(Long id) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/articulos/$id");
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
      final response = await _apiService.dio.get("http://localhost:8080/articulos");
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
      final response = await _apiService.dio.get("http://localhost:8080/articulos/categoria/$categoria");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los artículos por categoría: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los artículos por categoría: $e");
    }
  }

  Future<List<Articulo>> articulosPorVendedor(Long vendedorId) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/articulos/vendedor/$vendedorId");
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => Articulo.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los artículos por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los artículos por vendedor: $e");
    }
  }


  Future<void> eliminarArticulo(Long id) async {
    try {
      final response = await _apiService.dio.delete("http://localhost:8080/articulos/$id");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar el artículo: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar el artículo: $e");
    }
  }
  
}