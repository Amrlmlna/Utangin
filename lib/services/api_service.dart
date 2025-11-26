import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../models/user.dart';
import '../models/agreement.dart';
import '../models/notification.dart';

class ApiService {
  String _baseUrl = 'http://localhost:3000'; // Default fallback
  String? _token;

  Future<void> init() async {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Get the base URL from environment, with fallback
    String? envBaseUrl = dotenv.env['API_BASE_URL'];
    if (envBaseUrl != null && envBaseUrl.isNotEmpty) {
      _baseUrl = envBaseUrl;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Authentication methods
  Future<LoginResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> logout() async {
    await _clearToken();
  }

  Future<User> getProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/profile'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  // User methods
  Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get users: ${response.body}');
    }
  }

  Future<User> getUserById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$id'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<User> updateUser(String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$id'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  // Agreement methods
  Future<Agreement> createAgreement(Agreement agreement) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/agreements'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(agreement.toJson()),
    );

    if (response.statusCode == 201) {
      return Agreement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create agreement: ${response.body}');
    }
  }

  Future<List<Agreement>> getAllAgreements() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/agreements'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Agreement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get agreements: ${response.body}');
    }
  }

  Future<Agreement> getAgreementById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/agreements/$id'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return Agreement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get agreement: ${response.body}');
    }
  }

  Future<List<Agreement>> getAgreementsByUserId(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/agreements/user/$userId'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Agreement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user agreements: ${response.body}');
    }
  }

  Future<Agreement> updateAgreement(String id, Map<String, dynamic> agreementData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/agreements/$id'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(agreementData),
    );

    if (response.statusCode == 200) {
      return Agreement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update agreement: ${response.body}');
    }
  }

  Future<Agreement> confirmAgreement(String agreementId, String party) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/agreements/$agreementId/confirm/$party'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return Agreement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to confirm agreement: ${response.body}');
    }
  }

  Future<Agreement> markAgreementAsPaid(String agreementId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/agreements/$agreementId/paid'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return Agreement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to mark agreement as paid: ${response.body}');
    }
  }

  // Notification methods
  Future<List<Notification>> getNotificationsByUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/notifications/user/$userId'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Notification.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get notifications: ${response.body}');
    }
  }

  Future<Notification> markNotificationAsRead(String notificationId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/notifications/$notificationId/read'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return Notification.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to mark notification as read: ${response.body}');
    }
  }

  // QR Code methods
  Future<String> generateQRForAgreement(String agreementId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/qr/generate/$agreementId'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['qr_code'] ?? '';
    } else {
      throw Exception('Failed to generate QR code: ${response.body}');
    }
  }

  // Private helper methods
  Future<Map<String, String>> _getAuthHeaders() async {
    if (_token == null) {
      await init();
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  Future<void> _clearToken() async {
    _token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }
}