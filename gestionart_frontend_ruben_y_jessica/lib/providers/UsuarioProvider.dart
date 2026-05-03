import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/Usuariorepository.dart';

class Usuarioprovider extends ChangeNotifier{
  final UsuarioRepository _repository;
  List<Usuario> _usuarios = [];
  Usuarioprovider ({UsuarioRepository? repository}): _repository = repository ?? UsuarioRepository(null);
  List<Usuario> get usuarios => _usuarios;

  Future<Usuario> getUsuarioPorId(Long id) async{
    try{
      return await _repository.getUsuarioPorId(id);
    }catch (e) {
      throw ("Error al obtener usuario: $e");
    }
  }
}