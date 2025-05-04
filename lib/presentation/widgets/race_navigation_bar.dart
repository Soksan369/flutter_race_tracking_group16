// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../data/models/segment_time.dart';

class RaceNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const RaceNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'Running',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pool),
          label: 'Swimming',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bike),
          label: 'Cycling',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Results',
        ),
      ],
    );
  }
}
