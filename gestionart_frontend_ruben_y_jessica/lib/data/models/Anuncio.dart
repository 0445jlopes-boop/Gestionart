class Anuncio {
  final int id;
  final String titulo;
  final String categoria;
  final double precio;
  final String imagen;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int idVendedor;
  final bool activo;

  Anuncio({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.precio,
    required this.imagen,
    required this.fechaInicio,
    required this.fechaFin,
    required this.idVendedor,
    required this.activo,
  });

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    // Función auxiliar para parsear fechas seguramente
    DateTime parseFecha(String? fecha) {
      if (fecha == null || fecha.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(fecha);
      } catch (e) {
        return DateTime.now(); // Fallback seguro
      }
    }

    return Anuncio(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      categoria: json['categoria'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      imagen: json['imagen'] ?? '',
      fechaInicio: parseFecha(json['fechaInicio']),
      fechaFin: parseFecha(json['fechaFin']),
      idVendedor: json['idVendedor'] ?? 0,
      activo: json['activo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'precio': precio,
      'imagen': imagen,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'idVendedor': idVendedor,
      'activo': activo,
    };
  }
}
