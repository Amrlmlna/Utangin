class Agreement {
  final String id;
  final String lenderId;
  final String borrowerId;
  final double amount;
  final double interestRate;
  final DateTime dueDate;
  final AgreementStatus status;
  final String? qrCode;
  final bool lenderConfirmed;
  final bool borrowerConfirmed;
  final List<Obligation>? repaymentSchedule;
  final String? escalationSettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  Agreement({
    required this.id,
    required this.lenderId,
    required this.borrowerId,
    required this.amount,
    this.interestRate = 0.0,
    required this.dueDate,
    this.status = AgreementStatus.pending,
    this.qrCode,
    this.lenderConfirmed = false,
    this.borrowerConfirmed = false,
    this.repaymentSchedule,
    this.escalationSettings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      id: json['id'] ?? '',
      lenderId: json['lender_id'] ?? '',
      borrowerId: json['borrower_id'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      interestRate: json['interest_rate']?.toDouble() ?? 0.0,
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      status: AgreementStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AgreementStatus.pending,
      ),
      qrCode: json['qr_code'],
      lenderConfirmed: json['lender_confirmed'] ?? false,
      borrowerConfirmed: json['borrower_confirmed'] ?? false,
      repaymentSchedule: json['repayment_schedule'] != null
          ? List<Obligation>.from(
              json['repayment_schedule'].map((x) => Obligation.fromJson(x)))
          : null,
      escalationSettings: json['escalation_settings'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lender_id': lenderId,
      'borrower_id': borrowerId,
      'amount': amount,
      'interest_rate': interestRate,
      'due_date': dueDate.toIso8601String().split('T')[0],
      'status': status.toString().split('.').last,
      'qr_code': qrCode,
      'lender_confirmed': lenderConfirmed,
      'borrower_confirmed': borrowerConfirmed,
      'repayment_schedule': repaymentSchedule?.map((x) => x.toJson()).toList(),
      'escalation_settings': escalationSettings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum AgreementStatus { pending, active, paid, overdue, disputed }

class Obligation {
  final String id;
  final String agreementId;
  final double amount;
  final DateTime dueDate;
  final ObligationStatus status;
  final DateTime? paymentDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Obligation({
    required this.id,
    required this.agreementId,
    required this.amount,
    required this.dueDate,
    this.status = ObligationStatus.pending,
    this.paymentDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Obligation.fromJson(Map<String, dynamic> json) {
    return Obligation(
      id: json['id'] ?? '',
      agreementId: json['agreement_id'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      status: ObligationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ObligationStatus.pending,
      ),
      paymentDate: json['payment_date'] != null ? DateTime.parse(json['payment_date']) : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agreement_id': agreementId,
      'amount': amount,
      'due_date': dueDate.toIso8601String().split('T')[0],
      'status': status.toString().split('.').last,
      'payment_date': paymentDate?.toIso8601String().split('T')[0],
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum ObligationStatus { pending, paid, overdue }