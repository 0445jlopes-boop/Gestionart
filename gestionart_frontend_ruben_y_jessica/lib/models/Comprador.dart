class Comprador { //Clase comprador
  String correoElectronico;
  String nombre;
  String? imagen;
  String contrasena;
  String direccion;

  Comprador({
    required this.correoElectronico,
    required this.nombre,
    this.imagen,
    required this.contrasena,
    required this.direccion,
  });


  String getCorreoElectronico() {
    return correoElectronico;
  }

  String getNombre() {
    return nombre;
  }

  String? getImagen() {
    return imagen;
  }

  String getContrasena() {
    return contrasena;
  }

  String getDireccion() {
    return direccion;
  }
  void setCorreoElectronico(String _correoElectronico) {
    this.correoElectronico = _correoElectronico;
  }

  void setNombre(String _nombre) {
    this.nombre = _nombre;
  }

  void setImagen(String? _imagen) {
    this.imagen = _imagen;
  }

  void setContrasena(String _contrasena) {
    this.contrasena = _contrasena;
  }

  void setDireccion(String _direccion) {
    this.direccion = _direccion;
  }

  void actualizar(Comprador otro) {
    correoElectronico = otro.correoElectronico;
    nombre = otro.nombre;
    imagen = otro.imagen;
    contrasena = otro.contrasena;
    direccion = otro.direccion;
  }
}
