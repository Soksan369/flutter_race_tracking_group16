import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/running');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/swimming');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cycling');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/result');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/running');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (onTap != null) onTap!(index);
        _navigate(context, index);
      },
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
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
}