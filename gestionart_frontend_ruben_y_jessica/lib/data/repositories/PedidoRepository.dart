
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class PedidoRepository {
  final ApiService _apiService;
  PedidoRepository(ApiService? apiService) : _apiService = apiService ?? ApiService();

  Future<Pedido> crearPedido(Map<String, dynamic> pedidoData) async {
    try {
      final response = await _apiService.dio.post("/pedidos", data: pedidoData);
      if (response.statusCode == 200) {
        return Pedido.fromJson(response.data);
      } else {
        throw Exception("Error al crear el pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear el pedido: $e");
    }
  }

  Future<void> cancelarPedido(int idPedido) async {
    try {
      final response = await _apiService.dio.put("/pedidos/$idPedido/cancelar");
      if (response.statusCode != 200) {
        throw Exception("Error al cancelar el pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al cancelar el pedido: $e");
    }
  }

  Future<void> cambiarEstado(int idPedido) async {
    try {
      final response = await _apiService.dio.put("/pedidos/cambiarEstado/$idPedido");
      if (response.statusCode != 200) {
        throw Exception("Error al cambiar estado del pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al cambiar estado del pedido: $e");
    }
  }

  Future<void> anadirLinea(int idPedido, int idLinea) async {
    try {
      final response = await _apiService.dio.put("/pedidos/$idPedido/anadirLinea/$idLinea");
      if (response.statusCode != 200) {
        throw Exception("Error al añadir línea: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al añadir línea: $e");
    }
  }

  Future<Pedido> obtenerPedidoPorId(int idPedido) async {
    try {
      final response = await _apiService.dio.get("/pedidos/$idPedido");
      if (response.statusCode == 200) {
        return Pedido.fromJson(response.data);
      } else {
        throw Exception("Error al obtener el pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener el pedido: $e");
    }
  }

  Future<List<Pedido>> obtenerPedidosPorComprador(int idComprador) async {
    try {
      final response = await _apiService.dio.get("/pedidos/comprador/$idComprador");
      if (response.statusCode == 200) {
        List<Pedido> pedidos = [];
        for (var item in response.data) {
          pedidos.add(Pedido.fromJson(item));
        }
        return pedidos;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception("Error al obtener los pedidos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los pedidos: $e");
    }
  }

  Future<List<Pedido>> obtenerPedidosPorCompradorYEstado(int idComprador, String estado) async {
    try {
      final response = await _apiService.dio.get("/pedidos/comprador/$idComprador/estado/$estado");
      if (response.statusCode == 200) {
        List<Pedido> pedidos = [];
        for (var item in response.data) {
          pedidos.add(Pedido.fromJson(item));
        }
        return pedidos;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception("Error al obtener los pedidos por estado: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener los pedidos por estado: $e");
    }
  }

  Future<void> eliminarPedido(int idPedido) async {
    try {
      final response = await _apiService.dio.delete("/pedidos/$idPedido");
      if (response.statusCode != 200) {
        throw Exception("Error al eliminar el pedido: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al eliminar el pedido: $e");
    }
  }
}

