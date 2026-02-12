import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/PantallaRegistroComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Vendedor/PantallaRegistroVendedor.dart';

void DialogoRegistro (BuildContext context){
  showDialog(
    context: context, 
    barrierDismissible: false, //impide que el usuario cierre el dialogo tocando fuera de este, así tiene más sentido usar un boton para cerrar el dialogo.
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            const Expanded(child: Text("¿Cómo quieres registrarte?" , style: AppEstiloTexto.textoPrincipal,)),
            IconButton(
              icon: const Icon(Icons.close), //Icono para cerrar el dialogo
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: AppEstiloBotones.botonSecundario,
            ),
          ],
        ),
        content: const Text(
          "Seleccione una de las siguientes opciones, una vez se haya registrado un correo no podrá vovler a registrarlo como otro tipo de usuario",
          style: AppEstiloTexto.textoSecundario,  
        ),
        actions: [ // Se muestran dos botones para elegir que rol desea en la aplicación.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton( 
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PantallaregistroComprador(),
                    ),
                  );
                },
                style: AppEstiloBotones.botonPrincipal,
                child: const Text(
                  "Como comprador",
                  style: AppEstiloTexto.textoPrincipal,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Pantallaregistrovendedor(),
                    ),
                  );
                },
                style: AppEstiloBotones.botonPrincipal,
                child: const Text(
                  "Como vendedor",
                  style: AppEstiloTexto.textoPrincipal,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
