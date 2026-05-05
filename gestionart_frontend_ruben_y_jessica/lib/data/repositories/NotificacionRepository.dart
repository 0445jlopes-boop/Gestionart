

import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Notificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Notificacionrepository {
  final ApiService _apiService;
  Notificacionrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<void> crearNotificacion(int idVendedor, Tiponotificacion tipo) async {
    try {
      final response = await _apiService.dio.post("/notificaciones", data: {
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

  Future<List<Notificacion>> obtenerNotificacionesPorVendedor(int idVendedor) async {
    try {
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idVendedor");
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

  Future<List<Notificacion>> obtenerPorVendedor(int idVendedor) async {
    try {
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idVendedor");
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

  Future<List<Notificacion>> obtenerNoLeidas(int idVendedor) async {
    try {
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idVendedor/no-leidas");
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

  Future<List<Notificacion>> obtenerLeidas(int idVendedor) async {
    try {
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idVendedor/leidas");
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

  Future<List<Notificacion>> obtenerPorTipo(int idVendedor, Tiponotificacion tipo) async {
    try {
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idVendedor/tipo/$tipo");
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

  Future<void> marcarComoLeida(int idNotificacion, int idVendedor) async {
    try {
      final response = await _apiService.dio.post("/notificaciones/$idNotificacion/leida/$idVendedor");
      if (response.statusCode != 200) {
        throw Exception("Error al marcar la notificación como leída: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al marcar la notificación como leída: $e");
    }
  }

  Future<void> marcarTodasComoLeidas(int idVendedor) async {
    try {
      final response = await _apiService.dio.post("/notificaciones/vendedor/$idVendedor/leidas");
      if (response.statusCode != 200) {
        throw Exception("Error al marcar todas las notificaciones como leídas: ${response.statusCode}");
      } else {
        print("Todas las notificaciones marcadas como leídas correctamente.");
      }
    } catch (e) {
      throw Exception("Error al marcar todas las notificaciones como leídas: $e");
    }
  }


  Future<void> eliminarNotificacion(int idNotificacion) async {
    try {
      final response = await _apiService.dio.delete("/notificaciones/$idNotificacion");
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
