import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';

class EstiloBotones {
  static const ButtonStyle botonPrincipal = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(Size(300,50)),
    backgroundColor: MaterialStatePropertyAll(AppColores.colorPrimario),
    foregroundColor: MaterialStatePropertyAll(AppColores.colorTextoSecundario)
  );
  static const ButtonStyle botonSecundario = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(Size(20,50)),
    backgroundColor: MaterialStatePropertyAll(AppColores.colorSecundario),
    foregroundColor: MaterialStatePropertyAll(AppColores.colorTextoSecundario)
  );
}