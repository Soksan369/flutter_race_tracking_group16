import 'package:flutter/material.dart';

class HomeBackgroundSection extends StatelessWidget {
  const HomeBackgroundSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/TriTrack (3) 1.png', // Use your merged image path
        fit: BoxFit.cover,
      ),
    );
  }
}