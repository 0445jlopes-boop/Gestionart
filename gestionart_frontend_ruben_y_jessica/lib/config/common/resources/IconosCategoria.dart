import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';

class CategoriaIcono {
  static IconData obtenerIcono(Categoria categoria) {
    switch (categoria) {
      case Categoria.PINTURA:
        return Icons.brush;

      case Categoria.DIBUJO:
        return Icons.edit;

      case Categoria.ESCULTURA:
        return Icons.account_balance;

      case Categoria.FOTOGRAFIA:
        return Icons.camera_alt;

      case Categoria.DIGITAL:
        return Icons.computer;

      case Categoria.TEXTIL:
        return Icons.checkroom;

      case Categoria.MADERA:
        return Icons.forest;

      case Categoria.CERAMICA:
        return Icons.emoji_objects;

      case Categoria.ILUSTRACION:
        return Icons.brush_outlined;

      case Categoria.CONCEPTUAL:
        return Icons.psychology;
    }
  }
}