

import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/LineaPedido.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/LineaPedidoRepository.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:provider/provider.dart';

class Lineapedidoprovider with ChangeNotifier{
  final LineaPedidoRepository _lineaPedidoRepository;
  Lineapedidoprovider({LineaPedidoRepository? lineaPedidoRepository}) : _lineaPedidoRepository = lineaPedidoRepository ?? LineaPedidoRepository(null);  
  List<Lineapedido> _lineasPedido = [];
  List<Lineapedido> get lineasPedido => _lineasPedido;


  Future<Lineapedido?> crearLineaPedido(int idLineaPedido, int idArticulo, int cantidad, double precioUnitario) async {
    try {
      return await _lineaPedidoRepository.crearLineaPedido(idLineaPedido, idArticulo, cantidad, precioUnitario);
    } catch (e) {
      throw("Error al crear la lnea de pedido: $e");
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
      throw("Error al obtener las lneas de pedido por pedido: $e");
    }
  }

  Future<Lineapedido?> fetchLineasPedidoPorId(int id) async {
    try{
      return await _lineaPedidoRepository.obtenerLineaPedidoPorId(id);
    }catch (e){
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
  Future<List<Lineapedido>> fetchLineasPorVendedor( int idVendedor) async {
    try {
     
      final todasLasLineas = await _lineaPedidoRepository.obtenerLineasPorVendedor(idVendedor);
      return todasLasLineas;
    } catch (e) {
      return [];
    }
  }
}
