import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/IconosCategoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/enums/Categoria.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/Views/categorias_view.dart';

class categorias_inicio_view extends StatefulWidget {
  final Comprador comprador;

  const categorias_inicio_view({super.key, required this.comprador});

  @override
  State<categorias_inicio_view> createState() => _categorias_inicio_viewState();
}

class _categorias_inicio_viewState extends State<categorias_inicio_view> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: Categoria.values.length,
      itemBuilder: (context, index) {
        final categoria = Categoria.values[index];
        final nombreCategoria = categoria.toString().split('.').last;
        final icono = CategoriaIcono.obtenerIcono(categoria);
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => categorias_view(
                  categoria: categoria, 
                  comprador: widget.comprador
                ),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColores.colorFondo,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColores.colorPrimario.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColores.colorSecundario.withOpacity(0.2),
                        AppColores.colorPrimario.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icono,
                    color: AppColores.colorSecundario,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    nombreCategoria,
                    textAlign: TextAlign.center,
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
