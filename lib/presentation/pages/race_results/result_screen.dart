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
            // Category Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(categories.length, (i) {
                  final bool selected = selectedCategory == i;
                  return Padding(
                    padding: EdgeInsets.only(right: i < categories.length - 1 ? 12 : 0),
                    child: ChoiceChip(
                      label: Text(
                        categories[i],
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: selected,
                      selectedColor: Colors.grey[200],
                      backgroundColor: Colors.grey[100],
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = i;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Table Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: const [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Rank',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Times',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Table Rows
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return SizedBox(
                      height: 36,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              item['rank']!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              item['name']!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['time']!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['id']!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.directions_run, color: Colors.grey, size: 28),
                    Icon(Icons.pool, color: Colors.grey, size: 28),
                    Icon(Icons.directions_bike, color: Colors.grey, size: 28),
                    Icon(Icons.bar_chart, color: Colors.black, size: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}