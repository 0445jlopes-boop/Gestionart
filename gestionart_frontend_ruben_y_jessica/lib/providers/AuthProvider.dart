import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/AuthRepository.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Authprovider extends ChangeNotifier{
  final Authrepository _authrepository;
  Authprovider({Authrepository? repository})
      : _authrepository = repository ?? Authrepository(null);
  Future<bool> login(String correoElectronico, String contrasena) async {
    return await _authrepository.login(correoElectronico, contrasena);
  }

  Future<bool> registerComprador(String correoElectronico, String contrasena, String nombre, String direccion, String imagen) async {
    return await _authrepository.registerComprador(correoElectronico, contrasena, nombre, direccion, imagen);
  }

  Future<bool> registerVendedor(String correoElectronico, String nombre, String descripcionPerfil, String imagen) async {
    return await _authrepository.registerVendedor(correoElectronico, nombre, descripcionPerfil, imagen);
  }
}