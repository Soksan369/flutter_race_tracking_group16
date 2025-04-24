import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int selectedCategory = 0;
  final List<String> categories = ['All', 'Running', 'Swimming', 'Cycling'];

  final List<Map<String, String>> results = List.generate(
    10,
    (index) => {
      'rank': (index + 1).toString(),
      'name': 'Sok Sothy',
      'time': '12:23:01',
      'id': '101',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Title
            const Text(
              'Race Results 🏆',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            // ...existing code...
          ],
        ),
      ),
    );
  }
}
