import 'package:flutter/material.dart';

class MemorySearchPage extends StatelessWidget {
  const MemorySearchPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color pageBackground = Color(0xFFF6FBF8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        title: const Text(
          'Search Memories',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Memory search is coming next.',
          style: TextStyle(
            color: Color(0xFF6B7D75),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}