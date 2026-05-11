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

  // ✅ Método para recargar los datos desde el backend
  Future<void> _recargarDatos(Vendedorprovider provider) async {
    final vendedorActualizado = await provider.obtenerVendedor(_vendedorActualizado.id);
    if (vendedorActualizado != null && mounted) {
      setState(() {
        _vendedorActualizado = vendedorActualizado;
      });
    }
  }

  Future<void> _cambiarImagen(String path, Vendedorprovider provider) async {
    final actualizado = await provider.actualizarVendedor(
      _vendedorActualizado.id,
      _vendedorActualizado.correoElectronico,
      _vendedorActualizado.nombre,
      _vendedorActualizado.descripcionPerfil,
      path,
      _vendedorActualizado.contrasena,
    );
    if (actualizado != null && mounted) {
      setState(() {
        _vendedorActualizado = actualizado;
        photoPath = path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen actualizada"), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _eliminarImagen(Vendedorprovider provider) async {
    final actualizado = await provider.actualizarVendedor(
      _vendedorActualizado.id,
      _vendedorActualizado.correoElectronico,
      _vendedorActualizado.nombre,
      _vendedorActualizado.descripcionPerfil,
      "",
      _vendedorActualizado.contrasena,
    );
    if (actualizado != null && mounted) {
      setState(() {
        _vendedorActualizado = actualizado;
        photoPath = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen eliminada"), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _actualizarDescripcion(String nuevaDescripcion, Vendedorprovider provider) async {
    final actualizado = await provider.actualizarVendedor(
      _vendedorActualizado.id,
      _vendedorActualizado.correoElectronico,
      _vendedorActualizado.nombre,
      nuevaDescripcion,
      _vendedorActualizado.imagen,
      _vendedorActualizado.contrasena,
    );
    if (actualizado != null && mounted) {
      setState(() {
        _vendedorActualizado = actualizado;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Descripción actualizada"), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendedorProvider = context.watch<Vendedorprovider>();
    
    return RefreshIndicator(
      onRefresh: () => _recargarDatos(vendedorProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                const SizedBox(height: 20),

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
                              ? Image.network(photoPath!, fit: BoxFit.cover, width: 150, height: 150)
                              : Image.file(File(photoPath!), fit: BoxFit.cover, width: 150, height: 150)
                          : _vendedorActualizado.imagen.isNotEmpty
                              ? Image.network(
                                  _vendedorActualizado.imagen,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                  errorBuilder: (_, __, ___) => Image.asset('assets/images/defaultUser.jpg'),
                                )
                              : Image.asset('assets/images/defaultUser.jpg', fit: BoxFit.cover, width: 150, height: 150),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Botones para cambiar imagen
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Cambiar imagen", style: AppEstiloTexto.textoSecundario),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final path = await CameraGalleryService().selectPhoto();
                          if (path != null) await _cambiarImagen(path, vendedorProvider);
                        },
                        child: const Icon(Icons.image),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final path = await CameraGalleryService().takePhoto();
                          if (path != null) await _cambiarImagen(path, vendedorProvider);
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        onPressed: () => _eliminarImagen(vendedorProvider),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Nombre
                Text(_vendedorActualizado.nombre, style: AppEstiloTexto.textoPrincipal),

                const SizedBox(height: 20),

                // Correo electrónico
                Text(_vendedorActualizado.correoElectronico, style: AppEstiloTexto.textoPrincipal),

                const SizedBox(height: 20),

                // Descripción del perfil
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColores.colorFondo,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColores.colorPrimario.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Descripción del perfil:",
                            style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => _mostrarDialogoEditarDescripcion(vendedorProvider),
                            icon: const Icon(Icons.edit, size: 18),
                            color: AppColores.colorPrimario,
                          ),
                        ],
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

                // Botón cambiar contraseña
                TextButton(
                  onPressed: () => dialogoCambiarContrasenaVendedor(context, _vendedorActualizado),
                  child: const Text("¿Quieres cambiar tu contraseña?"),
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
                        MaterialPageRoute(builder: (context) => const Pantallainiciosesion()),
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
                      dialogoEliminarVendedor(context, _vendedorActualizado, vendedorProvider);
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
        ),
      ),
    );
  }

  void _mostrarDialogoEditarDescripcion(Vendedorprovider vendedorProvider) {
    final descripcionController = TextEditingController(
      text: _vendedorActualizado.descripcionPerfil,
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar descripción", style: AppEstiloTexto.textoPrincipal),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: descripcionController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Descripción",
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty ? "Escribe una descripción" : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                await _actualizarDescripcion(descripcionController.text, vendedorProvider);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}