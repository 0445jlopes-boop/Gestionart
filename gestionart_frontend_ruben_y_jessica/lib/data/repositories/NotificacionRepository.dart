import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Notificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class Notificacionrepository {
  final ApiService _apiService;
  Notificacionrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<void> crearNotificacion(Long idVendedor, Tiponotificacion tipo) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/notificaciones", data: {
        "idVendedor": idVendedor,
        "tipo": tipo
      });
      if (response.statusCode != 201) {
        throw Exception("Error al crear la notificación: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear la notificación: $e");
    }
  }  

  Future<List<Notificacion>> obtenerNotificacionesPorVendedor(Long idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/notificaciones/vendedor/$idVendedor");
      if (response.statusCode == 200) {
        List<Notificacion> notificaciones = [];
        for (var item in response.data) {
          notificaciones.add(Notificacion.fromJson(item));
        }
        return notificaciones;
      } else {
        throw Exception("Error al obtener las notificaciones por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las notificaciones por vendedor: $e");
    }
  }

  Future<List<Notificacion>> obtenerPorVendedor(Long idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/notificaciones/vendedor/$idVendedor");
      if (response.statusCode == 200) {
        List<Notificacion> notificaciones = [];
        for (var item in response.data) {
          notificaciones.add(Notificacion.fromJson(item));
        }
        return notificaciones;
      } else {
        throw Exception("Error al obtener las notificaciones por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las notificaciones por vendedor: $e");
    }
  }

  Future<List<Notificacion>> obtenerNoLeidas(Long idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/notificaciones/vendedor/$idVendedor/no-leidas");
      if (response.statusCode == 200) {
        List<Notificacion> notificaciones = [];
        for (var item in response.data) {
          notificaciones.add(Notificacion.fromJson(item));
        }
        return notificaciones;
      } else {
        throw Exception("Error al obtener las notificaciones no leídas: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las notificaciones no leídas: $e");
    }
  }

  Future<List<Notificacion>> obtenerLeidas(Long idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/notificaciones/vendedor/$idVendedor/leidas");
      if (response.statusCode == 200) {
        List<Notificacion> notificaciones = [];
        for (var item in response.data) {
          notificaciones.add(Notificacion.fromJson(item));
        }
        return notificaciones;
      } else {
        throw Exception("Error al obtener las notificaciones leídas: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las notificaciones leídas: $e");
    }
  }

  Future<List<Notificacion>> obtenerPorTipo(Long idVendedor, Tiponotificacion tipo) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/notificaciones/vendedor/$idVendedor/tipo/$tipo");
      if (response.statusCode == 200) {
        List<Notificacion> notificaciones = [];
        for (var item in response.data) {
          notificaciones.add(Notificacion.fromJson(item));
        }
        return notificaciones;
      } else {
        throw Exception("Error al obtener las notificaciones por tipo: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las notificaciones por tipo: $e");
    }
  }

  Future<void> marcarComoLeida(Long idNotificacion, Long idVendedor) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/notificaciones/$idNotificacion/leida/$idVendedor");
      if (response.statusCode != 200) {
        throw Exception("Error al marcar la notificación como leída: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al marcar la notificación como leída: $e");
    }
  }

  Future<void> marcarTodasComoLeidas(Long idVendedor) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/notificaciones/vendedor/$idVendedor/leidas");
      if (response.statusCode != 200) {
        throw Exception("Error al marcar todas las notificaciones como leídas: ${response.statusCode}");
      } else {
        print("Todas las notificaciones marcadas como leídas correctamente.");
      }
    } catch (e) {
      throw Exception("Error al marcar todas las notificaciones como leídas: $e");
    }
  }


  Future<void> eliminarNotificacion(Long idNotificacion) async {
    try {
      final response = await _apiService.dio.delete("http://localhost:8080/notificaciones/$idNotificacion");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar la notificación: ${response.statusCode}");
      }else {
        print("Notificación eliminada correctamente.");
      } 
    } catch (e) {
      throw Exception("Error al eliminar la notificación: $e"); 
    }
  }
}