import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/VendedorProvider.dart';
import 'package:provider/provider.dart';

// Dilogo para Comprador
void dialogoCambiarContrasenaComprador(BuildContext context, Comprador comprador) {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePasswordNueva = true;
  bool _obscurePasswordRepite = true;
  String _contrasenaNueva = "";
  String _contrasenaRepite = "";
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Cambiar contrasea",
                    style: AppEstiloTexto.textoPrincipal,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: AppEstiloBotones.botonSecundario,
                ),
              ],
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Informacin adicional
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColores.colorPrimario.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColores.colorPrimario, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Ingresa tu nueva contrasea",
                            style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nueva contrasea
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: _obscurePasswordNueva,
                      decoration: InputDecoration(
                        labelText: "Nueva contrasea",
                        labelStyle: AppEstiloTexto.textoPrincipal,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePasswordNueva = !_obscurePasswordNueva;
                            });
                          },
                          icon: Icon(
                            _obscurePasswordNueva
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          color: AppColores.colorSecundario,
                        ),
                      ),
                      validator: (value) => Validators.validateEmpty(value),
                      onChanged: (value) => _contrasenaNueva = value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Repetir nueva contrasea
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: _obscurePasswordRepite,
                      decoration: InputDecoration(
                        labelText: "Repita la nueva contrasea",
                        labelStyle: AppEstiloTexto.textoPrincipal,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePasswordRepite = !_obscurePasswordRepite;
                            });
                          },
                          icon: Icon(
                            _obscurePasswordRepite
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          color: AppColores.colorSecundario,
                        ),
                      ),
                      validator: (value) =>
                          Validators.validatePassword(value, _contrasenaNueva),
                      onChanged: (value) => _contrasenaRepite = value,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: () async {
                  final isFormValid = _formKey.currentState!.validate();
                  if (isFormValid) {
                    // Mostrar indicador de carga
                    setState(() {});
                    
                    try {
                      final compradorProvider = Provider.of<Compradorprovider>(
                        context,
                        listen: false,
                      );
                      
                      // Actualizar la contrasea
                      await compradorProvider.actualizarComprador(
                        comprador.id,
                        comprador.correoElectronico,
                        comprador.nombre,
                        comprador.direccion,
                        comprador.imagen,
                        _contrasenaNueva, // Nueva contrasea
                      );
                      
                      if (context.mounted) {
                        Navigator.pop(context); // Cerrar dilogo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Contrasea cambiada correctamente"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error al cambiar la contrasea: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text("Cambiar"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: AppEstiloBotones.botonSecundario,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
            ],
            actionsPadding: const EdgeInsets.all(16),
          );
        },
      );
    },
  );
}
