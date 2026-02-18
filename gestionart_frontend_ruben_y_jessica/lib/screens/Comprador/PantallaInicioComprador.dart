import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/Views/categorias_view.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Comprador/Views/perfil_view.dart';

class Pantallainiciocomprador extends StatefulWidget {
  final dynamic comprador;

  const Pantallainiciocomprador({super.key, required this.comprador});

  @override
  State<Pantallainiciocomprador> createState() => _PantallainiciocompradorState();
}

class _PantallainiciocompradorState extends State<Pantallainiciocomprador> {
  late final List <Widget> _views = [categorias_view(), Container(),Container(),perfil_view(comprador: widget.comprador)];
  int _currentIndex = 0;
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
        child: _views[_currentIndex] 
      ),
      // Ha requerido investigación
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Actualizar estado y cambiar de view
          });
        },
        //Menú de navegación inferior para el comprador
        selectedItemColor: AppColores.colorPrimario,
        unselectedItemColor: AppColores.colorDesactivado,
        showUnselectedLabels:
            true, //Asi muestro los labels de losbotones no seleccionados
        selectedLabelStyle: AppEstiloTexto
            .textoPrincipal, // Con esto y el de abajo forzamos que se vea el label (El texto que identifica a los iconos ya sea que esté seleccionado o no)
        unselectedLabelStyle: AppEstiloTexto.textoSecundario,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
