import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AuthProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/PantallaInicioComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoRegistro.dart';
import 'package:provider/provider.dart';

class Pantallainiciosesion extends StatefulWidget {
  const Pantallainiciosesion({super.key});

  @override
  State<Pantallainiciosesion> createState() => _PantallainiciosesionState();
}

class _PantallainiciosesionState extends State<Pantallainiciosesion> {
  //DECLARACIÓN DE VARIABLES PARA EL FORMULARIO DE INICIO DE SESIÓN
  String _correo = "";
  String _contrasena = "";
  final TextEditingController _correoController = TextEditingController(); // Variables para editar el texto en TextFormField
  final TextEditingController _contrasenaController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> _validarUsuario() async { // Validación del usuario a ver si existe para poder iniciar sesión
    final isFormValid = _formKey.currentState!.validate();
    final authProvider = Provider.of<Authprovider>(context,listen:false);
    final compradorProvider = Provider.of<Compradorprovider>(context,listen:false);
    if (isFormValid) {
      if (await authProvider.login(_correo, _contrasena) ) {
        Comprador? compradorLogeado = await compradorProvider.obtenerCompradorPorCorreo(_correo)!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pantallainiciocomprador(
              comprador:compradorLogeado
            ),
          ),
        );
        _correoController.clear();
        _contrasenaController.clear();
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
      appBar: AppBar( // Appbar con estilo predefinido 
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
              Image.asset('assets/images/logo.jpg'), // Logo de la aplicación
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: Form( // Formulario de inicio de sesión
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          controller: _correoController,
                          decoration: const InputDecoration(
                            labelText: "Correo",
                            labelStyle: AppEstiloTexto.textoPrincipal,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => Validators.validateEmpty(value),
                          onChanged: (value) => _correo = value,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          controller: _contrasenaController,
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
                      ElevatedButton( // Si inicia sesión se valida el usuario
                        style: AppEstiloBotones.botonPrincipal,
                        onPressed: _validarUsuario,
                        child: Text(
                          "Iniciar Sesión",
                          style: AppEstiloTexto.textoPrincipal,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton( // Si no está registrado puede hacerlo y seleccionar el rol que desea en el dialogo
                        style: AppEstiloBotones.botonPrincipal,
                        onPressed: () {
                          dialogoRegistro(context); 
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
