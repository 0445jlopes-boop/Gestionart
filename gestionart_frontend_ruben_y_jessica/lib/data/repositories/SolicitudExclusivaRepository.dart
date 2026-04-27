import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoSolicitud.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/SolicitudExclusiva.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Solicitudexclusivarepository {
  ApiService _apiService;
  Solicitudexclusivarepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<void> crearSolicitudExclusiva(Long idComprador, Long idArticulo, String mensaje, Long idVendedor) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/solicitudes-exclusivas", data: {
        "idComprador": idComprador,
        "idArticulo": idArticulo,
        "mensaje": mensaje,
        "idVendedor": idVendedor
      });
      if (response.statusCode != 201) {
        throw Exception("Error al crear la solicitud exclusiva: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear la solicitud exclusiva: $e");
    }
  }

  Future<void> obtenerPorId(Long id) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/solicitudes-exclusivas/$id");
      if (response.statusCode != 200) {
        throw Exception("Error al obtener la solicitud exclusiva por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener la solicitud exclusiva por ID: $e");
    }
  }

  Future<List<Solicitudexclusiva>> obtenerPorVendedor(Long idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/solicitudes-exclusivas/vendedor/$idVendedor");
      if (response.statusCode == 200) {
        List<Solicitudexclusiva> solicitudes = [];
        for (var item in response.data) {
          solicitudes.add(Solicitudexclusiva.fromJson(item));
        }
        return solicitudes;
      } else {
        throw Exception("Error al obtener las solicitudes exclusivas por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las solicitudes exclusivas por vendedor: $e");
    }
  }

  Future<List<Solicitudexclusiva>> obtenerPorVendedorYEstado(Long idVendedor, Estadosolicitud estado) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/solicitudes-exclusivas/vendedor/$idVendedor/estado/$estado");
      if (response.statusCode == 200) {
        List<Solicitudexclusiva> solicitudes = [];
        for (var item in response.data) {
          solicitudes.add(Solicitudexclusiva.fromJson(item));
        }
        return solicitudes;
      } else {
        throw Exception("Error al obtener las solicitudes exclusivas por vendedor y estado: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las solicitudes exclusivas por vendedor y estado: $e");
    }
  }

  Future<List<Solicitudexclusiva>> obtenerPorComprador(Long idComprador) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/solicitudes-exclusivas/comprador/$idComprador");
      if (response.statusCode == 200) {
        List<Solicitudexclusiva> solicitudes = [];
        for (var item in response.data) {
          solicitudes.add(Solicitudexclusiva.fromJson(item));
        }
        return solicitudes;
      } else {
        throw Exception("Error al obtener las solicitudes exclusivas por comprador: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las solicitudes exclusivas por comprador: $e");
    }
  }
  
  Future<List<Solicitudexclusiva>> obtenerPorCompradorYEstado(Long idComprador, Estadosolicitud estado) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/solicitudes-exclusivas/comprador/$idComprador/estado/$estado");
      if (response.statusCode == 200) {
        List<Solicitudexclusiva> solicitudes = [];
        for (var item in response.data) {
          solicitudes.add(Solicitudexclusiva.fromJson(item));
        }
        return solicitudes;
      } else {
        throw Exception("Error al obtener las solicitudes exclusivas por comprador y estado: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las solicitudes exclusivas por comprador y estado: $e");
    }
  }

  Future<List<Solicitudexclusiva>> obtenerTodas() async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/solicitudes-exclusivas");
      if (response.statusCode == 200) {
        List<Solicitudexclusiva> solicitudes = [];
        for (var item in response.data) {
          solicitudes.add(Solicitudexclusiva.fromJson(item));
        }
        return solicitudes;
      } else {
        throw Exception("Error al obtener todas las solicitudes exclusivas: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Error al obtener todas las solicitudes exclusivas: $e");
    }
  } 

  Future<void> actualizarEstado(Long id, Estadosolicitud nuevoEstado) async {
    try {
      final response = await _apiService.dio.put("http://localhost:8080/solicitudes-exclusivas/$id/estado/$nuevoEstado");
      if (response.statusCode != 200) {
        throw Exception("Error al actualizar el estado de la solicitud exclusiva: ${response.statusCode}"); 
      }
    }catch (e) {
      throw Exception("Error al actualizar el estado de la solicitud exclusiva: $e");
    }
  }  

}