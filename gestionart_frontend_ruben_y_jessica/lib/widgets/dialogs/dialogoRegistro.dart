import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/estilo_botones.dart';
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
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: EstiloBotones.botonSecundario,
            ),
          ],
        ),
        content: const Text(
          "Seleccione una de las siguientes opciones, una vez se haya registrado un correo no podrá vovler a registrarlo como otro tipo de usuario",
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(); //Cerrar el dialogo al presionar el boton
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PantallaregistroComprador()));
            }, 
            child: const Text("Como comprador"),
            style: EstiloBotones.botonPrincipal,
          ),
          SizedBox(width: 300),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(); //Cerrar el dialogo al presionar el boton
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Pantallaregistrovendedor()));
            }, 
            child: const Text("Como vendedor"),
            style: EstiloBotones.botonPrincipal,
          )
        ],
      );
    }
  );
}