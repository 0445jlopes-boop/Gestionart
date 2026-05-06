

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/PedidoRepository.dart';

class Pedidoprovider with ChangeNotifier {
  final PedidoRepository _pedidoRepository;
  Pedidoprovider({PedidoRepository? pedidoRepository}) 
      : _pedidoRepository = pedidoRepository ?? PedidoRepository(null);

  List<Pedido> _pedidos = [];
  Pedido? _pedidoActual;
  bool _isLoading = false;

  List<Pedido> get pedidos => _pedidos;
  Pedido? get pedidoActual => _pedidoActual;
  bool get isLoading => _isLoading;

  Future<Pedido> crearPedido(Map<String, dynamic> pedidoData) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final pedido = await _pedidoRepository.crearPedido(pedidoData);
      _pedidoActual = pedido;
      _pedidos.add(pedido);
      
      _isLoading = false;
      notifyListeners();
      return pedido;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al crear el pedido: $e");
    }
  }

  Future<void> cancelarPedido(int idPedido) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _pedidoRepository.cancelarPedido(idPedido);
      
      final index = _pedidos.indexWhere((p) => p.id == idPedido);
      if (index != -1) {
        _pedidos.removeAt(index);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al cancelar el pedido: $e");
    }
  }

  Future<void> cambiarEstado(int idPedido) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _pedidoRepository.cambiarEstado(idPedido);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al cambiar estado: $e");
    }
  }

  Future<void> anadirLinea(int idPedido, int idLinea) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _pedidoRepository.anadirLinea(idPedido, idLinea);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al añadir línea: $e");
    }
  }

  Future<Pedido> fetchPedidoPorId(int idPedido) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _pedidoActual = await _pedidoRepository.obtenerPedidoPorId(idPedido);
      
      _isLoading = false;
      notifyListeners();
      return _pedidoActual!;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al obtener el pedido: $e");
    }
  }

  Future<List<Pedido>> fetchPedidosPorComprador(int idComprador) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _pedidos = await _pedidoRepository.obtenerPedidosPorComprador(idComprador);
      
      _isLoading = false;
      notifyListeners();
      return _pedidos;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al obtener los pedidos por comprador: $e");
    }
  }

  Future<List<Pedido>> fetchPedidosPorCompradorYEstado(int idComprador, String estado) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _pedidos = await _pedidoRepository.obtenerPedidosPorCompradorYEstado(idComprador, estado);
      
      _isLoading = false;
      notifyListeners();
      return _pedidos;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al obtener los pedidos por estado: $e");
    }
  }

  Future<void> eliminarPedido(int idPedido) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _pedidoRepository.eliminarPedido(idPedido);
      
      final index = _pedidos.indexWhere((p) => p.id == idPedido);
      if (index != -1) {
        _pedidos.removeAt(index);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al eliminar el pedido: $e");
    }
  }

  void limpiarPedidoActual() {
    _pedidoActual = null;
    notifyListeners();
  }

  void limpiarPedidos() {
    _pedidos = [];
    notifyListeners();
  }
}
