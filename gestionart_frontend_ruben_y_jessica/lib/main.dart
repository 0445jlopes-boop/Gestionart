import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( // Esto sirve para permitir un estilo predeterminado en iconos y demás cosas estéticas para que  sean visibles y editables
        useMaterial3: false,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false, //No muestra la etiqueta debug del appbar
      home: const Pantallainiciosesion(), // Muestra directamente la pantalla de inicio de sesión
    );
  }
}

