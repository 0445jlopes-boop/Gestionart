import 'package:gestionart_frontend_ruben_y_jessica/data/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Anunciorepository {

  final ApiService _apiService;
  Anunciorepository(ApiService? apiService) : _apiService = apiService ?? ApiService();


  Future<bool> crearAnuncio(int idVendedor, String titulo, String categoria, double precio, String imagen) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/anuncios", data: {
        "idVendedor": idVendedor,
        "titulo": titulo,
        "categoria": categoria,
        "precio": precio,
        "imagen": imagen
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error al crear el anuncio: $e");
    }
  
  }
  
  Future<Anuncio> getAnuncioPorVendedor(int idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/anuncios/vendedor/$idVendedor");
      if (response.statusCode == 200) {
        return Anuncio.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el anuncio por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el anuncio por vendedor: $e");
    }
  }

  Future<List<Anuncio>> getAnuncios() async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/anuncios");
      if (response.statusCode == 200) {
        List<Anuncio> anuncios = [];
        for (var item in response.data) {
          anuncios.add(Anuncio.fromJson(item));
        }
        return anuncios;
      } else {
        throw Exception("Error al obtener los anuncios: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los anuncios: $e");
    }
  }

  Future<Anuncio> getAnuncioPorId(int id) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/anuncios/$id");
      if (response.statusCode == 200) {
        return Anuncio.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el anuncio por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el anuncio por ID: $e");
    }
  }

  Future<Anuncio> getAnuncioPorCategoria(String categoria) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/anuncios/categoria/$categoria");
      if (response.statusCode == 200) {
        return Anuncio.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el anuncio por categoría: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el anuncio por categoría: $e");
    }
  }

  Future<void> eliminarAnuncio(int id) async {
    try {
      final response = await _apiService.dio.delete("http://localhost:8080/anuncios/$id");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar el anuncio: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar el anuncio: $e");
    }
  }
}
