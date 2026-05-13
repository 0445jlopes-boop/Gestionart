import 'package:gestionart_frontend_ruben_y_jessica/data/models/Comprador.dart';

class Validators { //Validaciones generales
  static String? validateEmpty(String? value){ //Valida que no est vacio
    if(value == null || value.isEmpty){
      return 'Campo obligatorio';
    }
    return null;
  }
  static String? validatePassword(String? value1, String? value2) { // Valida que las contraseas en los regisros coincidan
  if (Validators.validateEmpty(value1)!=null) {
    return 'La contrasea es obligatoria';
  }else if (value1 != value2) {
    return 'Las contraseas no coinciden';
  }
  return null;
}
  static String? validateName(String? value) { // Valida que el campo nombre no est vaco y que tenga 25 carcteres mximo
    if (value == null || value.trim().isEmpty) {
      return "El nombre es obligatorio";
    }
    if (value.length > 25) {
      return "El nombre es demadiado largo";
    }
    return null;
  }
  static String? validateEmail(String? value) { // Valida que el correo electronico no est vacio y que cumpla el regex del correo
    if (value == null || value.trim().isEmpty) {
      return "El correo es obligatorio";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Email
    if (!emailRegex.hasMatch(value)) {
      return "Correo electrnico invlido (ejemplo@ejemplo.com)";
    }
    return null;
  }
  static String? validateDireccion(String? value) { // Valida que la direccion no est vaca y le aplica un formato
    if (value == null || value.trim().isEmpty) {
      return "La direccin es obligatoria";
    }

    //Ciudad-calle-nmero-piso-puerta-cdigoPostal

    final addressRegex = RegExp(
      r'^[A-Za-z\s]+-'  // Ciudad
      r'[A-Za-z\s]+-'    // Calle
      r'\d+-'                        // Nmero
      r'\d+-'                        // Piso
      r'[A-Za-z0-9]+-'               // Puerta
      r'\d{5}$'                      // Cdigo Postal (5 dgitos)
    );

    if (!addressRegex.hasMatch(value)) {
      return "Formato invlido. Use: Ciudad-Calle-Numero-Piso-Puerta-CodigoPostal";
    }

    return null;
  }

  // Validador comprador
  static String? validatePasswordExists(Comprador comprador, String contrasena){
    if(Validators.validateEmpty(contrasena)!=null){
      return "Campo obligatorio";
    }else if(comprador.contrasena != contrasena){
      return "La contrasea no es la existente";
    }
    return null;
  }

}