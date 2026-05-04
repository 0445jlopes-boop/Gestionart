import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class PedidoRepository {
  final ApiService _apiService;
  PedidoRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<Pedido> crearPedido(Long idComprador) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/pedidos", data: {
        "idComprador": idComprador
      });
      if (response.statusCode == 200) {
        return Pedido.fromJson(response.data);
      } else {
        throw Exception("Error al crear el pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear el pedido: $e");
    }
  }

  Future<void> confirmarPedido(Long idPedido) async {
    try {
      final response = await _apiService.dio.put("http://localhost:8080/pedidos/$idPedido/confirmar");
      if (response.statusCode != 200) {
        throw Exception("Error al confirmar el pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al confirmar el pedido: $e");
    }
  }

  Future<Pedido> obtenerPedidoPorId(Long idPedido) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/pedidos/$idPedido");
      if (response.statusCode == 200) {
        return Pedido.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el pedido por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el pedido por ID: $e");
    }
  }

  Future<List<Pedido>> obtenerPedidosPorComprador(Long idComprador) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/pedidos/comprador/$idComprador");
      if (response.statusCode == 200) {
        List<Pedido> pedidos = [];
        for (var item in response.data) {
          pedidos.add(Pedido.fromJson(item));
        }
        return pedidos;
      } else {
        throw Exception("Error al obtener los pedidos por comprador: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los pedidos por comprador: $e");
    }
  }

  Future<List<Pedido>> obtenerPedidosPorVendedor(Long idVendedor) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/pedidos/vendedor/$idVendedor");
      if (response.statusCode == 200) {
        List<Pedido> pedidos = [];
        for (var item in response.data) {
          pedidos.add(Pedido.fromJson(item));
        }
        return pedidos;
      } else {
        throw Exception("Error al obtener los pedidos por vendedor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los pedidos por vendedor: $e");
    }
  }

  Future<List<Pedido>> obtenerTodosPedidos() async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/pedidos");
      if (response.statusCode == 200) {
        List<Pedido> pedidos = [];
        for (var item in response.data) {
          pedidos.add(Pedido.fromJson(item));
        }
        return pedidos;
      } else {
        throw Exception("Error al obtener los pedidos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los pedidos: $e");
    }
  }
}
