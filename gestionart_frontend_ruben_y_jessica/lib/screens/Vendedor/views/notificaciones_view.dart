import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoNotificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Notificacion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/NotificacionProvider.dart';
import 'package:provider/provider.dart';

class NotificacionesView extends StatefulWidget {
  final Vendedor vendedor;
  const NotificacionesView({super.key, required this.vendedor});

  @override
  State<NotificacionesView> createState() => _NotificacionesViewState();
}

class _NotificacionesViewState extends State<NotificacionesView> {
  bool _isLoading = true;
  String _filtroActual = "Todas"; // "Todas", "No leídas", "Leídas"

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notificacionProvider = Provider.of<NotificacionProvider>(
        context,
        listen: false,
      );
      
      await notificacionProvider.fetchNotificacionesPorVendedor(widget.vendedor.id);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando notificaciones: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _marcarTodasComoLeidas() async {
    try {
      final notificacionProvider = Provider.of<NotificacionProvider>(
        context,
        listen: false,
      );
      
      await notificacionProvider.marcarTodasComoLeidas(widget.vendedor.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Todas las notificaciones marcadas como leídas"),
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

  String _getIconoNotificacion(Tiponotificacion tipo) {
    switch (tipo) {
      case Tiponotificacion.NUEVO_PEDIDO:
        return "🛒";
      case Tiponotificacion.STOCK_AGOTADO:
        return "❌";
      case Tiponotificacion.STOCK_BAJO:
        return "⚠️";
      case Tiponotificacion.ANUNCIO_EXPIRADO:
        return "📢";
    }
  }

  String _getMensajeNotificacion(Tiponotificacion tipo) {
    switch (tipo) {
      case Tiponotificacion.NUEVO_PEDIDO:
        return "Tienes un nuevo pedido";
      case Tiponotificacion.STOCK_AGOTADO:
        return "Un producto se ha agotado";
      case Tiponotificacion.STOCK_BAJO:
        return "Hay productos con stock bajo";
      case Tiponotificacion.ANUNCIO_EXPIRADO:
        return "Tu anuncio ha expirado";
    }
  }

  Color _getColorNotificacion(Tiponotificacion tipo) {
    switch (tipo) {
      case Tiponotificacion.NUEVO_PEDIDO:
        return Colors.green;
      case Tiponotificacion.STOCK_AGOTADO:
        return Colors.red;
      case Tiponotificacion.STOCK_BAJO:
        return Colors.orange;
      case Tiponotificacion.ANUNCIO_EXPIRADO:
        return Colors.purple;
    }
  }

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);
    
    if (diferencia.inDays > 0) {
      return "hace ${diferencia.inDays} día${diferencia.inDays == 1 ? '' : 's'}";
    } else if (diferencia.inHours > 0) {
      return "hace ${diferencia.inHours} hora${diferencia.inHours == 1 ? '' : 's'}";
    } else if (diferencia.inMinutes > 0) {
      return "hace ${diferencia.inMinutes} minuto${diferencia.inMinutes == 1 ? '' : 's'}";
    } else {
      return "hace unos segundos";
    }
  }

  List<Notificacion> _filtrarNotificaciones(List<Notificacion> notificaciones) {
    switch (_filtroActual) {
      case "No leídas":
        return notificaciones.where((n) => !n.leido).toList();
      case "Leídas":
        return notificaciones.where((n) => n.leido).toList();
      default:
        return notificaciones;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificacionProvider = Provider.of<NotificacionProvider>(context);
    final notificacionesFiltradas = _filtrarNotificaciones(notificacionProvider.notificaciones);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text(
          "Notificaciones",
          style: AppEstiloTexto.encabezado,
        ),
        centerTitle: true,
        actions: [
          if (notificacionProvider.notificaciones.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all, color: Colors.white),
              onPressed: _marcarTodasComoLeidas,
              tooltip: "Marcar todas como leídas",
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtros
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildFiltroChip("Todas", _filtroActual == "Todas"),
                      const SizedBox(width: 8),
                      _buildFiltroChip("No leídas", _filtroActual == "No leídas"),
                      const SizedBox(width: 8),
                      _buildFiltroChip("Leídas", _filtroActual == "Leídas"),
                    ],
                  ),
                ),
                
                // Lista de notificaciones
                Expanded(
                  child: notificacionProvider.notificaciones.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 80,
                                color: AppColores.colorPrimario.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No tienes notificaciones",
                                style: AppEstiloTexto.textoPrincipal,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Cuando recibas notificaciones aparecerán aquí",
                                style: AppEstiloTexto.textoSecundario,
                              ),
                            ],
                          ),
                        )
                      : notificacionesFiltradas.isEmpty
                          ? Center(
                              child: Text(
                                "No hay notificaciones ${_filtroActual.toLowerCase()}",
                                style: AppEstiloTexto.textoSecundario,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: notificacionesFiltradas.length,
                              itemBuilder: (context, index) {
                                final notificacion = notificacionesFiltradas[index];
                                return _buildNotificacionCard(notificacion);
                              },
                            ),
                ),
              ],
            ),
    );
  }

  Widget _buildFiltroChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtroActual = label;
        });
      },
      backgroundColor: AppColores.colorFondo,
      selectedColor: AppColores.colorPrimario.withOpacity(0.2),
      checkmarkColor: AppColores.colorPrimario,
      labelStyle: TextStyle(
        color: isSelected ? AppColores.colorPrimario : AppColores.colorDesactivado,
      ),
    );
  }

  Widget _buildNotificacionCard(Notificacion notificacion) {
    return Dismissible(
      key: Key(notificacion.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        try {
          final notificacionProvider = Provider.of<NotificacionProvider>(
            context,
            listen: false,
          );
          await notificacionProvider.eliminarNotificacion(
            notificacion.id,
            widget.vendedor.id,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Notificación eliminada"),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
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
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: notificacion.leido
            ? Colors.white
            : AppColores.colorPrimario.withOpacity(0.05),
        child: InkWell(
          onTap: () async {
            if (!notificacion.leido) {
              try {
                final notificacionProvider = Provider.of<NotificacionProvider>(
                  context,
                  listen: false,
                );
                await notificacionProvider.marcarComoLeida(
                  notificacion.id,
                  widget.vendedor.id,
                );
              } catch (e) {
                print("Error al marcar como leída: $e");
              }
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getColorNotificacion(notificacion.tipo).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      _getIconoNotificacion(notificacion.tipo),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMensajeNotificacion(notificacion.tipo),
                        style: AppEstiloTexto.textoPrincipal.copyWith(
                          fontWeight: notificacion.leido ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatearFecha(notificacion.fecha),
                        style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                
                // Indicador de no leído
                if (!notificacion.leido)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                
                // Botón de eliminar
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () async {
                    try {
                      final notificacionProvider = Provider.of<NotificacionProvider>(
                        context,
                        listen: false,
                      );
                      await notificacionProvider.eliminarNotificacion(
                        notificacion.id,
                        widget.vendedor.id,
                      );
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}