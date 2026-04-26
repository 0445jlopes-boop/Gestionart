import 'package:gestionart_frontend_ruben_y_jessica/data/models/Usuario.dart';
import 'package:dio/dio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class UsuarioRepository {

  final ApiService _apiService;

  UsuarioRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<List<Usuario>> getListaUsuarios() async {

    try{
      final response = await _apiService.dio.get("http://localhost:8080/api/usuarios");
      if (response.statusCode == 200) {
        List<Usuario> usuarios = (response.data as List).map((json) => Usuario.fromJson(json)).toList();
        return usuarios;
      } else {
        throw Exception("Error al obtener la lista de usuarios: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Error al obtener la lista de usuarios: $e");
    }

  }


  Future<Usuario> getUsuarioPorId(int id) async {

    try{
      final response = await _apiService.dio.get("http://localhost:8080/api/usuarios/$id");
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