import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:provider/provider.dart';

class articulos_view extends StatefulWidget {
  final Vendedor vendedor;
  const articulos_view({super.key, required this.vendedor});

  @override
  State<articulos_view> createState() => _articulos_viewState();
}

class _articulos_viewState extends State<articulos_view> {
  List<Articulo> _articulosFiltrados = [];
  String _categoriaSeleccionada = "Todas";
  bool _isLoading = true;
  bool _isRefreshing = false;

  // Controladores para el diálogo de crear/editar
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  Categoria? _categoriaSeleccionadaForm;
  String? _imagenPath;
  Articulo? _articuloEditando;

  @override
  void initState() {
    super.initState();
    _cargarArticulos();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _cargarArticulos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articuloProvider = Provider.of<Articuloprovider>(
        context,
        listen: false,
      );
      
      final articulos = await articuloProvider.obtenerPorVendedor(widget.vendedor.id);
      
      setState(() {
        _articulosFiltrados = articulos;
        _filtrarPorCategoria();
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando artículos: $e");
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al cargar los artículos: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refrescarArticulos() async {
    setState(() {
      _isRefreshing = true;
    });
    await _cargarArticulos();
    setState(() {
      _isRefreshing = false;
    });
  }

  void _filtrarPorCategoria() {
    if (_categoriaSeleccionada == "Todas") {
      setState(() {
        _articulosFiltrados = _articulosFiltrados;
      });
    } else {
      setState(() {
        _articulosFiltrados = _articulosFiltrados
            .where((a) => a.categoria == _categoriaSeleccionada)
            .toList();
      });
    }
  }

  Future<void> _eliminarArticulo(Articulo articulo) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar obra"),
        content: Text("¿Seguro que quieres eliminar '${articulo.titulo}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              
              try {
                final articuloProvider = Provider.of<Articuloprovider>(
                  context,
                  listen: false,
                );
                await articuloProvider.eliminarArticulo(articulo.id);
                await _cargarArticulos();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Obra eliminada correctamente"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                setState(() {
                  _isLoading = false;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error al eliminar: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoArticulo({Articulo? articulo}) async {
    _articuloEditando = articulo;
    
    if (articulo != null) {
      _tituloController.text = articulo.titulo;
      _descripcionController.text = articulo.descripcion;
      _precioController.text = articulo.precio.toString();
      _stockController.text = articulo.stock.toString();
      _categoriaSeleccionadaForm = _getCategoriaFromString(articulo.categoria);
      _imagenPath = articulo.imagen;
    } else {
      _tituloController.clear();
      _descripcionController.clear();
      _precioController.clear();
      _stockController.clear();
      _categoriaSeleccionadaForm = null;
      _imagenPath = null;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
              articulo == null ? "Crear nueva obra" : "Editar obra",
              style: AppEstiloTexto.textoPrincipal,
            ),
            content: SizedBox(
              width: 400,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Imagen
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: _imagenPath != null && _imagenPath!.isNotEmpty
                              ? DecorationImage(
                                  image: kIsWeb
                                      ? NetworkImage(_imagenPath!)
                                      : FileImage(File(_imagenPath!)) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _imagenPath == null || _imagenPath!.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, size: 40, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Sin imagen",
                                      style: AppEstiloTexto.textoSecundario,
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final path = await CameraGalleryService().selectPhoto();
                                if (path != null) {
                                  setStateDialog(() {
                                    _imagenPath = path;
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                              label: const Text("Galería"),
                              style: AppEstiloBotones.botonSecundario,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final path = await CameraGalleryService().takePhoto();
                                if (path != null) {
                                  setStateDialog(() {
                                    _imagenPath = path;
                                  });
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Cámara"),
                              style: AppEstiloBotones.botonSecundario,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Título
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: "Título",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Introduce un título" : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Descripción
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: "Descripción",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Introduce una descripción" : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Precio y Stock en Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _precioController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Precio (€)",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.euro),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Precio requerido";
                                if (double.tryParse(value) == null) return "Precio inválido";
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Stock",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.inventory),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Stock requerido";
                                if (int.tryParse(value) == null) return "Stock inválido";
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Categoría
                      DropdownButtonFormField<Categoria>(
                        decoration: const InputDecoration(
                          labelText: "Categoría",
                          border: OutlineInputBorder(),
                        ),
                        value: _categoriaSeleccionadaForm,
                        items: Categoria.values.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            _categoriaSeleccionadaForm = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Selecciona una categoría" : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: AppEstiloBotones.botonSecundario,
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = true;
                    });
                    
                    try {
                      final articuloProvider = Provider.of<Articuloprovider>(
                        context,
                        listen: false,
                      );
                      
                      final categoriaNombre = _categoriaSeleccionadaForm!
                          .toString()
                          .split('.')
                          .last;
                      
                      if (_articuloEditando == null) {
                        // Crear nuevo
                        await articuloProvider.crearArticulo(
                          _tituloController.text,
                          _descripcionController.text,
                          double.parse(_precioController.text),
                          _imagenPath ?? '',
                          categoriaNombre,
                          int.parse(_stockController.text),
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Obra creada correctamente"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } else {
                        // Actualizar
                        await articuloProvider.actualizarArticulo(
                          _articuloEditando!.id,
                          _tituloController.text,
                          _descripcionController.text,
                          double.parse(_precioController.text),
                          _imagenPath ?? _articuloEditando!.imagen,
                          categoriaNombre,
                          int.parse(_stockController.text),
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Obra actualizada correctamente"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                      
                      await _cargarArticulos();
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
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
                child: Text(_articuloEditando == null ? "Crear" : "Actualizar"),
              ),
            ],
          );
        },
      ),
    );
  }

  Categoria? _getCategoriaFromString(String categoria) {
    try {
      return Categoria.values.firstWhere(
        (c) => c.toString().split('.').last == categoria,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriasUnicas = ["Todas", ..._articulosFiltrados.map((a) => a.categoria).toSet()];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoArticulo(),
        backgroundColor: AppColores.colorSecundario,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refrescarArticulos,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Filtro por categorías
                  if (_articulosFiltrados.isNotEmpty)
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categoriasUnicas.length,
                        itemBuilder: (context, index) {
                          final categoria = categoriasUnicas[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              label: Text(categoria),
                              selected: _categoriaSeleccionada == categoria,
                              onSelected: (selected) {
                                setState(() {
                                  _categoriaSeleccionada = categoria;
                                  _filtrarPorCategoria();
                                });
                              },
                              backgroundColor: AppColores.colorFondo,
                              selectedColor: AppColores.colorPrimario.withOpacity(0.3),
                              checkmarkColor: AppColores.colorPrimario,
                            ),
                          );
                        },
                      ),
                    ),
                  
                  // Lista de artículos
                  Expanded(
                    child: _articulosFiltrados.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.art_track,
                                  size: 80,
                                  color: AppColores.colorPrimario.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No tienes obras publicadas",
                                  style: AppEstiloTexto.textoPrincipal,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Toca el botón + para crear tu primera obra",
                                  style: AppEstiloTexto.textoSecundario,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _articulosFiltrados.length,
                            itemBuilder: (context, index) {
                              final articulo = _articulosFiltrados[index];
                              return _buildArticuloCard(articulo);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildArticuloCard(Articulo articulo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: articulo.imagen.isNotEmpty
                  ? Image.network(
                      articulo.imagen,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50),
                      ),
                    ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y precio
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        articulo.titulo,
                        style: AppEstiloTexto.textoPrincipal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColores.colorSecundario,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${articulo.precio.toStringAsFixed(2)} €",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Categoría
                Chip(
                  label: Text(
                    articulo.categoria,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColores.colorPrimario.withOpacity(0.1),
                  avatar: const Icon(Icons.category, size: 16),
                ),
                const SizedBox(height: 8),
                
                // Stock
                Row(
                  children: [
                    Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "Stock: ${articulo.stock} unidades",
                      style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Descripción
                Text(
                  articulo.descripcion,
                  style: AppEstiloTexto.textoSecundario,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _mostrarDialogoArticulo(articulo: articulo),
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text("Editar"),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColores.colorPrimario,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _eliminarArticulo(articulo),
                      icon: const Icon(Icons.delete, size: 20),
                      label: const Text("Eliminar"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}