class Notification {
  final String id;
  final String userId;
  final String? agreementId;
  final NotificationType type;
  final String title;
  final String message;
  final bool readStatus;
  final DeliveryMethod deliveryMethod;
  final DateTime? scheduledTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notification({
    required this.id,
    required this.userId,
    this.agreementId,
    required this.type,
    required this.title,
    required this.message,
    this.readStatus = false,
    required this.deliveryMethod,
    this.scheduledTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      agreementId: json['agreement_id'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.reminder,
      ),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      readStatus: json['read_status'] ?? false,
      deliveryMethod: DeliveryMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['delivery_method'],
        orElse: () => DeliveryMethod.push,
      ),
      scheduledTime: json['scheduled_time'] != null ? DateTime.parse(json['scheduled_time']) : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'agreement_id': agreementId,
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'read_status': readStatus,
      'delivery_method': deliveryMethod.toString().split('.').last,
      'scheduled_time': scheduledTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum NotificationType { reminder, confirmation, payment, escalation, summary }
enum DeliveryMethod { push, email, whatsapp }