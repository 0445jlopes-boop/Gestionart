import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/VendedorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoCambiarContrasenaVendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoEliminarVendedor.dart';
import 'package:provider/provider.dart';

class perfil_vendedor_view extends StatefulWidget {
  const perfil_vendedor_view({super.key, required this.vendedor});
  final Vendedor vendedor;

  @override
  State<perfil_vendedor_view> createState() => _perfil_vendedor_viewState();
}

class _perfil_vendedor_viewState extends State<perfil_vendedor_view> {
  String? photoPath = "";

  @override
  Widget build(BuildContext context) {
    final vendedorProvider = context.watch<Vendedorprovider>();
    
    return Expanded(
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            // Imagen de perfil
            SizedBox(
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColores.colorPrimario, width: 2),
                ),
                child: ClipOval(
                  child: photoPath != ""
                      ? kIsWeb
                            ? Image.network(
                                photoPath!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              )
                            : Image.file(
                                File(photoPath!),
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              )
                      : Image.asset(
                          'assets/images/defaultUser.jpg',
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                ),
              ),
            ),

            // Botones para cambiar imagen
            SizedBox(
              width: 400,
              child: Row(
                children: [
                  Text("Cambiar imagen", style: AppEstiloTexto.textoSecundario),
                  const SizedBox(width: 20),
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
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nombre
            Text(widget.vendedor.nombre, style: AppEstiloTexto.textoPrincipal),

            const SizedBox(height: 20),

            // Correo electrónico
            Text(
              widget.vendedor.correoElectronico,
              style: AppEstiloTexto.textoPrincipal,
            ),

            const SizedBox(height: 20),

            // Descripción del perfil
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColores.colorFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColores.colorPrimario.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Descripción del perfil:",
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.vendedor.descripcionPerfil,
                    style: AppEstiloTexto.textoSecundario,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // Botón cambiar contraseña
            TextButton(
              onPressed: () {
                dialogoCambiarContrasenaVendedor(context, widget.vendedor);
              },
              child: const Text("¿Quieres cambiar tu contraseña?"),
            ),
            
            const SizedBox(height: 20),
            
            // Botón cerrar sesión
            ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Pantallainiciosesion()),
                  (route) => false,
                );
              },
              child: Text("Cerrar sesión", style: AppEstiloTexto.textoSecundario),
            ),
            
            const SizedBox(height: 20),
            
            // Botón eliminar cuenta
            ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                dialogoEliminarVendedor(context, widget.vendedor, vendedorProvider);
              },
              child: Text("Eliminar cuenta", style: AppEstiloTexto.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }
}