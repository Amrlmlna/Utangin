import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../models/user.dart';
import '../models/agreement.dart';
import '../models/notification.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String _baseUrl = 'https://utangin-backend.onrender.com'; // Default fallback
  String? _token;

  Future<void> init() async {
    try {
      // Load environment variables from assets
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // If loading from assets fails, continue with default values
      // Could log to a proper logging system in production
    }

    // Get the base URL from environment, with fallback
    String? envBaseUrl = dotenv.env['API_BASE_URL'];
    if (envBaseUrl != null && envBaseUrl.isNotEmpty) {
      _baseUrl = envBaseUrl;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Authentication methods
  Future register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Check if the response contains a token (auto-confirmed) or just a message (requires confirmation)
      if (data.containsKey('token')) {
        // Email was auto-confirmed, user can be logged in immediately
        await _saveToken(data['token']);
        return LoginResponse.fromJson(data);
      } else if (data.containsKey('message')) {
        // Email confirmation required, return the message
        return {'message': data['message']};
      } else {
        // Unexpected response format
        throw Exception('Unexpected response format from server');
      }
    } else {
      // Try to get error details from response
      String errorMessage = 'Registration failed. Please try again.';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
      } catch (e) {
        // If response is not JSON, just use the status code
        errorMessage = 'Registration failed with status code: ${response.statusCode}';
      }
      throw Exception(errorMessage);
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return LoginResponse.fromJson(data);
      } catch (e) {
        throw Exception('Failed to parse login response: $e');
      }
    } else {
      // Try to get error details from response
      String errorMessage = 'Login failed. Please check your credentials and try again.';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
      } catch (e) {
        // If response is not JSON, just use the status code
        errorMessage = 'Login failed with status code: ${response.statusCode}';
      }
      throw Exception(errorMessage);
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
      throw Exception('Failed to get profile. Please try again later.');
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
      throw Exception('Failed to get users. Please try again later.');
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
      throw Exception('Failed to get user. Please try again later.');
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
      throw Exception('Failed to update user. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to create agreement. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to get agreements. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to get agreement. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to get user agreements. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to update agreement. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to confirm agreement. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to mark agreement as paid. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to get notifications. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to mark notification as read. Please try again later.');
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
      // Don't expose response body for security
      throw Exception('Failed to generate QR code. Please try again later.');
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