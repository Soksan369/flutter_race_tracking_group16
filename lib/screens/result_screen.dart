import 'package:flutter/material.dart';
import '../widgets/result_category_tabs.dart';
import '../widgets/result_search_bar.dart';
import '../widgets/result_table_header.dart';
import '../widgets/result_table_rows.dart';
import '../widgets/result_bottom_nav_bar.dart';

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
            // Category Tabs
            ResultCategoryTabs(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (i) {
                setState(() {
                  selectedCategory = i;
                });
              },
            ),
            const SizedBox(height: 18),
            // Search Bar
            const ResultSearchBar(),
            const SizedBox(height: 18),
            // Table Header
            const ResultTableHeader(),
            const SizedBox(height: 4),
            // Table Rows
            Expanded(
              child: ResultTableRows(results: results),
            ),
            // Bottom Navigation Bar
            const ResultBottomNavBar(),
          ],
        ),
      ),
    );
  }
}