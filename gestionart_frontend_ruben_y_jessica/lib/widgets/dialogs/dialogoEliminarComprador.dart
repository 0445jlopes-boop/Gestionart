import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';

void dialogoEliminarCuenta(BuildContext context, Comprador comprador) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Eliminar cuenta",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: const Text(
          "¿Seguro desea eliminar su cuenta?",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          ElevatedButton(
            style: AppEstiloBotones.botonSecundario,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
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
            child: const Text("Sí"),
          ),
        ],
      );
    },
  );
}
