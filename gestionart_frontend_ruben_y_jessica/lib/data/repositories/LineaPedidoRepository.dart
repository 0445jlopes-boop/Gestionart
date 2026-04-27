import 'dart:ffi';

import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/ApiService.dart';

class LineaPedidoRepository {
  final ApiService _apiService;
  LineaPedidoRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<void> crearLineaPedido(Long idPedido, Long idArticulo, Long cantidad, double precioUnitario) async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/lineas-pedido", data: {
        "idPedido": idPedido,
        "idArticulo": idArticulo,
        "cantidad": cantidad,
        "precioUnitario": precioUnitario
      });
      if (response.statusCode != 201) {
        throw Exception("Error al crear la línea de pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear la línea de pedido: $e");
    }
  }

  Future<void> actualizarLineaPedido(Long idLineaPedido, int cantidad, double precioUnitario) async {
    try {
      final response = await _apiService.dio.put("http://localhost:8080/lineas-pedido/$idLineaPedido", data: {
        "cantidad": cantidad,
        "precioUnitario": precioUnitario
      });
      if (response.statusCode != 200) {
        throw Exception("Error al actualizar la línea de pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al actualizar la línea de pedido: $e");
    }
  }

  Future<List<Lineapedido>> obtenerLineasPedidoPorPedido(Long idPedido) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/lineas-pedido/pedido/$idPedido");
      if (response.statusCode == 200) {
        List<Lineapedido> lineasPedido = [];
        for (var item in response.data) {
          lineasPedido.add(Lineapedido.fromJson(item));
        }
        return lineasPedido;
      } else {
        throw Exception("Error al obtener las líneas de pedido por pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener las líneas de pedido por pedido: $e");
    }
  }

  Future <Lineapedido> obtenerLineaPedidoPorId(Long idLineaPedido) async {
    try {
      final response = await _apiService.dio.get("http://localhost:8080/lineas-pedido/$idLineaPedido");
      if (response.statusCode == 200) {
        return Lineapedido.fromJson(response.data);
      } else {
        throw Exception("Error al obtener la línea de pedido por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener la línea de pedido por ID: $e");
    }
  }

  Future<void> eliminarLineaPedido(Long idLineaPedido) async {
    try {
      final response = await _apiService.dio.delete("http://localhost:8080/lineas-pedido/$idLineaPedido");
      if (response.statusCode != 204) {
        throw Exception("Error al eliminar la línea de pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar la línea de pedido: $e");
    }
  }
}
