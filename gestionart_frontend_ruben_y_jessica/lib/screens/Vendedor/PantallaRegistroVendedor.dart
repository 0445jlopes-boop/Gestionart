import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AuthProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/VendedorProvider.dart';
import 'package:provider/provider.dart';

class Pantallaregistrovendedor extends StatefulWidget {
  const Pantallaregistrovendedor({super.key});

  @override
  State<Pantallaregistrovendedor> createState() =>
      _PantallaregistrovendedorState();
}

class _PantallaregistrovendedorState extends State<Pantallaregistrovendedor> {
  //DECLARACIÓN DE VARIABLES A USAR EN EL FORMULARIO
  final _formKey = GlobalKey<FormState>(); 
  String _nombre = "";
  String _descripcionPerfil = "";
  String _correoElectronico = "";
  String _contrasena = "";
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  String _contrasena2 = "";
  String? photoPath = "";
  
  // En tu pantalla de registro, asegúrate de tener estos métodos:

void _validarVendedor() async {
  final isFormValid = _formKey.currentState!.validate();
  final authProvider = context.read<Authprovider>();
  final vendedorProvider = context.read<Vendedorprovider>();
  
  if(isFormValid){
    if(await vendedorProvider.obtenerVendedorPorNombre(_nombre) != null){  
      const snackBar = SnackBar(content: Text('El nombre introducido ya existe'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    else if(await vendedorProvider.obtenerVendedorPorCorreo(_correoElectronico) != null){ 
      const snackBar = SnackBar(content: Text('El correo electrónico introducido ya existe'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    
    bool registrado = await authProvider.registerVendedor(
      _correoElectronico,
      _nombre,
      _descripcionPerfil,
      photoPath ?? "",
      _contrasena
    );
    
    if (registrado){
      const snackBar = SnackBar(content: Text('Perfil de vendedor creado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      const snackBar = SnackBar(content: Text('Perfil de vendedor no creado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text(
            "¡ REGISTRATE COMO VENDEDOR !",
            style: AppEstiloTexto.encabezado,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                
                // Nombre
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
                
                // Correo electrónico
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Correo electrónico",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.validateEmail(value),
                    onChanged: (value) => _correoElectronico = value,
                  ),
                ),
                SizedBox(height: 20),
                
                // Descripción del perfil
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Descripción del perfil",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      hintText: "Cuéntanos sobre ti y tu arte...",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.validateEmpty(value),
                    onChanged: (value) => _descripcionPerfil = value,
                  ),
                ),
                SizedBox(height: 20),
                
                // Contraseña
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    obscureText: _obscurePassword1,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: AppEstiloTexto.textoPrincipal,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
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
                
                // Repetir contraseña
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
                
                // Imagen de perfil
                SizedBox(
                  child: photoPath != ""
                      ? kIsWeb
                            ? Image.network(photoPath!, fit: BoxFit.fill, height: 150, width: 150)
                            : Image.file(File(photoPath!), fit: BoxFit.fill, height: 150, width: 150)
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppColores.colorFondo,
                            borderRadius: BorderRadius.circular(75),
                            border: Border.all(color: AppColores.colorPrimario, width: 2),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: AppColores.colorDesactivado,
                          ),
                        ),
                ),
                SizedBox(height: 10),
                
                // Botones para imagen
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Añadir imagen",
                        style: AppEstiloTexto.textoSecundario,
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        child: const Icon(Icons.image),
                        onPressed: () async {
                          final path = await CameraGalleryService().selectPhoto();
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
                      if (photoPath != "")
                        IconButton(
                          onPressed: () {
                            setState(() {
                              photoPath = "";
                            });
                          },
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Botones de acción
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: AppEstiloBotones.botonPrincipal,
                          onPressed: () {
                            _validarVendedor();
                          },
                          child: Text(
                            "Registrarme",
                            style: AppEstiloTexto.textoPrincipal,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: AppEstiloBotones.botonPrincipal,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancelar",
                            style: AppEstiloTexto.textoPrincipal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}