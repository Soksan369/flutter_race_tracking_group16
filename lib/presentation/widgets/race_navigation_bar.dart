// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../services/navigation_service.dart';

class RaceNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const RaceNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final route = NavigationService.getRouteForIndex(index);
        if (route != null && ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_run), label: 'Running'),
        BottomNavigationBarItem(icon: Icon(Icons.pool), label: 'Swimming'),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike), label: 'Cycling'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Results'),
      ],
    );
  }
}
