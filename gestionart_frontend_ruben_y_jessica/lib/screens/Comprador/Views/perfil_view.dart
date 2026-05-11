import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/CameraGalleryService.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/TipoCuentaComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/PantallaInicioSesion.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoActivarPremium.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoCambiarContrasena.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoEliminarComprador.dart';
import 'package:provider/provider.dart';

class perfil_view extends StatefulWidget {
  const perfil_view({super.key, required this.comprador});
  final Comprador comprador;

  @override
  State<perfil_view> createState() => _perfil_viewState();
}

class _perfil_viewState extends State<perfil_view> {
  String? photoPath = "";
  late Comprador _compradorActualizado;

  @override
  void initState() {
    super.initState();
    _compradorActualizado = widget.comprador;
  }

  // ✅ Método para recargar los datos desde el backend
  Future<void> _recargarDatos(Compradorprovider provider) async {
    final compradorActualizado = await provider.obtenerComprador(_compradorActualizado.id);
    if (compradorActualizado != null && mounted) {
      setState(() {
        _compradorActualizado = compradorActualizado;
      });
    }
  }

  Future<void> _cambiarEstadoPremium(Compradorprovider compradorProvider) async {
    try {
      if (_compradorActualizado.tipoCuenta == Tipocuentacomprador.NORMAL) {
        final result = await dialogoActivarPremium(context, _compradorActualizado);
        if (result != null && result is Comprador) {
          setState(() {
            _compradorActualizado = result;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("¡Premium activado correctamente!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (_compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM) {
        await compradorProvider.desactivarPremium(_compradorActualizado.id);
        // ✅ Recargar datos después de desactivar
        await _recargarDatos(compradorProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Premium desactivado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _cambiarImagen(String path, Compradorprovider provider) async {
    final actualizado = await provider.actualizarComprador(
      _compradorActualizado.id,
      _compradorActualizado.correoElectronico,
      _compradorActualizado.nombre,
      _compradorActualizado.direccion,
      path,
      _compradorActualizado.contrasena,
    );
    if (actualizado != null && mounted) {
      setState(() {
        _compradorActualizado = actualizado;
        photoPath = path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen actualizada"), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _eliminarImagen(Compradorprovider provider) async {
    final actualizado = await provider.actualizarComprador(
      _compradorActualizado.id,
      _compradorActualizado.correoElectronico,
      _compradorActualizado.nombre,
      _compradorActualizado.direccion,
      "",
      _compradorActualizado.contrasena,
    );
    if (actualizado != null && mounted) {
      setState(() {
        _compradorActualizado = actualizado;
        photoPath = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen eliminada"), backgroundColor: Colors.green),
      );
    }
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final compradorProvider = context.watch<Compradorprovider>();
    
    return RefreshIndicator(
      onRefresh: () => _recargarDatos(compradorProvider),
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
                          : _compradorActualizado.imagen.isNotEmpty
                              ? Image.network(
                                  _compradorActualizado.imagen,
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

                // Botones imagen
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
                          if (path != null) await _cambiarImagen(path, compradorProvider);
                        },
                        child: const Icon(Icons.image),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final path = await CameraGalleryService().takePhoto();
                          if (path != null) await _cambiarImagen(path, compradorProvider);
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        onPressed: () => _eliminarImagen(compradorProvider),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Text(_compradorActualizado.nombre, style: AppEstiloTexto.textoPrincipal),
                const SizedBox(height: 20),
                Text(_compradorActualizado.correoElectronico, style: AppEstiloTexto.textoPrincipal),
                const SizedBox(height: 20),
                Text(_compradorActualizado.direccion, style: AppEstiloTexto.textoPrincipal),
                const SizedBox(height: 20),

                // Tipo de cuenta
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM
                        ? Colors.amber.withOpacity(0.2)
                        : AppColores.colorDesactivado.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM ? Colors.amber : AppColores.colorDesactivado,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM ? Icons.star : Icons.person,
                        color: _compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM ? Colors.amber : AppColores.colorDesactivado,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Tipo de cuenta: ${_compradorActualizado.tipoCuenta.toString().split('.').last}",
                        style: AppEstiloTexto.textoPrincipal.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM ? Colors.amber[700] : AppColores.colorDesactivado,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Fechas premium
                if (_compradorActualizado.tipoCuenta == Tipocuentacomprador.PREMIUM) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 20, color: Colors.amber[700]),
                            const SizedBox(width: 8),
                            Text("Suscripción Premium", style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, color: Colors.amber[700])),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(children: [Text("Inicio", style: AppEstiloTexto.textoSecundario), Text(_formatearFecha(_compradorActualizado.fechaInicioPremium!), style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold))]),
                            Container(height: 30, width: 1, color: Colors.amber.withOpacity(0.3)),
                            Column(children: [Text("Fin", style: AppEstiloTexto.textoSecundario), Text(_formatearFecha(_compradorActualizado.fechafinPremium!), style: AppEstiloTexto.textoPrincipal.copyWith(fontWeight: FontWeight.bold, color: Colors.red[400]))]),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text(_calcularDiasRestantes(_compradorActualizado.fechafinPremium!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.amber)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TextButton(
                  onPressed: () => dialogoCambiarContrasenaComprador(context, widget.comprador),
                  child: const Text("¿Quieres cambiar tu contraseña?"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: _compradorActualizado.tipoCuenta == Tipocuentacomprador.NORMAL ? AppEstiloBotones.botonPrincipal : AppEstiloBotones.botonSecundario,
                  onPressed: () => _cambiarEstadoPremium(compradorProvider),
                  child: Text(_compradorActualizado.tipoCuenta == Tipocuentacomprador.NORMAL ? "Activar premium (5€/3 meses)" : "Desactivar premium"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: AppEstiloBotones.botonPrincipal,
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Pantallainiciosesion()), (route) => false),
                  child: const Text("Cerrar sesión"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: AppEstiloBotones.botonPrincipal,
                  onPressed: () => dialogoEliminarCuenta(context, _compradorActualizado, compradorProvider),
                  child: const Text("Eliminar cuenta"),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _calcularDiasRestantes(DateTime fechaFin) {
    final diferencia = fechaFin.difference(DateTime.now());
    if (diferencia.inDays < 0) return "Suscripción expirada";
    if (diferencia.inDays == 0) return "Último día de suscripción";
    return "${diferencia.inDays} días restantes";
  }
}