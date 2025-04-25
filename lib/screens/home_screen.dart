import 'package:flutter/material.dart';
import '../widgets/home_background_section.dart';
import '../widgets/home_title_section.dart';
import '../widgets/home_start_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeBackgroundSection(),
          const HomeTitleSection(),
          HomeStartButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}