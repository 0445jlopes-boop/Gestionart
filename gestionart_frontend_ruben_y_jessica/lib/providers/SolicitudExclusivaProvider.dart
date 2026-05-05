

import 'package:flutter/foundation.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/SolicitudExclusiva.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/EstadoSolicitud.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/Solicitudexclusivarepository.dart';

class SolicitudExclusivaProvider with ChangeNotifier {
  final Solicitudexclusivarepository _solicitudRepository;
  List<Solicitudexclusiva> _solicitudes = [];
  
  SolicitudExclusivaProvider({Solicitudexclusivarepository? solicitudRepository})
      : _solicitudRepository = solicitudRepository ?? Solicitudexclusivarepository(null);
  
  List<Solicitudexclusiva> get solicitudes => _solicitudes;

  Future<void> fetchSolicitudesPorVendedor(int idVendedor) async {
    try {
      _solicitudes = await _solicitudRepository.obtenerPorVendedor(idVendedor);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las solicitudes por vendedor: $e");
    }
  }

  Future<List<Solicitudexclusiva>> fetchListaSolicitudesPorVendedor(int idVendedor) async {
    try {
      return await _solicitudRepository.obtenerPorVendedor(idVendedor);
    } catch (e) {
      print("Error al obtener la lista de solicitudes por vendedor: $e");
      throw e;
    }
  }

  Future<void> fetchSolicitudesPorComprador(int idComprador) async {
    try {
      _solicitudes = await _solicitudRepository.obtenerPorComprador(idComprador);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las solicitudes por comprador: $e");
    }
  }

  Future<List<Solicitudexclusiva>> fetchListaSolicitudesPorComprador(int idComprador) async {
    try {
      return await _solicitudRepository.obtenerPorComprador(idComprador);
    } catch (e) {
      print("Error al obtener la lista de solicitudes por comprador: $e");
      throw e;
    }
  }

  Future<void> fetchSolicitudesPorVendedorYEstado(int idVendedor, Estadosolicitud estado) async {
    try {
      _solicitudes = await _solicitudRepository.obtenerPorVendedorYEstado(idVendedor, estado);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las solicitudes por vendedor y estado: $e");
    }
  }

  Future<void> fetchSolicitudesPorCompradorYEstado(int idComprador, Estadosolicitud estado) async {
    try {
      _solicitudes = await _solicitudRepository.obtenerPorCompradorYEstado(idComprador, estado);
      notifyListeners();
    } catch (e) {
      print("Error al obtener las solicitudes por comprador y estado: $e");
    }
  }

  Future<void> fetchTodasLasSolicitudes() async {
    try {
      _solicitudes = await _solicitudRepository.obtenerTodas();
      notifyListeners();
    } catch (e) {
      print("Error al obtener todas las solicitudes: $e");
    }
  }

  Future<List<Solicitudexclusiva>> fetchListaTodasLasSolicitudes() async {
    try {
      return await _solicitudRepository.obtenerTodas();
    } catch (e) {
      print("Error al obtener la lista de todas las solicitudes: $e");
      throw e;
    }
  }

  Future<void> crearSolicitudExclusiva(int idComprador, int idArticulo, String mensaje, int idVendedor) async {
    try {
      await _solicitudRepository.crearSolicitudExclusiva(idComprador, idArticulo, mensaje, idVendedor);
      await fetchSolicitudesPorComprador(idComprador);
    } catch (e) {
      print("Error al crear la solicitud exclusiva: $e");
    }
  }

  Future<void> actualizarEstadoSolicitud(int id, Estadosolicitud nuevoEstado, {int? idVendedor, int? idComprador}) async {
    try {
      await _solicitudRepository.actualizarEstado(id, nuevoEstado);
      if (idVendedor != null) {
        await fetchSolicitudesPorVendedor(idVendedor);
      }
      if (idComprador != null) {
        await fetchSolicitudesPorComprador(idComprador);
      }
    } catch (e) {
      print("Error al actualizar el estado de la solicitud: $e");
    }
  }

  Future<Solicitudexclusiva?> obtenerSolicitudPorId(int id) async {
    try {
      await _solicitudRepository.obtenerPorId(id);
      return _solicitudes.firstWhere(
        (solicitud) => solicitud.id == id,
        orElse: () => throw Exception("Solicitud no encontrada"),
      );
    } catch (e) {
      print("Error al obtener la solicitud por ID: $e");
      return null;
    }
  }

  void limpiarSolicitudes() {
    _solicitudes = [];
    notifyListeners();
  }

  List<Solicitudexclusiva> getSolicitudesPorEstado(Estadosolicitud estado) {
    return _solicitudes.where((solicitud) => solicitud.estado == estado).toList();
  }

}