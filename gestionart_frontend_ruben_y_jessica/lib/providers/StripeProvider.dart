import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/StripeRepository.dart';

class Stripeprovider extends ChangeNotifier {
  final Striperepository _repository;
  Stripeprovider({Striperepository? repository}) : _repository = repository ?? Striperepository(null);

  Future<bool> crearPago () async{
    try{
      bool success = await _repository.crearPago();
      if(!success){
        throw("Error al pagar");
      }
      return success;
    }catch (e) {
      throw("Error al pagar : $e");
    }
  }
}