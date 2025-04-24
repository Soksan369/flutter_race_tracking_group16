import 'package:flutter/material.dart';
import 'screen/result_screen.dart';
import 'screen/track_running_screen.dart';
import 'screen/track_swimming_screen.dart';
import 'screen/track_cycling_screen.dart';

// Entry point for the Flutter application
// TODO: Initialize Firebase and configure the app here
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TrackCyclingScreen(),
    );
  }
}
