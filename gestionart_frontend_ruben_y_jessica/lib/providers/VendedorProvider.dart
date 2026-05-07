import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/VendedorRepository.dart';

class Vendedorprovider extends ChangeNotifier {  // ← Cambiado "with" a "extends"
  final Vendedorrepository _repository;
  List<Vendedor> vendedores = [];
  
  Vendedorprovider({Vendedorrepository? repository}) 
      : _repository = repository ?? Vendedorrepository(null);
  
  List<Vendedor> get getvendedores => vendedores;

  // Obtener todos los vendedores
  Future<void> fetchVendedores() async {
    try {
      final lista = await _repository.getVendedores();
      if (lista != null) {
        vendedores = lista;
      }
      notifyListeners();  // ← AÑADIDO
    } catch (e) {
      print("Error al obtener los vendedores: $e");
    }
  }

  // Actualizar vendedor
  Future<Vendedor?> actualizarVendedor(
    int id, 
    String correoElectronico, 
    String nombre, 
    String descripcionPerfil, 
    String imagen, 
    String contrasena
  ) async {
    try {
      final exito = await _repository.actualizarVendedor(
        id, 
        correoElectronico, 
        nombre, 
        descripcionPerfil, 
        imagen, 
        contrasena
      );
      
      if (exito) {
        await fetchVendedores();
        notifyListeners();  // ← AÑADIDO
        return await _repository.getVendedorPorId(id);
      }
      return null;
    } catch (e) {
      print("Error al actualizar el vendedor: $e");
      throw e;
    }
  }

  // Obtener vendedor por ID
  Future<Vendedor?> obtenerVendedor(int id) async {
    try {
      return await _repository.getVendedorPorId(id);
    } catch (e) {
      print("Error al obtener el vendedor: $e");
      return null;
    }
  }

  // Obtener vendedor por correo
  Future<Vendedor?> obtenerVendedorPorCorreo(String correoElectronico) async {
    try {
      return await _repository.getVendedorPorCorreoElectronico(correoElectronico);
    } catch (e) {
      print("Error al obtener el vendedor por correo: $e");
      return null;
    }
  }

  // Obtener vendedor por nombre
  Future<Vendedor?> obtenerVendedorPorNombre(String nombre) async {
    try {
      return await _repository.getVendedorPorNombre(nombre);
    } catch (e) {
      print("Error al obtener el vendedor por nombre: $e");
      return null;
    }
  }
  Future<bool> existeCorreo(String correo) async {
    try {
      final vendedor = await _repository.getVendedorPorCorreoElectronico(correo);
      return vendedor != null;
    } catch (e) {
      return false;
    }
  }

  // Obtener lista de vendedores
  Future<List<Vendedor>?> fetchListaVendedores() async {
    try {
      return await _repository.getVendedores();
    } catch (e) {
      print("Error al obtener la lista de vendedores: $e");
      throw e;
    }
  }

  // Eliminar vendedor
  Future<void> eliminarVendedor(int id) async {
    try {
      await _repository.eliminarVendedor(id);
      vendedores.removeWhere((v) => v.id == id);
      notifyListeners();
    } catch (e) {
      print("Error al eliminar el vendedor: $e");
      throw e;
    }
  }
}