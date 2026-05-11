import 'package:flutter/material.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_colores.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_texto.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_estilo_botones.dart';

class CalculadoraBeneficiosView extends StatefulWidget {
  const CalculadoraBeneficiosView({super.key});

  @override
  State<CalculadoraBeneficiosView> createState() => _CalculadoraBeneficiosViewState();
}

class _CalculadoraBeneficiosViewState extends State<CalculadoraBeneficiosView> {
  final _formKey = GlobalKey<FormState>();
  
  final _horasController = TextEditingController();
  final _materialesController = TextEditingController();
  final _precioVentaController = TextEditingController();
  
  double _comision = 0;
  double _beneficioNeto = 0;
  double _costoPorHora = 0;
  
  bool _mostrarResultados = false;
  
  final double _valorHora = 20.0;
  final double _comisionPorcentaje = 0.10;

  @override
  void dispose() {
    _horasController.dispose();
    _materialesController.dispose();
    _precioVentaController.dispose();
    super.dispose();
  }

  void _calcularBeneficio() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final horas = double.tryParse(_horasController.text) ?? 0;
    final materiales = double.tryParse(_materialesController.text) ?? 0;
    final precioVenta = double.tryParse(_precioVentaController.text) ?? 0;
    
    final costoTotal = (horas * _valorHora) + materiales;
    _comision = precioVenta * _comisionPorcentaje;
    _beneficioNeto = precioVenta - costoTotal - _comision;
    _costoPorHora = horas > 0 ? _beneficioNeto / horas : 0;
    
    setState(() {
      _mostrarResultados = true;
    });
  }
  
  void _calcularPrecioSugerido() {
    final horas = double.tryParse(_horasController.text) ?? 0;
    final materiales = double.tryParse(_materialesController.text) ?? 0;
    
    final costoTotal = (horas * _valorHora) + materiales;
    final precioSugerido = costoTotal / (1 - _comisionPorcentaje);
    final precioFormateado = double.parse(precioSugerido.toStringAsFixed(2));
    
    // ✅ Solo mostrar mensaje, NO modificar el campo de precio de venta
    _mostrarDialogoPrecioSugerido(precioFormateado);
  }

  void _mostrarDialogoPrecioSugerido(double precio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Precio Sugerido",
          style: AppEstiloTexto.textoPrincipal,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_up,
              size: 50,
              color: AppColores.colorPrimario,
            ),
            const SizedBox(height: 16),
            Text(
              "${precio.toStringAsFixed(2)} €",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColores.colorSecundario,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Precio mínimo recomendado para cubrir",
              style: AppEstiloTexto.textoSecundario,
              textAlign: TextAlign.center,
            ),
            Text(
              "costos + comisión de la plataforma (10%)",
              style: AppEstiloTexto.textoSecundario,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColores.colorPrimario,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Aceptar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _limpiarCampos() {
    _horasController.clear();
    _materialesController.clear();
    _precioVentaController.clear();
    setState(() {
      _mostrarResultados = false;
      _comision = 0;
      _beneficioNeto = 0;
      _costoPorHora = 0;
    });
  }

  String _formatearMoneda(double valor) {
    return "${valor.toStringAsFixed(2)} €";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColores.colorPrimario,
        title: Text(
          "Calculadora de Beneficios",
          style: AppEstiloTexto.encabezado,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _limpiarCampos,
            tooltip: "Limpiar campos",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta informativa
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColores.colorPrimario.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColores.colorPrimario.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColores.colorPrimario, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "¿Cómo funciona?",
                            style: AppEstiloTexto.textoPrincipal.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "La plataforma retiene un 10% del precio de venta. "
                            "Te ayudamos a calcular el precio ideal para que obtengas el beneficio deseado.",
                            style: AppEstiloTexto.textoSecundario.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Campo: Tiempo invertido
              TextFormField(
                controller: _horasController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Tiempo invertido (horas)",
                  labelStyle: AppEstiloTexto.textoPrincipal,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.access_time),
                  suffixText: "horas",
                  helperText: "Valor por hora: 20€",
                  helperStyle: AppEstiloTexto.textoSecundario,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduce las horas invertidas";
                  }
                  if (double.tryParse(value) == null) {
                    return "Introduce un número válido";
                  }
                  return null;
                },
                onChanged: (_) => setState(() => _mostrarResultados = false),
              ),
              
              const SizedBox(height: 16),
              
              // Campo: Costo de materiales
              TextFormField(
                controller: _materialesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Costo de materiales (€)",
                  labelStyle: AppEstiloTexto.textoPrincipal,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.brush),
                  suffixText: "€",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduce el costo de materiales";
                  }
                  if (double.tryParse(value) == null) {
                    return "Introduce un número válido";
                  }
                  return null;
                },
                onChanged: (_) => setState(() => _mostrarResultados = false),
              ),
              
              const SizedBox(height: 16),
              
              // Campo: Precio de venta
              TextFormField(
                controller: _precioVentaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Precio de venta (€)",
                  labelStyle: AppEstiloTexto.textoPrincipal,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.euro),
                  suffixText: "€",
                  helperText: "La plataforma retiene un 10% de esta cantidad",
                  helperStyle: AppEstiloTexto.textoSecundario,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduce el precio de venta";
                  }
                  if (double.tryParse(value) == null) {
                    return "Introduce un número válido";
                  }
                  return null;
                },
                onChanged: (_) => setState(() => _mostrarResultados = false),
              ),
              
              const SizedBox(height: 16),
              
              // Botón para calcular precio sugerido
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _calcularPrecioSugerido,
                  icon: const Icon(Icons.trending_up),
                  label: Text(
                    "Calcular precio sugerido (mínimo recomendado)",
                    style: AppEstiloTexto.textoPrincipal,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColores.colorPrimario,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botón Calcular beneficio
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColores.colorSecundario,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _calcularBeneficio,
                  child: Text(
                    "Calcular beneficio",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColores.colorTextoPrincipal,
                    ),
                  ),
                ),
              ),
              
              if (_mostrarResultados) ...[
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 16),
                
                // Título de resultados
                Center(
                  child: Text(
                    "Resultados",
                    style: AppEstiloTexto.textoPrincipal.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColores.colorPrimario,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tarjeta de resultados
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColores.colorFondo,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColores.colorPrimario.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Comisión (10%)
                      _buildResultadoItem(
                        titulo: "Comisión (10%)",
                        valor: _formatearMoneda(_comision),
                        color: Colors.orange,
                        icon: Icons.percent,
                      ),
                      
                      const Divider(height: 24),
                      
                      // Beneficio neto
                      _buildResultadoItem(
                        titulo: "Beneficio neto para el artista",
                        valor: _formatearMoneda(_beneficioNeto),
                        color: _beneficioNeto >= 0 ? Colors.green : Colors.red,
                        icon: Icons.person,
                        esGrande: true,
                      ),
                      
                      const Divider(height: 24),
                      
                      // Costo por hora
                      _buildResultadoItem(
                        titulo: "Ganancia por hora de trabajo",
                        valor: _formatearMoneda(_costoPorHora),
                        color: Colors.blue,
                        icon: Icons.timer,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Mensaje adicional si el beneficio es negativo
                if (_beneficioNeto < 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Estás perdiendo dinero con este precio. "
                            "Usa el botón 'Calcular precio sugerido' para obtener el precio mínimo recomendado.",
                            style: AppEstiloTexto.textoSecundario.copyWith(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Mensaje si la ganancia por hora es baja
                if (_costoPorHora < _valorHora && _costoPorHora > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Ganas menos de 20€ por hora. Considera ajustar el precio para mejorar tu ganancia.",
                            style: AppEstiloTexto.textoSecundario.copyWith(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildResultadoItem({
    required String titulo,
    required String valor,
    required Color color,
    required IconData icon,
    bool esGrande = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: esGrande ? 28 : 24),
            const SizedBox(width: 12),
            Text(
              titulo,
              style: esGrande
                  ? AppEstiloTexto.textoPrincipal.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  : AppEstiloTexto.textoPrincipal,
            ),
          ],
        ),
        Text(
          valor,
          style: esGrande
              ? AppEstiloTexto.textoPrincipal.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                )
              : AppEstiloTexto.textoPrincipal.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
        ),
      ],
    );
  }
}