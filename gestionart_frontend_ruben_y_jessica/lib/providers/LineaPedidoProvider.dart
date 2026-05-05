

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/LineaPedidoRepository.dart';

class Lineapedidoprovider with ChangeNotifier{
  final LineaPedidoRepository _lineaPedidoRepository;
  Lineapedidoprovider(LineaPedidoRepository? lineaPedidoRepository) : _lineaPedidoRepository = lineaPedidoRepository ?? LineaPedidoRepository(null);  
  List<Lineapedido> _lineasPedido = [];
  List<Lineapedido> get lineasPedido => _lineasPedido;


  Future<void> crearLineaPedido(int idLineaPedido, int idArticulo, int cantidad, double precioUnitario) async {
    try {
      await _lineaPedidoRepository.crearLineaPedido(idLineaPedido, idArticulo, cantidad, precioUnitario);
    } catch (e) {
      throw("Error al crear la línea de pedido: $e");
    }
  }

  Future<void> actualizarLineaPedido (int id, int cantidad, double precioUnitario) async {
    try{
      await _lineaPedidoRepository.actualizarLineaPedido(id, cantidad, precioUnitario);
    }catch(e){
      throw("Error al actualizar la linea de pedido : $e");
    }
  }

  Future<List<Lineapedido>> fetchLineasPedidoPorPedido(int idPedido) async {
    try {
      return _lineasPedido = await _lineaPedidoRepository.obtenerLineasPedidoPorPedido(idPedido);
    } catch (e) {
      throw("Error al obtener las líneas de pedido por pedido: $e");
    }
  }

  Future<Lineapedido?> fetchLineasPedidoPorId(int id) async {
    try{
      return await _lineaPedidoRepository.obtenerLineaPedidoPorId(id);
    }catch (e){
      print("Error al obtenrr la linea de pedido");
    }
  }

  Future<void> eliminarLineaPedido(int id) async{
    try{
      await _lineaPedidoRepository.eliminarLineaPedido(id);
      _lineasPedido.removeWhere((linea)=> linea.id == id);
    }catch (e){
      throw("Error al eliminar linea de pedido : $e");
    }
  }
}