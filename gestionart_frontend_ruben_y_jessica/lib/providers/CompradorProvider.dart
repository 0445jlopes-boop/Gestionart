import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/CompradorRepository.dart';


class Compradorprovider with ChangeNotifier {
  final Compradorrepository _repository;
  List<Comprador> compradores = [];
  Compradorprovider ({Compradorrepository? repository}) : _repository = repository ?? Compradorrepository(null);  
  List<Comprador> get getCompradores => compradores;
 
  Future<void> fetchCompradores() async {
    try {
      compradores = await _repository.getCompradores();
    } catch (e) {
      print("Error al obtener los compradores: $e");
    }
  }

  Future<void> actualizarComprador(Long id, String correoElectronico, String nombre, String direccion, String imagen, String contrasena) async {
    try {
      await _repository.actualizarComprador(id, correoElectronico, nombre, direccion, imagen, contrasena);
      await fetchCompradores();
    } catch (e) {
      print("Error al actualizar el comprador: $e");
    }
  }

  Future<void> activarPremium(Long id) async {
    try {
      await _repository.activarPremium(id);
      await fetchCompradores();
    } catch (e) {
      print("Error al activar el premium: $e");
    }
  }

  Future<void> desactivarPremium(Long id) async {
    try {
      await _repository.desactivarPremium(id);
      await fetchCompradores();
    } catch (e) {
      print("Error al desactivar el premium: $e");
    }
  }

  Future<Comprador?> obtenerComprador(Long id) async {
    try {
      return await _repository.getCompradorPorId(id);
    } catch (e) {
      print("Error al obtener el comprador: $e");
      throw e;
    }
  }

  Future<List<Comprador>> fetchListaCompradores() async {
    try {
      return await _repository.getCompradores();
    } catch (e) {
      print("Error al obtener la lista de compradores: $e");
      throw e;
    }
  }

  Future<Comprador> obtenerCompradorPorCorreo(String correoElectronico) async {
    try {
      return await _repository.getCompradores().then((compradores) => compradores.firstWhere((c) => c.correoElectronico == correoElectronico));
    } catch (e) {
      print("Error al obtener el comprador por correo electrónico: $e");
      throw e;
    }
  }

  Future<Comprador> obtenerCompradorPorNombre(String nombre) async {
    try {
      return await _repository.getCompradores().then((compradores) => compradores.firstWhere((c) => c.nombre == nombre));
    } catch (e) {
      print("Error al obtener el comprador por nombre: $e");
      throw e;
    }
  }

  Future<void> eliminarComprador(Long id) async {
    try {
      await _repository.eliminarComprador(id);
      await fetchCompradores();
    } catch (e) {
      print("Error al eliminar el comprador: $e");
    }
  }

}