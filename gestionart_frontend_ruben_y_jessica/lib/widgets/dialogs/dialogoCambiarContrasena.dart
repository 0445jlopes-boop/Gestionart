import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';

void dialogoCambiarContrasena(BuildContext context, Comprador comprador) {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePasswordActual = true;
  bool _obscurePasswordNueva = true;
  bool _obscurePasswordRepite = true;
  String _contrasenaActual = "";
  String _contrasenaNueva = "";
  String _contrasenaRepite = "";
  showDialog(
    context: context,
    barrierDismissible:
        false, //impide que el usuario cierre el dialogo tocando fuera de este, así tiene más sentido usar un boton para cerrar el dialogo.
    builder: (context) {
      return StatefulBuilder(
        //Widget que permite hacer setState en AlertDialog
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
                  icon: const Icon(Icons.close), //Icono para cerrar el dialogo
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
                children: [
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: _obscurePasswordActual,
                      decoration: InputDecoration(
                        labelText: "Contraseña actual",
                        labelStyle: AppEstiloTexto.textoPrincipal,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          //Iono del ojo que permite mostrar y ocultar contraseña al presoanrlo
                          onPressed: () {
                            setState(() {
                              _obscurePasswordActual = !_obscurePasswordActual;
                            });
                          },
                          icon: Icon(
                            _obscurePasswordActual
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          color: AppColores.colorSecundario,
                        ),
                      ),
                      validator: (value) =>
                          Validators.validatePasswordExists(comprador, value!),
                      onChanged: (value) => _contrasenaActual = value,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      obscureText: _obscurePasswordNueva,
                      decoration: InputDecoration(
                        labelText: "Nueva contraseña",
                        labelStyle: AppEstiloTexto.textoPrincipal,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          //Iono del ojo que permite mostrar y ocultar contraseña al presoanrlo
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
                  SizedBox(height: 20),
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
                onPressed: () {
                  final isFormValid = _formKey.currentState!.validate();
                  if (isFormValid) {
                    comprador.contrasena = _contrasenaNueva;
                    Navigator.pop(context);
                  }
                },
                child: Text("Cambiar"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Canelar"),
              ),
            ],
          );
        },
      );
    },
  );
}
