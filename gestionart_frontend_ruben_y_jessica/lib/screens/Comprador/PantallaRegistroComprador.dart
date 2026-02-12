import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/controllers/ControllerGeneral.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/LogicaComprador.dart';

class PantallaregistroComprador extends StatefulWidget {
  const PantallaregistroComprador({super.key});

  @override
  State<PantallaregistroComprador> createState() =>
      _PantallaregistroCompradorState();
}

class _PantallaregistroCompradorState extends State<PantallaregistroComprador> {
  //DECLARACIÓN DE VARIABLES A USAR EN EL FORMULARIO
  final _formKey = GlobalKey<FormState>(); 
  String _nombre = "";
  String _direccion = "";
  String _correoElectronico = "";
  String _contrasena = "";
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  String _contrasena2 = "";
  String? photoPath = "";
  
  void _validarComprador(){ // Proedimiento que permite comprobar que los campos del formulario sean correctos a través de validaciones
    final isFormValid = _formKey.currentState!.validate();
    if(isFormValid){
      if(ControllerGeneral.nombreEnUso(_nombre)){  // Comprueba que el nombre que desea el comprador no está en uso en caso afirmativo lo notifica al usuario
        const snackBar = SnackBar(content: Text('El nombre introducido ya existe'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      if(ControllerGeneral.emailEnUso(_correoElectronico)){ // Comprueba que el correo tampoco esté en uso en caso afirmativo lo notifica al usuario
        const snackBar = SnackBar(content: Text('El correo electrónico introducido ya existe'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      LogicaComprador.anadirComprador(Comprador( // Si todo es correcto lo añade a la lista de compradores
       correoElectronico: _correoElectronico!, 
        nombre: _nombre!, 
        contrasena: _contrasena!, 
        direccion: _direccion!,
        imagen: photoPath
      ));
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Appbar con el estilo predeterminado
        automaticallyImplyLeading: false,
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text(
            "¡ REGISTRATE EN GESTIONART !",
            style: AppEstiloTexto.encabezado,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form( // Formulari opara que el usuario ingrese sus datos con validacion de estos
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.validateName(value),
                    onChanged: (value) => _nombre = value,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Dirección",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.validateDireccion(value),
                    onChanged: (value) => _direccion = value,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Correo electronico",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.validateEmail(value),
                    onChanged: (value) => _correoElectronico = value,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    obscureText: _obscurePassword1,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton( //Iono del ojo que permite mostrar y ocultar contraseña al presoanrlo
                        onPressed: () {
                          setState(() {
                            _obscurePassword1 = !_obscurePassword1;
                          });
                        },
                        icon: Icon(
                          _obscurePassword1
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        color: AppColores.colorSecundario,
                      ),
                    ),
                    validator: (value) => Validators.validateEmpty(value),
                    onChanged: (value) => _contrasena = value,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    obscureText: _obscurePassword2,
                    decoration: InputDecoration(
                      labelText: "Repita la contraseña",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword2 = !_obscurePassword2;
                          });
                        },
                        icon: Icon(
                          _obscurePassword2
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        color: AppColores.colorSecundario,
                      ),
                    ),
                    validator: (value) => Validators.validatePassword(value, _contrasena),
                    onChanged: (value) => _contrasena2 = value,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: photoPath != ""
                      ? kIsWeb
                            ? Image.network(photoPath!, fit: BoxFit.fill)
                            : Image.file(File(photoPath!), fit: BoxFit.fill)
                      : Container(),
                ),
                SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      Text(
                        "Añadir imagen",
                        style: AppEstiloTexto.textoSecundario,
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        child: const Icon(Icons.image),
                        onPressed: () async {
                          final path = await CameraGalleryService()
                              .selectPhoto();
                          if (path == null) return;
                          photoPath = path;
                          setState(() {});
                        },
                      ),
                      ElevatedButton(
                        child: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          final path = await CameraGalleryService().takePhoto();
                          if (path == null) return;
                          photoPath = path;
                          setState(() {});
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                photoPath = "";
                              });
                            },
                            icon: Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton( //Si selecciona el boton valida el usuario a través del procedimiento superior
                        style: AppEstiloBotones.botonPrincipal,
                        onPressed: () {
                          _validarComprador();
                        },
                        child: Text(
                          "Resgistrarme",
                          style: AppEstiloTexto.textoPrincipal,
                        ),
                      ),
                      ElevatedButton( // Si no desea registrarse puede cancelar y vuelve a la pantalla de inicio de sesion. 
                        style: AppEstiloBotones.botonPrincipal,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancelar",
                          style: AppEstiloTexto.textoPrincipal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
