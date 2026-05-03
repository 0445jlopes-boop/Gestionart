import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';

void dialogoActivarPremium(BuildContext context, Comprador comprador) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Activar cuenta premium",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: const Text(
          "Activar cuenta premium se hace durante 3 meses por 5 euros ",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          ElevatedButton(
            style: AppEstiloBotones.botonSecundario,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Aceptar y pagar"),
          ),
          ElevatedButton(
            style: AppEstiloBotones.botonPrincipal,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Pantallainiciosesion(),
                ),
                (route) => false,
              );
            },
            child: const Text("Cancelar"),
          ),
        ],
      );
    },
  );
}