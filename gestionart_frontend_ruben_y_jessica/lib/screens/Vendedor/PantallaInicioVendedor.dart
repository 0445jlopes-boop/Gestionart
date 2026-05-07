import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Vendedor/Views/perfil_vendedor_view.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Vendedor/views/anuncios_view.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Vendedor/views/articulos_view.dart';
import 'package:gestionart_frontend_ruben_y_jessica/screens/Vendedor/views/notificaciones_view.dart';

class PantallaInicioVendedor extends StatefulWidget {
  final dynamic vendedor;

  const PantallaInicioVendedor({super.key, required this.vendedor});

  @override
  State<PantallaInicioVendedor> createState() => _PantallaInicioVendedorState();
}

class _PantallaInicioVendedorState extends State<PantallaInicioVendedor> {
  int _currentIndex = 0;

  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    _views = [
      perfil_vendedor_view(vendedor: widget.vendedor),
      articulos_view(vendedor: widget.vendedor),
      anuncios_view(vendedor: widget.vendedor),
      NotificacionesView(vendedor: widget.vendedor)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        flexibleSpace: Center(
          child: Text(
            "¡BIENVENID@ A GESTIONART!",
            style: AppEstiloTexto.encabezado,
          ),
        ),
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColores.colorPrimario,
        unselectedItemColor: AppColores.colorDesactivado,
        showUnselectedLabels: true,
        selectedLabelStyle: AppEstiloTexto.textoPrincipal,
        unselectedLabelStyle: AppEstiloTexto.textoSecundario,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Mis Obras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Mis Anuncios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          
        ],
      ),
    );
  }
}