import 'user.dart';

class AuthToken {
  final String token;
  final DateTime expiry;

  AuthToken({
    required this.token,
    required this.expiry,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['token'] ?? '',
      expiry: DateTime.parse(json['expiry'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiry': expiry.toIso8601String(),
    };
  }
}

class LoginResponse {
  final User user;
  final String token;

  LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String ktpNumber;
  final String address;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.ktpNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'ktp_number': ktpNumber,
      'address': address,
    };
  }
}