import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoPago.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AnuincioProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaPago.dart';
import 'package:provider/provider.dart';

class anuncios_view extends StatefulWidget {
  final Vendedor vendedor;
  const anuncios_view({super.key, required this.vendedor});

  @override
  State<anuncios_view> createState() => _anuncios_viewState();
}

class _anuncios_viewState extends State<anuncios_view> {
  List<Anuncio> _anuncios = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  // Controladores para el diálogo de crear anuncio
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _precioController = TextEditingController();
  Categoria? _categoriaSeleccionada;
  String? _imagenPath;

  @override
  void initState() {
    super.initState();
    _cargarAnuncios();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _cargarAnuncios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final anuncioProvider = Provider.of<AnuncioProvider>(
        context,
        listen: false,
      );
      
      final todosAnuncios = await anuncioProvider.fetchListaAnuncios();
      
      // Filtrar anuncios del vendedor actual
      setState(() {
        _anuncios = todosAnuncios.where((a) => a.idVendedor == widget.vendedor.id).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando anuncios: $e");
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al cargar los anuncios: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refrescarAnuncios() async {
    setState(() {
      _isRefreshing = true;
    });
    await _cargarAnuncios();
    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _eliminarAnuncio(Anuncio anuncio) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Eliminar anuncio",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: Text(
          "¿Seguro que quieres eliminar el anuncio '${anuncio.titulo}'?",
          style: AppEstiloTexto.textoSecundario,
        ),
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
                final anuncioProvider = Provider.of<AnuncioProvider>(
                  context,
                  listen: false,
                );
                await anuncioProvider.eliminarAnuncio(anuncio.id);
                await _cargarAnuncios();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Anuncio eliminado correctamente"),
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
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  String _calcularDiasRestantes(DateTime fechaFin) {
    final ahora = DateTime.now();
    final diferencia = fechaFin.difference(ahora);
    
    if (diferencia.inDays < 0) {
      return "Expirado";
    } else if (diferencia.inDays == 0) {
      return "Último día";
    } else {
      return "${diferencia.inDays} días restantes";
    }
  }

  Future<void> _crearAnuncio() async {
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
      
      // Cerrar el diálogo
      Navigator.pop(context);
      
      // Navegar a la pantalla de pago
      final pagoExitoso = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pago_view(
            pago: Tipopago.PUBLICIDAD,
            importe: 2.0,
          ),
        ),
      );
      
      // Si el pago fue exitoso, crear el anuncio
      if (pagoExitoso == true) {
        setState(() {
          _isLoading = true;
        });
        
        try {
          final anuncioProvider = Provider.of<AnuncioProvider>(
            context,
            listen: false,
          );
          
          final categoriaNombre = _categoriaSeleccionada!.toString().split('.').last;
          
          await anuncioProvider.crearAnuncio(
            widget.vendedor.id,
            _tituloController.text,
            categoriaNombre,
            double.parse(_precioController.text),
            _imagenPath!,
          );
          
          await _cargarAnuncios();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("¡Anuncio creado correctamente!"),
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
                content: Text("Error al crear el anuncio: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  void _mostrarDialogoCrearAnuncio() {
    _tituloController.clear();
    _precioController.clear();
    _categoriaSeleccionada = null;
    _imagenPath = null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text(
              "Crear nuevo anuncio",
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
                      // Información de costo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColores.colorPrimario.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(height: 16),
                      
                      // Imagen
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: _imagenPath != null
                              ? DecorationImage(
                                  image: kIsWeb
                                      ? NetworkImage(_imagenPath!)
                                      : FileImage(File(_imagenPath!)) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _imagenPath == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, size: 40, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Selecciona una imagen",
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
                          labelText: "Título del anuncio",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Introduce un título" : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Precio del producto
                      TextFormField(
                        controller: _precioController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Precio del producto (€)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.euro),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Introduce un precio";
                          if (double.tryParse(value) == null) return "Precio inválido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      
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
                          setStateDialog(() {
                            _categoriaSeleccionada = value;
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
                onPressed: _crearAnuncio,
                child: const Text("Pagar 2€ y publicar"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoCrearAnuncio,
        backgroundColor: AppColores.colorSecundario,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refrescarAnuncios,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _anuncios.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign,
                          size: 80,
                          color: AppColores.colorPrimario.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No tienes anuncios activos",
                          style: AppEstiloTexto.textoPrincipal,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Toca el botón + para crear tu primer anuncio",
                          style: AppEstiloTexto.textoSecundario,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _mostrarDialogoCrearAnuncio,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColores.colorSecundario,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            "Crear anuncio (2€/mes)",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _anuncios.length,
                    itemBuilder: (context, index) {
                      final anuncio = _anuncios[index];
                      return _buildAnuncioCard(anuncio);
                    },
                  ),
      ),
    );
  }

  Widget _buildAnuncioCard(Anuncio anuncio) {
    final diasRestantes = _calcularDiasRestantes(anuncio.fechaFin);
    final isExpirado = diasRestantes == "Expirado";
    
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
              height: 160,
              width: double.infinity,
              child: anuncio.imagen.isNotEmpty
                  ? Image.network(
                      anuncio.imagen,
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
                        anuncio.titulo,
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
                        "${anuncio.precio.toStringAsFixed(2)} €",
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
                    anuncio.categoria,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColores.colorPrimario.withOpacity(0.1),
                  avatar: const Icon(Icons.category, size: 16),
                ),
                const SizedBox(height: 12),
                
                // Estado y fechas
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isExpirado
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isExpirado ? Icons.warning : Icons.check_circle,
                        size: 16,
                        color: isExpirado ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isExpirado ? "Anuncio expirado" : "Anuncio activo",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isExpirado ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      Text(
                        diasRestantes,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isExpirado ? Colors.red : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Fechas
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Inicio",
                            style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 10),
                          ),
                          Text(
                            _formatearFecha(anuncio.fechaInicio),
                            style: AppEstiloTexto.textoPrincipal.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fin",
                            style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 10),
                          ),
                          Text(
                            _formatearFecha(anuncio.fechaFin),
                            style: AppEstiloTexto.textoPrincipal.copyWith(
                              fontSize: 12,
                              color: isExpirado ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Botón de eliminar
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _eliminarAnuncio(anuncio),
                      icon: const Icon(Icons.delete, size: 20),
                      label: const Text("Eliminar anuncio"),
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