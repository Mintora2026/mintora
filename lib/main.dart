import 'package:flutter/material.dart';
import 'database/record_repository.dart';
import 'pages/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RecordRepository.instance.loadRecords();

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
      home: const MainShell(),
    );
  }
}