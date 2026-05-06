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
  
  // Formatear fecha para mostrar
  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final compradorProvider = context.watch<Compradorprovider>();
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            SizedBox(
              child: photoPath != ""
                  ? kIsWeb
                        ? Image.network(photoPath!, fit: BoxFit.fill)
                        : Image.file(File(photoPath!), fit: BoxFit.fill)
                  : Image.asset('assets/images/defaultUser.jpg'),
            ),
            SizedBox(
              width: 400,
              child: Row(
                children: [
                  Text("Cambiar imagen", style: AppEstiloTexto.textoSecundario),
                  SizedBox(width: 20),
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
                        icon: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(widget.comprador.nombre, style: AppEstiloTexto.textoPrincipal),
            SizedBox(height: 20),
            Text(
              widget.comprador.correoElectronico,
              style: AppEstiloTexto.textoPrincipal,
            ),
            SizedBox(height: 20),
            Text(
              widget.comprador.direccion,
              style: AppEstiloTexto.textoPrincipal,
            ),
            SizedBox(height: 20),
            // Mostrar tipo de cuenta con un diseño destacado
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM
                    ? Colors.amber.withOpacity(0.2)
                    : AppColores.colorDesactivado.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM
                      ? Colors.amber
                      : AppColores.colorDesactivado,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM
                        ? Icons.star
                        : Icons.person,
                    color: widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM
                        ? Colors.amber
                        : AppColores.colorDesactivado,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Tipo de cuenta: ${widget.comprador.tipoCuenta.toString().split('.').last}",
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM
                          ? Colors.amber[700]
                          : AppColores.colorDesactivado,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Mostrar fechas de premium si el comprador es premium
            if (widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 20, color: Colors.amber[700]),
                        SizedBox(width: 8),
                        Text(
                          "Suscripción Premium",
                          style: AppEstiloTexto.textoPrincipal.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Fecha de inicio",
                              style: AppEstiloTexto.textoSecundario.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _formatearFecha(widget.comprador.fechaInicioPremium!),
                              style: AppEstiloTexto.textoPrincipal.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.amber.withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              "Fecha de fin",
                              style: AppEstiloTexto.textoSecundario.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _formatearFecha(widget.comprador.fechafinPremium!),
                              style: AppEstiloTexto.textoPrincipal.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Calcular días restantes
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _calcularDiasRestantes(widget.comprador.fechafinPremium!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
            TextButton(
              onPressed: () {
                dialogoCambiarContrasena(context, widget.comprador);
              },
              child: Text("¿Quieres cambiar tu contraseña?"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: widget.comprador.tipoCuenta == Tipocuentacomprador.NORMAL
              ? AppEstiloBotones.botonPrincipal
              : AppEstiloBotones.botonSecundario,
              onPressed: (){
                //Simulador de pago por activar premium
                if(widget.comprador.tipoCuenta == Tipocuentacomprador.NORMAL){
                  dialogoActivarPremium(context, widget.comprador);
                }else if(widget.comprador.tipoCuenta == Tipocuentacomprador.PREMIUM){
                  compradorProvider.desactivarPremium(widget.comprador.id);
                }
              }, 
              child: Text(
                widget.comprador.tipoCuenta == Tipocuentacomprador.NORMAL
                ? "Activar premium"
                : "Desactivar premium"
              )
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => Pantallainiciosesion()), 
                  (route) => false
                );
              }, 
              child: Text("Cerrar sesion", style: AppEstiloTexto.textoSecundario,)
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: AppEstiloBotones.botonPrincipal,
              onPressed: () {
                dialogoEliminarCuenta(context, widget.comprador, compradorProvider);
              }, 
              child: Text("Eliminar cuenta", style: AppEstiloTexto.textoSecundario,)
            )
          ],
        ),
      ),
    );
  }
  
  // Método para calcular los días restantes de la suscripción premium
  String _calcularDiasRestantes(DateTime fechaFin) {
    final ahora = DateTime.now();
    final diferencia = fechaFin.difference(ahora);
    
    if (diferencia.inDays < 0) {
      return "Suscripción expirada";
    } else if (diferencia.inDays == 0) {
      return "Último día de suscripción";
    } else {
      return "${diferencia.inDays} días restantes";
    }
  }
}
