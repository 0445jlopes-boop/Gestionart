import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/VendedorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';

void dialogoEliminarVendedor(BuildContext context, Vendedor vendedor, Vendedorprovider provider) {
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
          "¿Seguro desea eliminar su cuenta de vendedor?",
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
              // Eliminar el vendedor
              provider.eliminarVendedor(vendedor.id);
              
              // Navegar a la pantalla de inicio de sesión
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pantallainiciosesion(),
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