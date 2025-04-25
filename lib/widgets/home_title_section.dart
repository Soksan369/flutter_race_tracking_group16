import 'package:flutter/material.dart';

class HomeTitleSection extends StatelessWidget {
  const HomeTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'TRITRACK',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC107), // Amber
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'TRAKER',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}