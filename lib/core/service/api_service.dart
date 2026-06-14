import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constant/app_constant.dart';

class ApiService {
  static ApiService? _instance;
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    // Attach token to every request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  static ApiService get instance => _instance ??= ApiService._();

  // ── Auth ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> sendOtp(String phone, {String role = 'rider'}) async {
    final res = await _dio.post('/auth/send-otp', data: {'phone': phone, 'role': role});
    return res.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final res = await _dio.post('/auth/verify-otp', data: {'phone': phone, 'otp': otp});
    return res.data;
  }

  Future<void> saveFcmToken(String token) async {
    await _dio.post('/auth/fcm-token', data: {'fcm_token': token});
  }

 

  // ── Payments ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> initializePayment({
    required String rideId,
    required String email,
    String method = 'card',
  }) async {
    final res = await _dio.post('/payments/initialize', data: {
      'ride_id': rideId,
      'email': email,
      'method': method,
    });
    return res.data;
  }
}