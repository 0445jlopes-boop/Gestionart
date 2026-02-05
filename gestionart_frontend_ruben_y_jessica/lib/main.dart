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
      debugShowCheckedModeBanner: false,
      home: const Pantallainiciosesion(),
    );
  }
}

