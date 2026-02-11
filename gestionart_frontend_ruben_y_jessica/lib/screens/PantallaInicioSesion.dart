import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/controllers/ControllerComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/PantallaInicioComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoRegistro.dart';

class Pantallainiciosesion extends StatefulWidget {
  const Pantallainiciosesion({super.key});

  @override
  State<Pantallainiciosesion> createState() => _PantallainiciosesionState();
}

class _PantallainiciosesionState extends State<Pantallainiciosesion> {
  String _nombre = "";
  String _contrasena = "";
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  void _validarUsuario() {
    final isFormValid = _formKey.currentState!.validate();
    if (isFormValid) {
      if (Controllercomprador.compradorExiste(_nombre, _contrasena)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pantallainiciocomprador(
              comprador: Controllercomprador.extraerComprador(
                _nombre,
                _contrasena,
              )!,
            ),
          ),
        );
      } else {
        const snackBar = SnackBar(
          content: Text('Usuario o contraseña no válidos'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text("GESTIONART", style: AppEstiloTexto.encabezado),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Image.asset('assets/images/logo.jpg'),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Nombre",
                            labelStyle: AppEstiloTexto.textoPrincipal,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => Validators.validateEmpty(value),
                          onChanged: (value) => _nombre = value,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: AppEstiloTexto.textoPrincipal,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(_obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off
                              ),
                              color: AppColores.colorSecundario,
                            ),
                          ),
                          
                          validator: (value) => Validators.validateEmpty(value),
                          onChanged: (value) => _contrasena = value,
                          obscureText: _obscurePassword,
                          
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextButton(
                          onPressed: null,
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: AppEstiloTexto.textoSecundario,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: AppEstiloBotones.botonPrincipal,
                        onPressed: _validarUsuario,
                        child: Text(
                          "Iniciar Sesión",
                          style: AppEstiloTexto.textoPrincipal,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: AppEstiloBotones.botonPrincipal,
                        onPressed: () {
                          DialogoRegistro(context);
                        },
                        child: Text(
                          "Registrarse",
                          style: AppEstiloTexto.textoPrincipal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
