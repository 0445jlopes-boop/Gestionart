import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/PedidoRepository.dart';

class Pedidoprovider with ChangeNotifier {
  final PedidoRepository _pedidoRepository;
  Pedidoprovider(PedidoRepository? pedidoRepository) 
      : _pedidoRepository = pedidoRepository ?? PedidoRepository(null);

  List<Pedido> _pedidos = [];
  Pedido? _pedidoActual;
  bool _isLoading = false;

  List<Pedido> get pedidos => _pedidos;
  Pedido? get pedidoActual => _pedidoActual;
  bool get isLoading => _isLoading;

  Future<Pedido> crearPedido(Long idComprador) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final pedido = await _pedidoRepository.crearPedido(idComprador);
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

  Future<void> confirmarPedido(Long idPedido) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _pedidoRepository.confirmarPedido(idPedido);
      
      final index = _pedidos.indexWhere((p) => p.id == idPedido);
      if (index != -1) {
        // Aquí necesitarías recargar el pedido para obtener el estado actualizado
        _pedidos[index] = await _pedidoRepository.obtenerPedidoPorId(idPedido);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al confirmar el pedido: $e");
    }
  }

  Future<Pedido> fetchPedidoPorId(Long idPedido) async {
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
      throw Exception("Error al obtener el pedido por ID: $e");
    }
  }

  Future<List<Pedido>> fetchPedidosPorComprador(Long idComprador) async {
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

  Future<List<Pedido>> fetchPedidosPorVendedor(Long idVendedor) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _pedidos = await _pedidoRepository.obtenerPedidosPorVendedor(idVendedor);
      
      _isLoading = false;
      notifyListeners();
      return _pedidos;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al obtener los pedidos por vendedor: $e");
    }
  }

  Future<List<Pedido>> fetchTodosPedidos() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _pedidos = await _pedidoRepository.obtenerTodosPedidos();
      
      _isLoading = false;
      notifyListeners();
      return _pedidos;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Error al obtener los pedidos: $e");
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
