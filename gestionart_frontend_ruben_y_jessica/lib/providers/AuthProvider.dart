import 'package:flutter/material.dart';

class Authprovider with ChangeNotifier{
  final Authprovider _authrepository;
  Authprovider(Authprovider authrepository) : _authrepository = authrepository;
  
  Future<bool> login(String correoElectronico, String contrasena) async {
    return await _authrepository.login(correoElectronico, contrasena);
  }

  Future<bool> registerComprador(String correoElectronico, String nombre, String direccion, String imagen) async {
    return await _authrepository.registerComprador(correoElectronico, nombre, direccion, imagen);
  }

  Future<bool> registerVendedor(String correoElectronico, String nombre, String descripcionPerfil, String imagen) async {
    return await _authrepository.registerVendedor(correoElectronico, nombre, descripcionPerfil, imagen);
  }
}