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
      appBar: AppBar( //Appbar con el estilo predeterminado
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
                itemCount: CategoriasData.categorias.length, // Definimos la cantidad de Contenedores que vamos a crear según y para las categorías
                itemBuilder: (context, index) { // Similar a un For each para crear los contenedores
                  final categoria = CategoriasData.categorias[index]; //Recogemos la categoria
                  return GestureDetector( //Widget que hace que el widget de su interior detecte interacción por parte del usuario mediante el raton, en este caso se usa onTap()
                    onTap: () {
                      // acción al pulsar
                    },
                    child: Container(
                      decoration: BoxDecoration( // Formato de los contenedores
                        color: AppColores.colorFondo,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: AppColores.colorPrimario, blurRadius: 4), //Color de la sombra y forma redondeada
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

            BottomNavigationBar( //Menú de navegación inferior para el comprador
              selectedItemColor: AppColores.colorPrimario,
              unselectedItemColor: AppColores.colorDesactivado,
              showUnselectedLabels: true, //Asi muestro los labels de losbotones no seleccionados
              selectedLabelStyle: AppEstiloTexto.textoPrincipal, // Con esto y el de abajo forzamos que se vea el label (El texto que identifica a los iconos ya sea que esté seleccionado o no)
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
