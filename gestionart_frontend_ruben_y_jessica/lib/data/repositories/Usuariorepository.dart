import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class UsuarioRepository {

  final ApiService _apiService;

  UsuarioRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<Usuario> getUsuarioPorId(Long id) async {

    try{
      final response = await _apiService.dio.get("http://localhost:8080/users/$id");
      if (response.statusCode == 200) {
        return Usuario.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el usuario por ID: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Error al obtener el usuario por ID: $e");
    }

  }

}