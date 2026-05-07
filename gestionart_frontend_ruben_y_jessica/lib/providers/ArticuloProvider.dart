import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/ArticuloRepository.dart';

class Articuloprovider extends ChangeNotifier {  // ← Cambiar "with" a "extends"
  final ArticuloRepository _repository;
  
  Articuloprovider({ArticuloRepository? repository}) 
      : _repository = repository ?? ArticuloRepository(null);
  
  List<Articulo> _articulos = [];
  List<Articulo> get articulos => _articulos;

  Future<void> fetchArticulos() async {
    try {
      final lista = await _repository.obtenerArticulos();
      if (lista != null) {
        _articulos = lista;
      }
      notifyListeners();
    } catch (e) {
      print("Error al obtener los artículos: $e");
    }
  }

  Future<bool> crearArticulo(
    String titulo, 
    String descripcion, 
    double precio, 
    String imagen, 
    String categoria, 
    int stock
  ) async {
    try {
      final exito = await _repository.crearArticulo(
        titulo, 
        descripcion, 
        precio, 
        imagen, 
        categoria, 
        stock
      );
      
      if (exito) {
        await fetchArticulos();  // Recargar lista
        notifyListeners();       
        return true;
      }
      return false;
    } catch (e) {
      print("Error al crear el artículo: $e");
      return false;
    }
  }

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
      final exito = await _repository.actualizarArticulo(
        id, 
        titulo, 
        descripcion, 
        precio, 
        imagen, 
        categoria, 
        stock
      );
      
      if (exito) {
        await fetchArticulos();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print("Error al actualizar el artículo: $e");
      return false;
    }
  }

  Future<Articulo?> obtenerArticulo(int id) async {
    try {
      return await _repository.obtenerArticulo(id);
    } catch (e) {
      print("Error al obtener el artículo: $e");
      return null;
    }
  }

  Future<List<Articulo>?> obtenerPorCategoria(String categoria) async {
    try {
      return await _repository.articulosPorCategoria(categoria);
    } catch (e) {
      print("Error al obtener los artículos por categoría: $e");
      return [];
    }
  }

  Future<List<Articulo>> obtenerPorVendedor(int idVendedor) async {
    try {
      return await _repository.articulosPorVendedor(idVendedor);
    } catch (e) {
      print("Error al obtener los artículos por vendedor: $e");
      return [];
    }
  }

  Future<bool> eliminarArticulo(int id) async {
    try {
      final exito = await _repository.eliminarArticulo(id);
      if (exito) {
        await fetchArticulos();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print("Error al eliminar el artículo: $e");
      return false;
    }
  }
}