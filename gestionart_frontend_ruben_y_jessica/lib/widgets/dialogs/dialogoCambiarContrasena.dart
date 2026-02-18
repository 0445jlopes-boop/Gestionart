import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/controllers/ControllerComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';

void dialogoCambiarContrasena(BuildContext context, Comprador comprador) {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  bool _obscurePassword = true;
  String _contrasenaInicio ="";
  String _contrasena ="";
  String _contrasena2 = "";
  showDialog(
    context: context,
    barrierDismissible:false, //impide que el usuario cierre el dialogo tocando fuera de este, así tiene más sentido usar un boton para cerrar el dialogo.
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
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Contraseña actual",
                          labelStyle: AppEstiloTexto.textoPrincipal,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            //Iono del ojo que permite mostrar y ocultar contraseña al presoanrlo
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: AppColores.colorSecundario,
                          ),
                        ),
                        validator: (value) => Validators.validateEmpty(value),
                        onChanged: (value) => _contrasena = value,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        obscureText: _obscurePassword1,
                        decoration: InputDecoration(
                          labelText: "Nueva contraseña",
                          labelStyle: AppEstiloTexto.textoPrincipal,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            //Iono del ojo que permite mostrar y ocultar contraseña al presoanrlo
                            onPressed: () {
                              setState(() {
                                _obscurePassword1 = !_obscurePassword1;
                              });
                            },
                            icon: Icon(
                              _obscurePassword1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: AppColores.colorSecundario,
                          ),
                        ),
                        validator: (value) => Validators.validateEmpty(value), 
                        onChanged: (value) => _contrasena = value,
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        obscureText: _obscurePassword2,
                        decoration: InputDecoration(
                          labelText: "Repita la nueva contraseña",
                          labelStyle: AppEstiloTexto.textoPrincipal,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword2 = !_obscurePassword2;
                              });
                            },
                            icon: Icon(
                              _obscurePassword2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: AppColores.colorSecundario,
                          ),
                        ),
                        validator: (value) =>
                            Validators.validatePassword(value, _contrasena),
                        onChanged: (value) => _contrasena2 = value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: (){
                  Validators.validatePasswordExists(comprador, _contrasena);
                  final isFormValid = _formKey.currentState!.validate();
                  if(isFormValid){
                    Navigator.pop(context);
                  }else{
                    const snackBar = SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  
                }, 
                child: Text("Cambiar")
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                style: AppEstiloBotones.botonPrincipal,
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text("Canelar")
              )
            ],
          );
        },
      );
    },
  );
}
