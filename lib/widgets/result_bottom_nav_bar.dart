import 'package:flutter/material.dart';

class ResultBottomNavBar extends StatelessWidget {
  const ResultBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}