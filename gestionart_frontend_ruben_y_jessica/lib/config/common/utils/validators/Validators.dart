import 'package:gestionart_frontend_ruben_y_jessica/models/Comprador.dart';
import 'package:gestionart_frontend_ruben_y_jessica/services/LogicaComprador.dart';

class Validators { //Validaciones generales
  static String? validateEmpty(String? value){ //Valida que no esté vacio
    if(value == null || value.isEmpty){
      return 'Campo obligatorio';
    }
    return null;
  }
  static String? validatePassword(String? value1, String? value2) { // Valida que las contraseñas en los regisros coincidan
  if (value1 == null || value1.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value1 != value2) {
    return 'Las contraseñas no coinciden';
  }

  return null;
}
  static String? validateName(String? value) { // Valida que el campo nombre no esté vacío y que tenga 25 carácteres máximo
    if (value == null || value.trim().isEmpty) {
      return "El nombre es obligatorio";
    }
    if (value.length > 25) {
      return "El nombre es demadiado largo";
    }
    return null;
  }
  static String? validateEmail(String? value) { // Valida que el correo electronico no esté vacio y que cumpla el regex del correo
    if (value == null || value.trim().isEmpty) {
      return "El correo es obligatorio";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Email
    if (!emailRegex.hasMatch(value)) {
      return "Correo electrónico inválido (ejemplo@ejemplo.com)";
    }
    return null;
  }
  static String? validateDireccion(String? value) { // Valida que la direccion no esté vacía y le aplica un formato
    if (value == null || value.trim().isEmpty) {
      return "La dirección es obligatoria";
    }

    //Ciudad-calle-número-piso-puerta-códigoPostal

    final addressRegex = RegExp(
      r'^[A-Za-zÁÉÍÓÚáéíóúñÑ\s]+-'  // Ciudad
      r'[A-Za-zÁÉÍÓÚáéíóúñÑ\s]+-'    // Calle
      r'\d+-'                        // Número
      r'\d+-'                        // Piso
      r'[A-Za-z0-9]+-'               // Puerta
      r'\d{5}$'                      // Código Postal (5 dígitos)
    );

    if (!addressRegex.hasMatch(value)) {
      return "Formato inválido. Use: Ciudad-Calle-Numero-Piso-Puerta-CodigoPostal";
    }

    return null;
  }

  // Validador comprador
  static String? validatePasswordExists(Comprador comprador, String contrasena){
    if(comprador.contrasena != contrasena){
      return "La contraseña introducida no es la original";
    }
    return null;
  }

}