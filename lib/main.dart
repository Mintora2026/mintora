import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MintoraApp());
}

class MintoraApp extends StatelessWidget {
  const MintoraApp({super.key});

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
      home: const HomePage(),
    );
  }
}