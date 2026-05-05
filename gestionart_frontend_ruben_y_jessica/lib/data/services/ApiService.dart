import 'package:dio/dio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_constantes.dart';

class ApiService {
  static String? _authToken;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstantes.API_BASE_URL,
    headers: {
      "Content-Type": "application/json",
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) => true,
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Si hay un token guardado, lo incluye
        if (_authToken != null) {
          options.headers["Authorization"] = "Bearer $_authToken";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("Error en la API: ${e.response?.statusCode}");
        print("URL: ${e.requestOptions.uri}");
        print("Mensaje: ${e.message}");
        return handler.next(e);
      },
    ));
  }

  // Método para guardar el token después del login
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // Método para limpiar el token al logout
  static void clearAuthToken() {
    _authToken = null;
  }

  Dio get dio => _dio;
}