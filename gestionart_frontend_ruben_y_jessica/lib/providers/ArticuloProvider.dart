import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/ArticuloController.dart';

class Articuloprovider with ChangeNotifier {
  final Articulocontroller articulocontroller;
  Articuloprovider(Articulocontroller? articulocontroller) : articulocontroller = articulocontroller ?? Articulocontroller(null);
  List<Articulo> _articulos = [];
  List<Articulo> get articulos => _articulos;

  Future<void> fetchArticulos() async {
    try {
      _articulos = await articulocontroller.obtenerArticulos();
    } catch (e) {
      print("Error al obtener los artículos: $e");
    }
  }


  Future<void> crearArticulo(String titulo, String descripcion, double precio, String imagen, String categoria, int stock) async {
    try {
      await articulocontroller.crearArticulo(titulo, descripcion, precio, imagen, categoria, stock);
      await fetchArticulos();
    } catch (e) {
      print("Error al crear el artículo: $e");
    }
  }

  Future<void> actualizarArticulo(Long id, String titulo, String descripcion, double precio, String imagen, String categoria, int stock) async {
    try {
      await articulocontroller.actualizarArticulo(id, titulo, descripcion, precio, imagen, categoria, stock);
      await fetchArticulos();
    } catch (e) {
      print("Error al actualizar el artículo: $e");
    }
  }

  Future<Articulo?> obtenerArticulo(Long id) async {
    try {
      return await articulocontroller.obtenerArticulo(id);
    } catch (e) {
      print("Error al obtener el artículo: $e");
      throw e;
    }
  }

  Future<List<Articulo>> obtenerPorCategoria(String categoria) async {
    try {
      return await articulocontroller.articulosPorCategoria(categoria);
    } catch (e) {
      print("Error al obtener los artículos por categoría: $e");
      throw e;
    }
  }

  Future<List<Articulo>> obtenerPorVendedor(Long idVendedor) async {
    try {
      return await articulocontroller.articulosPorVendedor(idVendedor);
    } catch (e) {
      print("Error al obtener los artículos por vendedor: $e");
      throw e;
    }
  }

  Future<void> eliminarArticulo(Long id) async {
    try {
      await articulocontroller.eliminarArticulo(id);
      await fetchArticulos();
    } catch (e) {
      print("Error al eliminar el artículo: $e");
    }
  }

  
}