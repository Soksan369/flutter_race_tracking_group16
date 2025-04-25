import 'package:flutter/material.dart';

class ResultTableRows extends StatelessWidget {
  final List<Map<String, String>> results;

  const ResultTableRows({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}