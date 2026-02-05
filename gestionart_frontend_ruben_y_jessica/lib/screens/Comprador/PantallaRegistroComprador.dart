import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';

class PantallaregistroComprador extends StatefulWidget {
  const PantallaregistroComprador({super.key});

  @override
  State<PantallaregistroComprador> createState() => _PantallaregistroCompradorState();
}

class _PantallaregistroCompradorState extends State<PantallaregistroComprador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text(
            "¡ REGISTRATE EN GESTIONART !", 
            style: AppEstiloTexto.encabezado
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center, 
        child: Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
                width: 400,
                child:TextFormField(
                decoration: const InputDecoration(
                    labelText: "Nombre",
                    labelStyle: AppEstiloTexto.textoPrincipal ,
                    border: OutlineInputBorder(),
                  ),
                ), 
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child:TextFormField(
                decoration: const InputDecoration(
                    labelText: "Apellidos",
                    labelStyle: AppEstiloTexto.textoPrincipal ,
                    border: OutlineInputBorder(),
                  ),
                ), 
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child:TextFormField(
                decoration: const InputDecoration(
                    labelText: "Correo electronico",
                    labelStyle: AppEstiloTexto.textoPrincipal ,
                    border: OutlineInputBorder(),
                  ),
                ), 
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child:TextFormField(
                decoration: const InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: AppEstiloTexto.textoPrincipal ,
                    border: OutlineInputBorder(),
                  ),
                ), 
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child:TextFormField(
                decoration: const InputDecoration(
                    labelText: "Repita la contraseña", 
                    labelStyle: AppEstiloTexto.textoPrincipal ,
                    border: OutlineInputBorder(),
                  ),
                ), 
              ),
              SizedBox(height: 20),

          ],
        ),

      ),
    );
  }
}
