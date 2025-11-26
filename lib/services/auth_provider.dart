import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  Future register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String ktpNumber,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      final result = await apiService.register(
        RegisterRequest(
          email: email,
          password: password,
          name: name,
          phone: phone,
          ktpNumber: ktpNumber,
          address: address,
        ),
      );

      _isLoading = false;

      // Return the result - could be LoginResponse or message map
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow; // Re-throw so caller can handle the error
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      final response = await apiService.login(email, password);
      _user = response.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final apiService = ApiService();
    await apiService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    try {
      final apiService = ApiService();
      _user = await apiService.getProfile();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    if (_user == null) return false;

    try {
      final apiService = ApiService();
      _user = await apiService.updateUser(_user!.id, userData);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}