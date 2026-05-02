import 'package:gestionart_frontend_ruben_y_jessica/data/services/ApiService.dart';

class Striperepository {
  final ApiService _apiService;
  Striperepository(ApiService? apiService) : _apiService = apiService ?? ApiService();  

  Future<bool> crearPago() async {
    try {
      final response = await _apiService.dio.post("http://localhost:8080/api/stripe/crear-pago");
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Error al crear el pago: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear el pago: $e");
    }
  }
}