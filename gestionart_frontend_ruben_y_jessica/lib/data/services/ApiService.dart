import 'package:dio/dio.dart';
import 'package:gestionart_frontend_ruben_y_jessica/config/common/resources/app_constantes.dart';

class ApiService {
  static String? _authToken;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstantes.API_BASE_URL,
    headers: {
      "Content-Type": "application/json",
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
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
        return handler.next(e);
      },
    ));
  }

  // Mtodo para guardar el token despus del login
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // Mtodo para limpiar el token al logout
  static void clearAuthToken() {
    _authToken = null;
  }

  Dio get dio => _dio;
}