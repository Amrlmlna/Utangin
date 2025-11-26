import 'package:flutter/foundation.dart';
import 'auth_provider.dart';
import 'agreement_provider.dart';
import 'api_service.dart';

class MainProvider with ChangeNotifier {
  final AuthProvider _authProvider = AuthProvider();
  final AgreementProvider _agreementProvider = AgreementProvider();

  AuthProvider get auth => _authProvider;
  AgreementProvider get agreement => _agreementProvider;

  bool get isAuthenticated => _authProvider.isAuthenticated;
  bool get isLoading => _authProvider.isLoading || _agreementProvider.isLoading;

  Future<void> init() async {
    // Initialize the API service to load environment variables
    final apiService = ApiService(); // This will now return the singleton instance
    await apiService.init();

    // Only try to fetch user profile if token exists
    if (_authProvider.user != null) {
      try {
        await _authProvider.fetchUserProfile();
        if (_authProvider.user != null) {
          await _agreementProvider.fetchAgreements(_authProvider.user!.id);
        }
      } catch (e) {
        // If API call fails, continue without user data
        // Could log to a proper logging system in production
      }
    }
  }

  @override
  void dispose() {
    _authProvider.dispose();
    _agreementProvider.dispose();
    super.dispose();
  }
}