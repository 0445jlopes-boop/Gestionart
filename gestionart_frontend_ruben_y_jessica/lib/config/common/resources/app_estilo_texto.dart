import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';

class AppEstiloTexto { //Definimos el color, tipo de letra, formato y tamaño de los textos según relevancia
  static const TextStyle encabezado = TextStyle(
    fontFamily: 'Dancing Script',
    fontSize: 24,
    color: AppColores.colorTextoPrincipal,
  );
  static const TextStyle textoPrincipal = TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 16,
    color: AppColores.colorTextoPrincipal,
  );
  static const TextStyle textoSecundario = TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 14,
    color: AppColores.colorTextoSecundario,
  );
}