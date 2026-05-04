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
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //Número de columnas y espacio entre elementos
          mainAxisExtent: 100, //Tamaño fijo de las celdas
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1, //Para que se vea como un cuadrado
        ),
        itemCount: Categoria.values.length,
        itemBuilder: (context, index) {
          // Similar a un For each para crear los contenedores
          final categoria =Categoria.values[index]; //Recogemos la categoria
          return GestureDetector(
            //Widget que hace que el widget de su interior detecte interacción por parte del usuario mediante el raton, en este caso se usa onTap()
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => categorias_view(categoria: categoria, comprador: widget.comprador)));
            },
            child: Container(
              decoration: BoxDecoration(
                // Formato de los contenedores
                color: AppColores.colorFondo,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColores.colorPrimario,
                    blurRadius: 4,
                  ), //Color de la sombra y forma redondeada
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CategoriaIcono.obtenerIcono(categoria),
                    color: AppColores.colorSecundario,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categoria.toString(),
                    textAlign: TextAlign.center,
                    style: AppEstiloTexto.textoPrincipal,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
