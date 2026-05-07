import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaPago.dart';

Future<Comprador?> dialogoActivarPremium(BuildContext context, Comprador comprador) async {
  return await showDialog<Comprador>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Activar cuenta premium",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: const Text(
          "Activar cuenta premium se hace durante 3 meses por 5 euros",
          style: AppEstiloTexto.textoSecundario,
        ),
        actions: [
          Expanded(
            child: ElevatedButton(
              style: AppEstiloBotones.botonSecundario,
              onPressed: () async {
                Navigator.pop(context); // Cerrar diálogo
                
                // Navegar a la pantalla de pago y esperar resultado
                final compradorActualizado = await Navigator.push<Comprador>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pago_view(
                      pago: Tipopago.SUSCRIPCION,
                      importe: 5,
                      comprador: comprador,
                    ),
                  ),
                );
                
                // Retornar el comprador actualizado a la pantalla anterior
                if (context.mounted) {
                  Navigator.pop(context, compradorActualizado);
                }
              },
              child: const Text(
                "Aceptar y pagar",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                Navigator.pop(context); // Solo cerrar el diálogo
              },
              child: const Text(
                "Cancelar",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
    },
  );
}