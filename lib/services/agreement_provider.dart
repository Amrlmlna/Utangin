import 'package:flutter/foundation.dart';
import '../models/agreement.dart';
import '../services/api_service.dart';

class AgreementProvider with ChangeNotifier {
  List<Agreement> _agreements = [];
  bool _isLoading = false;

  List<Agreement> get agreements => _agreements;
  bool get isLoading => _isLoading;

  Future<void> fetchAgreements(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ApiService();
      _agreements = await apiService.getAgreementsByUserId(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Agreement> createAgreement(Agreement agreement) async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ApiService();
      final newAgreement = await apiService.createAgreement(agreement);
      _agreements.add(newAgreement);
      _isLoading = false;
      notifyListeners();
      return newAgreement;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Agreement> confirmAgreement(String agreementId, String party) async {
    try {
      final apiService = ApiService();
      final updatedAgreement = await apiService.confirmAgreement(agreementId, party);

      // Update the agreement in our list
      final index = _agreements.indexWhere((agreement) => agreement.id == agreementId);
      if (index != -1) {
        _agreements[index] = updatedAgreement;
      }

      notifyListeners();
      return updatedAgreement;
    } catch (e) {
      rethrow;
    }
  }

  Future<Agreement> markAgreementAsPaid(String agreementId) async {
    try {
      final apiService = ApiService();
      final updatedAgreement = await apiService.markAgreementAsPaid(agreementId);

      // Update the agreement in our list
      final index = _agreements.indexWhere((agreement) => agreement.id == agreementId);
      if (index != -1) {
        _agreements[index] = updatedAgreement;
      }

      notifyListeners();
      return updatedAgreement;
    } catch (e) {
      rethrow;
    }
  }

  List<Agreement> getAgreementsByStatus(AgreementStatus status) {
    return _agreements.where((agreement) => agreement.status == status).toList();
  }

  List<Agreement> getActiveAgreementsForUser(String userId) {
    return _agreements.where((agreement) {
      return (agreement.lenderId == userId || agreement.borrowerId == userId) &&
          (agreement.status == AgreementStatus.active || agreement.status == AgreementStatus.overdue);
    }).toList();
  }
}