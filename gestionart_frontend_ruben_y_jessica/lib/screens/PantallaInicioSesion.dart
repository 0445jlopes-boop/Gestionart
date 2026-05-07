import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/utils/validators/Validators.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Vendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/AuthProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/CompradorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/providers/VendedorProvider.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/PantallaInicioComprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Vendedor/PantallaInicioVendedor.dart';
import 'package:gestionart_frontend_ruben_y_jessica/widgets/dialogs/dialogoRegistro.dart';
import 'package:provider/provider.dart';

class Pantallainiciosesion extends StatefulWidget {
  const Pantallainiciosesion({super.key});

  @override
  State<Pantallainiciosesion> createState() => _PantallainiciosesionState();
}

class _PantallainiciosesionState extends State<Pantallainiciosesion> {
  //DECLARACIÓN DE VARIABLES PARA EL FORMULARIO DE INICIO DE SESIÓN
  String _correo = "";
  String _contrasena = "";
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _validarUsuario() async {
    final isFormValid = _formKey.currentState!.validate();
    final authProvider = context.read<Authprovider>();
    final compradorProvider = context.read<Compradorprovider>();
    final vendedorProvider = context.read<Vendedorprovider>();
    
    if (!isFormValid) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await authProvider.login(_correo, _contrasena);
      
      if (token != null) {
        // Primero intentar obtener como comprador
        Comprador? compradorLogeado = await compradorProvider.obtenerCompradorPorCorreo(_correo);
        
        if (compradorLogeado != null) {
          // Es COMPRADOR
          if (mounted) {
            _correoController.clear();
            _contrasenaController.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Pantallainiciocomprador(
                  comprador: compradorLogeado,
                ),
              ),
            );
          }
        } else {
          // Intentar obtener como vendedor
          Vendedor? vendedorLogeado = await vendedorProvider.obtenerVendedorPorCorreo(_correo);
          
          if (vendedorLogeado != null) {
            // Es VENDEDOR
            if (mounted) {
              _correoController.clear();
              _contrasenaController.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaInicioVendedor(
                    vendedor: vendedorLogeado,
                  ),
                ),
              );
            }
          } else {
            // No se encontró usuario
            if (mounted) {
              const snackBar = SnackBar(
                content: Text('Usuario no encontrado'),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        }
      } else {
        if (mounted) {
          const snackBar = SnackBar(
            content: Text('Correo o contraseña incorrectos'),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text("GESTIONART", style: AppEstiloTexto.encabezado),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/logo.jpg'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: _correoController,
                                decoration: const InputDecoration(
                                  labelText: "Correo electrónico",
                                  labelStyle: AppEstiloTexto.textoPrincipal,
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => Validators.validateEmail(value),
                                onChanged: (value) => _correo = value,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: _contrasenaController,
                                decoration: InputDecoration(
                                  labelText: "Contraseña",
                                  labelStyle: AppEstiloTexto.textoPrincipal,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
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
                                obscureText: _obscurePassword,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 400,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implementar recuperación de contraseña
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Funcionalidad en desarrollo'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                },
                                child: Text(
                                  "¿Olvidaste tu contraseña?",
                                  style: AppEstiloTexto.textoSecundario,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 400,
                              child: ElevatedButton(
                                style: AppEstiloBotones.botonPrincipal,
                                onPressed: _validarUsuario,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text("Iniciar Sesión"),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 400,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColores.colorPrimario),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  dialogoRegistro(context);
                                },
                                child: Text(
                                  "Registrarse",
                                  style: AppEstiloTexto.textoPrincipal.copyWith(
                                    color: AppColores.colorPrimario,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
