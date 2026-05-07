import 'package:flutter/foundation.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Notificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/NotificacionRepository.dart';

class NotificacionProvider extends ChangeNotifier {
  final Notificacionrepository _notificacionRepository;
  List<Notificacion> _notificaciones = [];
  
  NotificacionProvider({Notificacionrepository? notificacionRepository})
      : _notificacionRepository = notificacionRepository ?? Notificacionrepository(null);
  
  List<Notificacion> get notificaciones => _notificaciones;

  Future<void> fetchNotificacionesPorVendedor(int idVendedor) async {
    try {
      _notificaciones = await _notificacionRepository.obtenerNotificacionesPorVendedor(idVendedor);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las notificaciones por vendedor: $e");
    }
  }

  Future<List<Notificacion>> fetchListaNotificacionesPorVendedor(int idVendedor) async {
    try {
      return await _notificacionRepository.obtenerNotificacionesPorVendedor(idVendedor);
    } catch (e) {
      print("Error al obtener la lista de notificaciones por vendedor: $e");
      throw e;
    }
  }

  Future<void> crearNotificacion(int idVendedor, Tiponotificacion tipo) async {
    try {
      await _notificacionRepository.crearNotificacion(idVendedor, tipo);
      await fetchNotificacionesPorVendedor(idVendedor);
    } catch (e) {
      print("Error al crear la notificación: $e");
    }
  }

  Future<void> fetchNotificacionesNoLeidas(int idVendedor) async {
    try {
      _notificaciones = await _notificacionRepository.obtenerNoLeidas(idVendedor);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las notificaciones no leídas: $e");
    }
  }

  Future<void> fetchNotificacionesLeidas(int idVendedor) async {
    try {
      _notificaciones = await _notificacionRepository.obtenerLeidas(idVendedor);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las notificaciones leídas: $e");
    }
  }

  Future<void> fetchNotificacionesPorTipo(int idVendedor, Tiponotificacion tipo) async {
    try {
      _notificaciones = await _notificacionRepository.obtenerPorTipo(idVendedor, tipo);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las notificaciones por tipo: $e");
    }
  }

  Future<void> marcarComoLeida(int idNotificacion, int idVendedor) async {
    try {
      await _notificacionRepository.marcarComoLeida(idNotificacion, idVendedor);
      await fetchNotificacionesPorVendedor(idVendedor);
    } catch (e) {
      print("Error al marcar la notificación como leída: $e");
    }
  }

  Future<void> marcarTodasComoLeidas(int idVendedor) async {
    try {
      await _notificacionRepository.marcarTodasComoLeidas(idVendedor);
      await fetchNotificacionesPorVendedor(idVendedor);
    } catch (e) {
      print("Error al marcar todas las notificaciones como leídas: $e");
    }
  }

  Future<void> eliminarNotificacion(int idNotificacion, int idVendedor) async {
    try {
      await _notificacionRepository.eliminarNotificacion(idNotificacion);
      await fetchNotificacionesPorVendedor(idVendedor);
    } catch (e) {
      print("Error al eliminar la notificación: $e");
    }
  }

  void limpiarNotificaciones() {
    _notificaciones = [];
    notifyListeners();
  }
}