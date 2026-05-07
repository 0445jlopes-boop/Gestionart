import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AnuincioProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaPago.dart';
import 'package:provider/provider.dart';

class crear_anuncio_view extends StatefulWidget {
  const crear_anuncio_view({super.key, required this.vendedor});
  final Vendedor vendedor;

  @override
  State<crear_anuncio_view> createState() => _crear_anuncio_viewState();
}

class _crear_anuncio_viewState extends State<crear_anuncio_view> {
  final _formKey = GlobalKey<FormState>();
  
  final tituloController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();
  
  Categoria? _categoriaSeleccionada;
  String? _imagenPath;
  bool _isLoading = false;

  @override
  void dispose() {
    tituloController.dispose();
    precioController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final path = await CameraGalleryService().selectPhoto();
    if (path != null) {
      setState(() {
        _imagenPath = path;
      });
    }
  }

  Future<void> _tomarFoto() async {
    final path = await CameraGalleryService().takePhoto();
    if (path != null) {
      setState(() {
        _imagenPath = path;
      });
    }
  }

  void _procederAlPago() {
    if (_formKey.currentState!.validate()) {
      if (_categoriaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selecciona una categoría"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_imagenPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selecciona una imagen"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Navegar a la pantalla de pago
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pago_view(
            pago: Tipopago.PUBLICIDAD,
            importe: 2.0,
            comprador: null, // No aplica para vendedor, pero el parámetro es requerido
          ),
        ),
      ).then((_) async {
        // Cuando regrese del pago, crear el anuncio
        await _crearAnuncio();
      });
    }
  }

  Future<void> _crearAnuncio() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final anuncioProvider = Provider.of<AnuncioProvider>(context, listen: false);
      
      // Calcular fechas (1 mes desde hoy)
      final fechaInicio = DateTime.now();
      final fechaFin = DateTime.now().add(const Duration(days: 30));
      
      // Crear el anuncio (subir imagen y crear)
      // Nota: Necesitarás subir la imagen primero o pasar la ruta local
      await anuncioProvider.crearAnuncio(
        widget.vendedor.id,
        tituloController.text,
        _categoriaSeleccionada!.toString().split('.').last,
        double.parse(precioController.text),
        _imagenPath!, // Aquí deberías subir la imagen o usar una URL
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Anuncio creado correctamente!"),
            backgroundColor: Colors.green,
          ),
        );
        
        // Volver a la pantalla anterior
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al crear el anuncio: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text(
          "Crear Anuncio",
          style: AppEstiloTexto.encabezado,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Precio del anuncio
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColores.colorPrimario.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColores.colorPrimario),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Costo del anuncio",
                                    style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                                  ),
                                  Text(
                                    "2€ por 1 mes de publicación",
                                    style: AppEstiloTexto.textoPrincipal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColores.colorSecundario,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Título
                      TextFormField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: "Título del anuncio",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Introduce un título" : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Precio del producto
                      TextFormField(
                        controller: precioController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Precio (€)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.euro),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Introduce un precio";
                          }
                          if (double.tryParse(value) == null) {
                            return "Precio inválido";
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Categoría
                      DropdownButtonFormField<Categoria>(
                        decoration: const InputDecoration(
                          labelText: "Categoría",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        value: _categoriaSeleccionada,
                        items: Categoria.values.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _categoriaSeleccionada = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Selecciona una categoría" : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Imagen
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Imagen del anuncio",
                            style: AppEstiloTexto.textoPrincipal,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _seleccionarImagen,
                                  icon: const Icon(Icons.image),
                                  label: const Text("Galería"),
                                  style: AppEstiloBotones.botonSecundario,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _tomarFoto,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text("Cámara"),
                                  style: AppEstiloBotones.botonSecundario,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_imagenPath != null) ...[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColores.colorPrimario),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: kIsWeb
                                    ? Image.network(_imagenPath!, height: 150, width: double.infinity, fit: BoxFit.cover)
                                    : Image.file(File(_imagenPath!), height: 150, width: double.infinity, fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _imagenPath = null;
                                  });
                                },
                                icon: const Icon(Icons.delete, size: 16),
                                label: const Text("Eliminar imagen"),
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Botón de pago
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColores.colorSecundario,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _procederAlPago,
                          child: const Text(
                            "PAGAR 2€ Y PUBLICAR",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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