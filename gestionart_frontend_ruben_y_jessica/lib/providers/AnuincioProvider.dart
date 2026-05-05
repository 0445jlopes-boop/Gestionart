

import 'package:flutter/foundation.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/repositories/AnuncioRepository.dart';

class AnuncioProvider with ChangeNotifier {
 final Anunciorepository _anuncioRepository;
 List<Anuncio> _anuncios = [];
 AnuncioProvider({Anunciorepository? anuncioRepository})
      : _anuncioRepository = anuncioRepository ?? Anunciorepository(null);
 
 List<Anuncio> get anuncios => _anuncios;
 


  Future<void> fetchAnuncios() async {
    try {
      _anuncios = await _anuncioRepository.getAnuncios();
      notifyListeners();
    } catch (e) {
      print("Error al obtener los anuncios: $e");
    }
  }

  Future<List<Anuncio>> fetchListaAnuncios() async {
    try {
      return await _anuncioRepository.getAnuncios();
    } catch (e) {
      print("Error al obtener los anuncios: $e");
      throw e;
    }
  }

  Future<void> crearAnuncio(int idVendedor, String titulo, String categoria, double precio, String imagen) async {
    try {
      bool success = await _anuncioRepository.crearAnuncio(idVendedor, titulo, categoria, precio, imagen);
      if (success) {
        await fetchAnuncios();
      } else {
        print("Error al crear el anuncio");
      }
    } catch (e) {
      print("Error al crear el anuncio: $e");
    }
  }

  Future<Anuncio> getAnuncioPorVendedor(int idVendedor) async {
    try {
      return await _anuncioRepository.getAnuncioPorVendedor(idVendedor);
    } catch (e) {
      print("Error al obtener el anuncio por vendedor: $e");
      throw e;
    }
  }

  Future<Anuncio?> getAnuncioPorId(int id) async {
    try {
      return await _anuncioRepository.getAnuncioPorId(id);
    } catch (e) {
      print("Error al obtener el anuncio por ID: $e");
      throw e;
    }
  }

  Future<Anuncio> getAnuncioPorCategoria(String categoria) async {
    try {
      return await _anuncioRepository.getAnuncioPorCategoria(categoria);
    } catch (e) {
      print("Error al obtener el anuncio por categoría: $e");
      throw e;
    }
  }

  Future<void> eliminarAnuncio(int id) async {
    try {
      await _anuncioRepository.eliminarAnuncio(id);
      await fetchAnuncios();
    } catch (e) {
      print("Error al eliminar el anuncio: $e");
    }
  }


}
