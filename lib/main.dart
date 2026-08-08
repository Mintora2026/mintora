import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/record_repository.dart';
import 'pages/main_shell.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RecordRepository.instance.loadRecords();

  final preferences = await SharedPreferences.getInstance();

  final hasCompletedOnboarding =
      preferences.getBool('hasCompletedOnboarding') ?? false;

  runApp(
    MintoraApp(
      hasCompletedOnboarding: hasCompletedOnboarding,
    ),
  );
}

class MintoraApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MintoraApp({
    super.key,
    required this.hasCompletedOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mintora',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF67C78F),
        ),
      ),
      home: SplashPage(
        nextPage: hasCompletedOnboarding
            ? const MainShell()
            : const OnboardingPage(),
      ),
    );
  }
}