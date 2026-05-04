import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:provider/provider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoCuentaComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Aticulo.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Anuncio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/ArticuloProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/PedidoProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/LineaPedidoProvider.dart';
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
      final articuloProvider =
          Provider.of<Articuloprovider>(context, listen: false);
      final compradorProvider =
          Provider.of<Compradorprovider>(context, listen: false);
      final anuncioProvider =
          Provider.of<AnuncioProvider>(context, listen: false);

      // Cargar todos los artículos
      await articuloProvider.fetchArticulos();

      // Obtener el comprador actual (usando el ID guardado, ejemplo: 1)
      _compradorActual = await compradorProvider.obtenerComprador(widget.comprador.id);

      // Obtener todos los anuncios
      List<Anuncio> todosAnuncios =
          await anuncioProvider.fetchListaAnuncios();

      // Filtrar artículos según categoría y tipo de cuenta
      String categoriaNombre = widget.categoria.toString().split('.').last;
      _articulosFiltrados =
          articuloProvider.articulos.where((articulo) {
        bool mismaCategoria = articulo.categoria == categoriaNombre;
        bool cumplenStock = true;

        if (_compradorActual?.tipoCuenta == Tipocuentacomprador.NORMAL) {
          cumplenStock = articulo.stock > 0;
        }
        // Si es premium, se muestran todos

        return mismaCategoria && cumplenStock;
      }).toList();

      // Filtrar anuncios de la categoría y obtener aleatorios
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

  Future<void> _anadirALineaPedido(Articulo articulo) async {
    try {
      final pedidoProvider =
          Provider.of<Pedidoprovider>(context, listen: false);
      final lineaPedidoProvider =
          Provider.of<Lineapedidoprovider>(context, listen: false);

      if (_compradorActual == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No se encontró el comprador")),
        );
        return;
      }

      // Crear o obtener pedido existente
      // Obtener pedidos del comprador
      await pedidoProvider.fetchPedidosPorComprador(_compradorActual!.id);
      var pedidoExistente = pedidoProvider.pedidos.isNotEmpty
          ? pedidoProvider.pedidos.firstWhere(
              (p) =>
                  p.idComprador == _compradorActual!.id &&
                  p.idVendeodr == articulo.idVendedor,)
          : null;

      late dynamic idPedido;

      if (pedidoExistente != null) {
        idPedido = pedidoExistente.id;
      } else {
        // Crear nuevo pedido
        final nuevoPedido =
            await pedidoProvider.crearPedido(_compradorActual!.id);
        idPedido = nuevoPedido.id;
      }

      // Agregar línea de pedido
      await lineaPedidoProvider.crearLineaPedido(
        idPedido,
        articulo.id,
        1, // cantidad
        articulo.precio.toDouble(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${articulo.titulo} agregado al carrito"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error al agregar al carrito: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al agregar al carrito: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _articulosFiltrados.isEmpty
              ? Center(
                  child: Text(
                    _compradorActual?.tipoCuenta ==
                            Tipocuentacomprador.NORMAL
                        ? "No hay artículos disponibles en esta categoría"
                        : "No hay artículos en esta categoría",
                    style: AppEstiloTexto.textoSecundario
                  ),
                )
              : Column(
                  children: [
                    // Carrusel de Artículos
                    Expanded(
                      flex: 2,
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
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                "${_currentIndex + 1} / ${_articulosFiltrados.length}",
                                style:AppEstiloTexto.textoPrincipal
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón de carrito
                    if (_articulosFiltrados.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _anadirALineaPedido(_articulosFiltrados[_currentIndex]),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text("Agregar al carrito", style: AppEstiloTexto.textoSecundario,),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Anuncios aleatorios
                    if (_anunciosAleatorios.isNotEmpty)
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            const Text(
                              "Anuncios Destacados",
                              style: AppEstiloTexto.textoPrincipal
                            ),
                            const SizedBox(height: 8),
                            Expanded(
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

  Widget _construirCardArticulo(Articulo articulo) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Imagen de fondo
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(articulo.imagen),
                  fit: BoxFit.cover)
              ),
            ),
            // Overlay oscuro
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    articulo.titulo,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    articulo.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${articulo.precio.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_compradorActual?.tipoCuenta ==
                          Tipocuentacomprador.NORMAL)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: articulo.stock > 0
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Stock: ${articulo.stock}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Premium ⭐",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              anuncio.imagen,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    anuncio.titulo,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${anuncio.precio.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
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