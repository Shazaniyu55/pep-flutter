import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pep/core/constant/app_constant.dart';
import 'package:pep/core/service/api_service.dart';
import 'package:pep/models/usermodel.dart';


class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;
  bool get isDriver => _user?.isDriver ?? false;

  Future<void> loadFromStorage() async {
    _token = await _storage.read(key: AppConstants.tokenKey);
    final userJson = await _storage.read(key: AppConstants.userKey);
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
    }
    notifyListeners();
  }

  Future<bool> sendOtp(String phone, {String role = 'rider'}) async {
    _setLoading(true);
    try {
      await ApiService.instance.sendOtp(phone, role: role);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _setLoading(true);
    try {
      final res = await ApiService.instance.verifyOtp(phone, otp);
      _token = res['access_token'];
      _user = UserModel.fromJson(res['user']);

      await _storage.write(key: AppConstants.tokenKey, value: _token);
      await _storage.write(key: AppConstants.userKey, value: jsonEncode(res['user']));

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> refreshProfile() async {
 
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _user = null;
    _token = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    _error = null;
    notifyListeners();
  }

  void _setError(String msg) {
    _isLoading = false;
    _error = msg.replaceAll('DioException', '').trim();
    notifyListeners();
  }
}