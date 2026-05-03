import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/VendedorRepository.dart';

class Vendedorprovider extends ChangeNotifier{
  final Vendedorrepository _repository;
  List<Vendedor> _vendedores = [];
  Vendedorprovider({Vendedorrepository? repository}) : _repository = repository ?? Vendedorrepository(null);
  List<Vendedor> get vendedores => _vendedores;


  
}