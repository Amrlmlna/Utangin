import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/main_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart'; // We'll create this next

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
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
