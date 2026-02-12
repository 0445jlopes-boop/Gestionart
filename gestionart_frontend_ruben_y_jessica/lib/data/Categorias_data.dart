import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Categoria.dart';

class CategoriasData { // Case para inicializar los valores por defecto de las categorias existentes.
  static final List<Categoria> categorias = [
    Categoria(nombre: "Arte Digital"),
    Categoria(nombre: "Ilustración"),
    Categoria(nombre: "Anime / Manga"),
    Categoria(nombre: "Realismo"),
    Categoria(nombre: "Abstracto"),
    Categoria(nombre: "Minimalismo"),
    Categoria(nombre: "Street Art"),
    Categoria(nombre: "Graffiti"),
    Categoria(nombre: "Escultura"),
    Categoria(nombre: "Arte 3D"),
    Categoria(nombre: "Arte Ecológico"),
    Categoria(nombre: "Indie"),
    Categoria(nombre: "Rock Art"),
    Categoria(nombre: "Conceptual"),
    Categoria(nombre: "Caricatura"),
    Categoria(nombre: "Cottagecore"),
    Categoria(nombre: "Vaporwave"),
    Categoria(nombre: "Fan Art"),
  ];

  static IconData obtenerIcono(String nombre) { // Asignamos un icono a cada categoria
    switch (nombre) {
      case "Arte Digital":
        return Icons.computer;
      case "Ilustración":
        return Icons.brush;
      case "Anime / Manga":
        return Icons.auto_awesome;
      case "Realismo":
        return Icons.visibility;
      case "Abstracto":
        return Icons.blur_on;
      case "Minimalismo":
        return Icons.crop_square;
      case "Street Art":
        return Icons.location_city;
      case "Graffiti":
        return Icons.format_paint;
      case "Escultura":
        return Icons.account_balance;
      case "Arte 3D":
        return Icons.view_in_ar;
      case "Arte Ecológico":
        return Icons.eco;
      case "Indie":
        return Icons.headphones;
      case "Rock Art":
        return Icons.music_note;
      case "Conceptual":
        return Icons.psychology;
      case "Caricatura":
        return Icons.emoji_emotions;
      case "Cottagecore":
        return Icons.local_florist;
      case "Vaporwave":
        return Icons.gradient;
      case "Fan Art":
        return Icons.favorite;
      default:
        return Icons.category;
    }
  }
}
