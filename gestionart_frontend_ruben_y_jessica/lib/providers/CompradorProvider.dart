import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/CompradorRepository.dart';

class Compradorprovider extends ChangeNotifier {  // ← Cambiado "with" a "extends"
  final Compradorrepository _repository;
  List<Comprador> compradores = [];
  
  Compradorprovider({Compradorrepository? repository}) 
      : _repository = repository ?? Compradorrepository(null);
  
  List<Comprador> get getCompradores => compradores;

  Future<void> fetchCompradores() async {
    try {
      final lista = await _repository.getCompradores();
      if (lista != null) {
        compradores = lista;
      }
      notifyListeners();  // ✅ AÑADIDO - Notificar que la lista cambió
    } catch (e) {
      print("Error al obtener los compradores: $e");
    }
  }

  Future<Comprador?> actualizarComprador(
    int id,
    String correoElectronico,
    String nombre,
    String direccion,
    String imagen,
    String contrasena,
  ) async {
    try {
      final exito = await _repository.actualizarComprador(
        id,
        correoElectronico,
        nombre,
        direccion,
        imagen,
        contrasena,
      );
      
      if (exito) {
        await fetchCompradores();  // fetchCompradores ya tiene notifyListeners()
        return await _repository.getCompradorPorId(id);
      }
      return null;
    } catch (e) {
      print("Error al actualizar el comprador: $e");
      return null;
    }
  }

  Future<bool> activarPremium(int id) async {
    try {
      final exito = await _repository.activarPremium(id);
      if (exito) {
        await fetchCompradores();  // ✅ fetchCompradores ya tiene notifyListeners()
        return true;
      }
      return false;
    } catch (e) {
      print("Error al activar el premium: $e");
      return false;
    }
  }

  Future<bool> desactivarPremium(int id) async {  // ← Cambiado a Future<bool>
    try {
      final exito = await _repository.desactivarPremium(id);
      if (exito) {
        await fetchCompradores();  // ✅ fetchCompradores ya tiene notifyListeners()
        return true;
      }
      return false;
    } catch (e) {
      print("Error al desactivar el premium: $e");
      return false;
    }
  }

  Future<Comprador?> obtenerComprador(int id) async {
    try {
      final comprador = await _repository.getCompradorPorId(id);
      // No es necesario notifyListeners() aquí porque no estamos modificando datos
      return comprador;
    } catch (e) {
      print("Error al obtener el comprador: $e");
      return null;
    }
  }

  Future<List<Comprador>?> fetchListaCompradores() async {
    try {
      return await _repository.getCompradores();
    } catch (e) {
      print("Error al obtener la lista de compradores: $e");
      return null;
    }
  }

  Future<Comprador?> obtenerCompradorPorCorreo(String correoElectronico) async {
    try {
      final lista = await _repository.getCompradores();
      return lista?.firstWhere((c) => c.correoElectronico == correoElectronico);
    } catch (e) {
      print("Error al obtener comprador por correo: $e");
      return null;
    }
  }

  Future<Comprador?> obtenerCompradorPorNombre(String nombre) async {
    try {
      final lista = await _repository.getCompradores();
      return lista?.firstWhere((c) => c.nombre == nombre);
    } catch (e) {
      print("Error al obtener comprador por nombre: $e");
      return null;
    }
  }

  Future<bool> eliminarComprador(int id) async {  // ← Cambiado a Future<bool>
    try {
      final exito = await _repository.eliminarComprador(id);
      if (exito) {
        await fetchCompradores();  // ✅ fetchCompradores ya tiene notifyListeners()
        return true;
      }
      return false;
    } catch (e) {
      print("Error al eliminar el comprador: $e");
      return false;
    }
  }
}