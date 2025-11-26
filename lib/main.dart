import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/main_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_agreement_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/repayment_tracking_screen.dart';

void main() {
  runApp(const UtanginApp());
}

class UtanginApp extends StatelessWidget {
  const UtanginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: Consumer<MainProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'UTANGIN - Platform Pinjaman Pribadi',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/create-agreement': (context) => const CreateAgreementScreen(),
              '/qr-scanner': (context) => const QRScannerScreen(),
              '/repayment-tracking': (context) => const RepaymentTrackingScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
