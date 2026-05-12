

import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class LineaPedidoRepository {
  final ApiService _apiService;
  LineaPedidoRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<Lineapedido?> crearLineaPedido(int idPedido, int idArticulo, int cantidad, double precioUnitario) async {
    try {
      final response = await _apiService.dio.post("/lineas-pedido/crear", data: {
        "idPedido": idPedido,
        "idArticulo": idArticulo,
        "cantidad": cantidad,
        "precioUnitario": precioUnitario
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Lineapedido.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception("Error al crear la línea de pedido: $e");
    }
  }

  Future<void> actualizarLineaPedido(int idLineaPedido, int cantidad, double precioUnitario) async {
    try {
      final response = await _apiService.dio.put("/lineas-pedido/$idLineaPedido", data: {
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

  Future<List<Lineapedido>> obtenerLineasPedidoPorPedido(int idPedido) async {
    try {
      final response = await _apiService.dio.get("/lineas-pedido/pedido/$idPedido");
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

  Future <Lineapedido> obtenerLineaPedidoPorId(int idLineaPedido) async {
    try {
      final response = await _apiService.dio.get("/lineas-pedido/$idLineaPedido");
      if (response.statusCode == 200) {
        return Lineapedido.fromJson(response.data);
      } else {
        throw Exception("Error al obtener la línea de pedido por ID: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener la línea de pedido por ID: $e");
    }
  }

  Future<void> eliminarLineaPedido(int idLineaPedido) async {
    print("ESTOY LLAMANDO A ELIMINAR PEDIDO");
    try {
      final response = await _apiService.dio.delete("/lineas-pedido/$idLineaPedido");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar la línea de pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar la línea de pedido: $e");
    }
  }
  Future<List<Lineapedido>> obtenerLineasPorVendedor(int idVendedor) async {
  try {
    final response = await _apiService.dio.get("/lineas-pedido/vendedor/$idVendedor");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Lineapedido.fromJson(json))
          .toList();
    }
    return [];
  } catch (e) {
    print("Error: $e");
    return [];
  }
}
}
