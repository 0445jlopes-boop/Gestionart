import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/data/Categorias_data.dart';

class Pantallainiciocomprador extends StatefulWidget {
  final dynamic comprador;

  const Pantallainiciocomprador({super.key, required this.comprador});

  @override
  State<Pantallainiciocomprador> createState() => _PantallainiciocompradorState();
}

class _PantallainiciocompradorState extends State<Pantallainiciocomprador> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text(
            "¡ BIENVENID@ A GESTIONART !",
            style: AppEstiloTexto.encabezado,
          ),
        ),
      ),
      body: Container(
        alignment: AlignmentGeometry.center,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //Número de columnas y espacio entre elementos
                  mainAxisExtent: 100,//Tamaño fijo de las celdas
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1 //Para que se vea como un cuadrado
                ),
                itemCount: CategoriasData.categorias.length,
                itemBuilder: (context, index) {
                  final categoria = CategoriasData.categorias[index];
                  return GestureDetector( //Widget que hace que el widget de su interior detecte interacción por parte del usuario mediante el raton, en este caso se usa onTap()
                    onTap: () {
                      // acción al pulsar
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColores.colorFondo,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: AppColores.colorPrimario, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CategoriasData.obtenerIcono(categoria.nombre),
                            color: AppColores.colorSecundario,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            categoria.nombre,
                            textAlign: TextAlign.center,
                            style: AppEstiloTexto.textoPrincipal,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            BottomNavigationBar(
              selectedItemColor: AppColores.colorPrimario,
              unselectedItemColor: AppColores.colorDesactivado,
              showUnselectedLabels: true, //Asi muestro los labels de losbotones no seleccionados
              selectedLabelStyle: AppEstiloTexto.textoPrincipal,
              unselectedLabelStyle: AppEstiloTexto.textoSecundario,
              items:[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Pedidos',),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
