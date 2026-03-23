import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://claimflow-africa-be.onrender.com';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth',
        data: {
          'email': email,
          'password': password,
        },
      );
      print(response.data);
      final token = response.data['token'];
      if (token != null) {
        await saveToken(token);
      }
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      print('ERROR RESPONSE: ${e.response?.data}');
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ?? 'Something went wrong';
      } else if (data is List) {
        return data.first?.toString() ?? 'Something went wrong';
      } else {
        return data?.toString() ?? 'Something went wrong';
      }
    }
    return 'No internet connection or server unreachable';
  }
}