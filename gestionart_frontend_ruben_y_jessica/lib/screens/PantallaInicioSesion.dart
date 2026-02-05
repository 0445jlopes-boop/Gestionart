import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoRegistro.dart';

class Pantallainiciosesion extends StatefulWidget {
  const Pantallainiciosesion({super.key});

  @override
  State<Pantallainiciosesion> createState() => _PantallainiciosesionState();
}

class _PantallainiciosesionState extends State<Pantallainiciosesion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text(
            "GESTIONART", 
            style: AppEstiloTexto.encabezado
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.jpg'),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child:TextFormField(
                decoration: const InputDecoration(
                    labelText: "Correo electronico",
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
                    border: OutlineInputBorder(),
                  ),
                ), 
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 400,
                child: TextButton(
                        onPressed:null, 
                        child: Text("¿Olvidaste tu contraseña?")
                      ),
              ),
              ElevatedButton(
                style: EstiloBotones.botonPrincipal,
                onPressed: null,
                child: Text("Iniciar Sesión")
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                style: EstiloBotones.botonPrincipal,
                onPressed: (){
                  DialogoRegistro(context);
                },
                child: Text("Registrarse")
              ),
            ],
          ),
        ),
      )
    );

  }
}