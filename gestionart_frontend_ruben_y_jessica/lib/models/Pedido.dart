import 'package:gestionart_frontend_ruben_y_jessica/models/Aticulo.dart';

class Pedido {
  int? id;
  DateTime fecha;
  String estado;
  String correoComprador;
  String correoVendedor;
  String direccionComprador;
  List<Articulo> listaArticulos = [];


  Pedido({
    this.id,
    required this.fecha,
    required this.estado,
    required this.correoComprador,
    required this.correoVendedor,
    required this.direccionComprador,
    required this.listaArticulos,
  });
}
