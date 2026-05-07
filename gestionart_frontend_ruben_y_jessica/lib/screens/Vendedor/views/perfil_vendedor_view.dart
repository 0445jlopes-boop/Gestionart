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
  late Vendedor _vendedorActualizado;

  @override
  void initState() {
    super.initState();
    _vendedorActualizado = widget.vendedor;
  }

  @override
  void didUpdateWidget(perfil_vendedor_view oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el vendedor del widget cambió, actualizar el estado
    if (oldWidget.vendedor.id != widget.vendedor.id ||
        oldWidget.vendedor.nombre != widget.vendedor.nombre) {
      _vendedorActualizado = widget.vendedor;
    }
  }

  // Método para actualizar el vendedor después de cambios
  Future<void> _actualizarVendedor(Vendedorprovider vendedorProvider) async {
    try {
      final vendedorActualizado = await vendedorProvider.obtenerVendedor(
        _vendedorActualizado.id,
      );
      if (vendedorActualizado != null && mounted) {
        setState(() {
          _vendedorActualizado = vendedorActualizado;
        });
      }
    } catch (e) {
      print("Error actualizando vendedor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendedorProvider = context.watch<Vendedorprovider>();
    
    return SingleChildScrollView(
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
                      : _vendedorActualizado.imagen.isNotEmpty
                          ? Image.network(
                              _vendedorActualizado.imagen,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/defaultUser.jpg',
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                );
                              },
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  if (photoPath != "")
                    IconButton(
                      onPressed: () {
                        setState(() {
                          photoPath = "";
                        });
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nombre
            Text(
              _vendedorActualizado.nombre,
              style: AppEstiloTexto.textoPrincipal,
            ),

            const SizedBox(height: 20),

            // Correo electrónico
            Text(
              _vendedorActualizado.correoElectronico,
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
                    _vendedorActualizado.descripcionPerfil,
                    style: AppEstiloTexto.textoSecundario,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botón actualizar descripción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _mostrarDialogoEditarDescripcion(vendedorProvider);
                },
                icon: const Icon(Icons.edit),
                label: const Text("Editar descripción"),
                style: AppEstiloBotones.botonSecundario,
              ),
            ),

            const SizedBox(height: 20),

            // Botón cambiar contraseña
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  dialogoCambiarContrasenaVendedor(context, _vendedorActualizado);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("¿Quieres cambiar tu contraseña?"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón cerrar sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pantallainiciosesion(),
                    ),
                    (route) => false,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Cerrar sesión"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón eliminar cuenta
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: () {
                  dialogoEliminarVendedor(
                    context,
                    _vendedorActualizado,
                    vendedorProvider,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Eliminar cuenta"),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Diálogo para editar descripción
  void _mostrarDialogoEditarDescripcion(Vendedorprovider vendedorProvider) {
    final descripcionController = TextEditingController(
      text: _vendedorActualizado.descripcionPerfil,
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Editar descripción",
            style: AppEstiloTexto.textoPrincipal,
          ),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 300,
              child: TextFormField(
                controller: descripcionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Escribe una descripción" : null,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  
                  // Mostrar loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Actualizando descripción..."),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  
                  try {
                    await vendedorProvider.actualizarVendedor(
                      _vendedorActualizado.id,
                      _vendedorActualizado.correoElectronico,
                      _vendedorActualizado.nombre,
                      descripcionController.text,
                      _vendedorActualizado.imagen,
                      "",
                    );
                    
                    // Recargar datos
                    await _actualizarVendedor(vendedorProvider);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Descripción actualizada"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}