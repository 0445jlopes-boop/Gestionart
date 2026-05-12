import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Pedido.dart';
import 'package:provider/provider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoCuentaComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/NotificacionProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/SolicitudExclusivaProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AnuincioProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';

class categorias_view extends StatefulWidget {
  const categorias_view({super.key, required this.categoria, required this.comprador});
  final Categoria categoria;
  final Comprador comprador;
  
  @override
  State<categorias_view> createState() => _categorias_viewState();
}

class _categorias_viewState extends State<categorias_view> {
  late PageController _pageController;
  late PageController _anunciosController;
  List<Articulo> _articulosFiltrados = [];
  List<Anuncio> _anunciosAleatorios = [];
  int _currentIndex = 0;
  int _currentAnuncioIndex = 0;
  bool _isLoading = true;
  Comprador? _compradorActual;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _anunciosController = PageController();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final articuloProvider = context.read<Articuloprovider>();
      final compradorProvider = context.read<Compradorprovider>();
      final anuncioProvider = context.read<AnuncioProvider>();

      _compradorActual = await compradorProvider.obtenerComprador(
        widget.comprador.id,
      );

      String categoriaNombre = widget.categoria.toString().split('.').last;

      _articulosFiltrados =
          (await articuloProvider.obtenerPorCategoria(categoriaNombre)) ?? [];

      if (_compradorActual?.tipoCuenta == Tipocuentacomprador.NORMAL) {
        _articulosFiltrados = _articulosFiltrados
            .where((articulo) => articulo.stock > 0)
            .toList();
      }

      List<Anuncio> todosAnuncios = await anuncioProvider.fetchListaAnuncios();
      List<Anuncio> anunciosCategoria = todosAnuncios
          .where((anuncio) => anuncio.categoria == categoriaNombre)
          .toList();

      if (anunciosCategoria.isNotEmpty) {
        anunciosCategoria.shuffle();
        _anunciosAleatorios = anunciosCategoria.take(3).toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando datos: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _mostrarDialogoMensajeSolicitud() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Solicitud Exclusiva",
          style: AppEstiloTexto.textoPrincipal,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Este producto está agotado. Como usuario Premium, puedes solicitar una edición exclusiva.",
              style: AppEstiloTexto.textoSecundario,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Mensaje para el artista (opcional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.isEmpty ? "Solicito este producto" : controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColores.colorPrimario,
            ),
            child: const Text("Enviar solicitud"),
          ),
        ],
      ),
    );
  }

  Future<void> _crearSolicitudExclusiva(Articulo articulo) async {
    try {
      final solicitudProvider = context.read<SolicitudExclusivaProvider>();
      final notificacionProvider = context.read<NotificacionProvider>();
      
      final mensaje = await _mostrarDialogoMensajeSolicitud();
      if (mensaje == null) return;
      
      await solicitudProvider.crearSolicitudExclusiva(
        _compradorActual!.id,
        articulo.id,
        mensaje,
        articulo.idVendedor,
      );
       print("$articulo.idVendedor");
      await notificacionProvider.crearNotificacion(
       
        articulo.idVendedor,
        Tiponotificacion.SOLICITUD_EXCLUSIVA,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⭐ Solicitud exclusiva enviada al vendedor"),
            backgroundColor: Colors.amber,
          ),
        );
      }
    } catch (e) {
      print("❌ Error al crear solicitud exclusiva: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al enviar solicitud: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _anadirALineaPedido(Articulo articulo) async {
    try {
      if (_compradorActual == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No se encontró el comprador")),
        );
        return;
      }

      // ✅ Si es PREMIUM y stock = 0, crear solicitud exclusiva
      if (_compradorActual?.tipoCuenta == Tipocuentacomprador.PREMIUM && articulo.stock == 0) {
        await _crearSolicitudExclusiva(articulo);
        return;
      }

      // Verificar stock para usuarios NORMALES
      if (_compradorActual?.tipoCuenta == Tipocuentacomprador.NORMAL && articulo.stock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No hay stock disponible de este producto"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final pedidoProvider = context.read<Pedidoprovider>();
      final lineaPedidoProvider = context.read<Lineapedidoprovider>();

      // Obtener pedidos del comprador
      final pedidos = await pedidoProvider.fetchPedidosPorComprador(_compradorActual!.id);
      
      // Buscar pedido existente en estado PENDIENTE
      Pedido? pedidoExistente;
      try {
        pedidoExistente = pedidos.firstWhere(
          (p) => p.idComprador == _compradorActual!.id && 
                 p.estado.toString().split('.').last == "PENDIENTE",
        );
      } catch (e) {
        pedidoExistente = null;
      }

      late int idPedido;

      if (pedidoExistente != null) {
        idPedido = pedidoExistente.id;
        print("📦 Usando pedido existente ID: $idPedido");
      } else {
        // Crear nuevo pedido en estado PENDIENTE
        final nuevoPedido = await pedidoProvider.crearPedido({
          'idComprador': _compradorActual!.id,
          'idVendedor': articulo.idVendedor,
          'estado': 'PENDIENTE'
        });
        idPedido = nuevoPedido.id;
        print("📦 Creando nuevo pedido ID: $idPedido");
      }

      // Crear línea de pedido
      final lineaCreada = await lineaPedidoProvider.crearLineaPedido(
        idPedido,
        articulo.id,
        1,
        articulo.precio,
      );

      if (mounted && lineaCreada != null) {
        // Recargar el pedido actualizado
        await pedidoProvider.fetchPedidoPorId(idPedido);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ ${articulo.titulo} añadido al pedido"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("❌ Error al agregar al pedido: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text(
          widget.categoria.toString().split('.').last,
          style: AppEstiloTexto.encabezado,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _articulosFiltrados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.art_track_outlined,
                        size: 80,
                        color: AppColores.colorPrimario.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _compradorActual?.tipoCuenta == Tipocuentacomprador.NORMAL
                            ? "No hay obras disponibles en esta categoría"
                            : "No hay obras en esta categoría",
                        style: AppEstiloTexto.textoPrincipal.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Pronto llegaran nuevas creaciones artísticas",
                        style: AppEstiloTexto.textoSecundario,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Carrusel de Artículos
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemCount: _articulosFiltrados.length,
                            itemBuilder: (context, index) {
                              final articulo = _articulosFiltrados[index];
                              return _construirCardArticulo(articulo);
                            },
                          ),
                          // Indicador de posición
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${_currentIndex + 1} / ${_articulosFiltrados.length}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Botón añadir al pedido
                    if (_articulosFiltrados.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          onPressed: () => _anadirALineaPedido(_articulosFiltrados[_currentIndex]),
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                          label: Text(
                            "Añadir al pedido",
                            style: AppEstiloTexto.textoPrincipal.copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColores.colorSecundario,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Anuncios destacados
                    if (_anunciosAleatorios.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColores.colorPrimario.withOpacity(0.1),
                              AppColores.colorSecundario.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.campaign, size: 20, color: AppColores.colorPrimario),
                                  const SizedBox(width: 8),
                                  Text(
                                    "ANUNCIOS DESTACADOS",
                                    style: AppEstiloTexto.textoPrincipal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                controller: _anunciosController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentAnuncioIndex = index;
                                  });
                                },
                                itemCount: _anunciosAleatorios.length,
                                itemBuilder: (context, index) {
                                  final anuncio = _anunciosAleatorios[index];
                                  return _construirCardAnuncio(anuncio);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildImage(String? imageUrl, bool isArticulo) {
    const String defaultArticulo = 'assets/images/defaultArticulo.jpg';
    const String defaultAnuncio = 'assets/images/defaultAnuncio.jpg';
    
    final String defaultImage = isArticulo ? defaultArticulo : defaultAnuncio;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        defaultImage,
        fit: BoxFit.cover,
      );
    }
    
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          defaultImage,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _construirCardArticulo(Articulo articulo) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildImage(articulo.imagen, true),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColores.colorPrimario.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      articulo.categoria,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Título
                  Text(
                    articulo.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Descripción
                  Text(
                    articulo.descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Precio y estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColores.colorSecundario,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "${articulo.precio.toStringAsFixed(2)} €",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (_compradorActual?.tipoCuenta == Tipocuentacomprador.NORMAL)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: articulo.stock > 0 ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            articulo.stock > 0 ? "Stock: ${articulo.stock}" : "Agotado",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "Premium",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirCardAnuncio(Anuncio anuncio) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildImage(anuncio.imagen, false),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anuncio.titulo,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColores.colorSecundario,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "${anuncio.precio.toStringAsFixed(2)} €",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _anunciosController.dispose();
    super.dispose();
  }
}