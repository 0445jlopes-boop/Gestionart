import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';

class AppEstiloBotones { // Definimos como van a ser los dos tipos de colores en cuanto al tamaño, color de fondo y color de texto
  static const ButtonStyle botonPrincipal = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(Size(150,50)),
    backgroundColor: MaterialStatePropertyAll(AppColores.colorPrimario),
    foregroundColor: MaterialStatePropertyAll(AppColores.colorTextoSecundario)
  );
  static const ButtonStyle botonSecundario = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(Size(20,50)),
    backgroundColor: MaterialStatePropertyAll(AppColores.colorSecundario),
    foregroundColor: MaterialStatePropertyAll(AppColores.colorTextoSecundario)
  );
}