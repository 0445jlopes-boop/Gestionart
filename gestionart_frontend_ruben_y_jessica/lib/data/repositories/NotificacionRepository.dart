import 'package:dio/dio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Notificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Notificacionrepository {
  final ApiService _apiService;
  
  Notificacionrepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

Future<void> crearNotificacion(int idVendedor, Tiponotificacion tipo) async {
  try {
    print("🔵 Creando notificación: vendedor=$idVendedor, tipo=${tipo.toString().split('.').last}");
    
    final response = await _apiService.dio.post("/notificaciones", data: {
      "idVendedor": idVendedor,
      "tipo": tipo.toString().split('.').last
    });
    
    print("🟢 Status code: ${response.statusCode}");
    
    // Aceptar 200, 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Notificación creada correctamente");
      return;
    } else {
      throw Exception("Error al crear la notificación: ${response.statusCode}");
    }
  } on DioException catch (e) {
    print("❌ DioError: ${e.message}");
    print("   Status: ${e.response?.statusCode}");
    print("   Data: ${e.response?.data}");
    throw Exception("Error al crear la notificación: ${e.message}");
  } catch (e) {
    print("❌ Error: $e");
    throw Exception("Error al crear la notificación: $e");
  }
} 

  // Obtener todas las notificaciones de un vendedor
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

  // Obtener notificaciones no leídas
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

  // Obtener notificaciones leídas
  Future<List<Notificacion>> obtenerLeidas(int idVendedor, int idNotificacion) async {
    try {
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idNotificacion/leida/$idVendedor");
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

  // Obtener notificaciones por tipo
  Future<List<Notificacion>> obtenerPorTipo(int idVendedor, Tiponotificacion tipo) async {
    try {
      final tipoString = tipo.toString().split('.').last;
      final response = await _apiService.dio.get("/notificaciones/vendedor/$idVendedor/tipo/$tipoString");
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

  // Marcar una notificación como leída
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

  // Marcar todas las notificaciones como leídas
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

  // Eliminar una notificación
  Future<void> eliminarNotificacion(int idNotificacion) async {
    try {
      final response = await _apiService.dio.delete("/notificaciones/$idNotificacion");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar la notificación: ${response.statusCode}");
      } else {
        print("Notificación eliminada correctamente.");
      } 
    } catch (e) {
      throw Exception("Error al eliminar la notificación: $e"); 
    }
  }
}
