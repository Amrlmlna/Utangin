class User {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? ktpNumber;
  final bool? ktpVerified;
  final bool? selfieVerified;
  final String? profilePicture;
  final String? address;
  final List<String>? emergencyContacts;
  final int reputationScore;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.ktpNumber,
    this.ktpVerified,
    this.selfieVerified,
    this.profilePicture,
    this.address,
    this.emergencyContacts,
    this.reputationScore = 0,
    this.balance = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      name: json['name'] ?? '',
      ktpNumber: json['ktp_number'],
      ktpVerified: json['ktp_verified'],
      selfieVerified: json['selfie_verified'],
      profilePicture: json['profile_picture'],
      address: json['address'],
      emergencyContacts: json['emergency_contacts'] != null 
          ? List<String>.from(json['emergency_contacts']) 
          : null,
      reputationScore: json['reputation_score']?.toInt() ?? 0,
      balance: json['balance']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'ktp_number': ktpNumber,
      'ktp_verified': ktpVerified,
      'selfie_verified': selfieVerified,
      'profile_picture': profilePicture,
      'address': address,
      'emergency_contacts': emergencyContacts,
      'reputation_score': reputationScore,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}