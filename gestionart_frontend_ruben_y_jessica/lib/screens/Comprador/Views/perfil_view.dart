import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoCambiarContrasena.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoEliminarComprador.dart';

class perfil_view extends StatefulWidget {
  const perfil_view({super.key, required this.comprador});
  final Comprador comprador;

  @override
  State<perfil_view> createState() => _perfil_viewState();
}

class _perfil_viewState extends State<perfil_view> {
  String? photoPath = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            SizedBox(
              child: photoPath != ""
                  ? kIsWeb
                        ? Image.network(photoPath!, fit: BoxFit.fill)
                        : Image.file(File(photoPath!), fit: BoxFit.fill)
                  : Image.asset('assets/images/defaultUser.jpg'),
            ),
            SizedBox(
              width: 400,
              child: Row(
                children: [
                  Text("Cambiar imagen", style: AppEstiloTexto.textoSecundario),
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
            Text(widget.comprador.nombre, style: AppEstiloTexto.textoPrincipal),
            SizedBox(height: 20),
            Text(
              widget.comprador.correoElectronico,
              style: AppEstiloTexto.textoPrincipal,
            ),
            SizedBox(height: 20),
            Text(
              widget.comprador.direccion,
              style: AppEstiloTexto.textoPrincipal,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                dialogoCambiarContrasena(context, widget.comprador);
              },
              child: Text("¿Quieres cambiar tu contraseña?"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                Navigator.pushAndRemoveUntil( //opcion de navegación donde podemos eliminar el historial de navegación para que al dar al botón de back no pueda ir a pantallas cuando haya cerrado sesión sin registrarse
                  context, 
                  MaterialPageRoute(builder: (context) =>Pantallainiciosesion()), 
                  (route) => false  // opcion de eliminar registro de ruta
                );
              } , 
              child: Text("Cerrar sesion", style: AppEstiloTexto.textoSecundario,)
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                dialogoEliminarCuenta(context, widget.comprador);
              } , 
              child: Text("Eliminar cuenta", style: AppEstiloTexto.textoSecundario,)
            )
          ],
        ),
      ),
    );
  }
}
