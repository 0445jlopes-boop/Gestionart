
import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/VendedorProvider.dart';
import 'package:provider/provider.dart';

void dialogoCambiarContrasenaVendedor(BuildContext context, Vendedor vendedor) {
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
                    "Cambiar contraseña",
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
                  // Información adicional
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
                            "Ingresa tu nueva contraseña",
                            style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nueva contraseña
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: _obscurePasswordNueva,
                      decoration: InputDecoration(
                        labelText: "Nueva contraseña",
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
                  
                  // Repetir nueva contraseña
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: _obscurePasswordRepite,
                      decoration: InputDecoration(
                        labelText: "Repita la nueva contraseña",
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
                    try {
                      final vendedorProvider = Provider.of<Vendedorprovider>(
                        context,
                        listen: false,
                      );
                      
                      await vendedorProvider.actualizarVendedor(
                        vendedor.id,
                        vendedor.correoElectronico,
                        vendedor.nombre,
                        vendedor.descripcionPerfil,
                        vendedor.imagen,
                        _contrasenaNueva, // Nueva contraseña
                      );
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Contraseña cambiada correctamente"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error al cambiar la contraseña: $e"),
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
