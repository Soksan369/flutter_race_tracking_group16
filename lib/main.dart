import 'package:flutter/material.dart';
import './presentation/pages/race_tracking/track_cycling_screen.dart';
import './presentation/pages/race_tracking/track_swimming_screen.dart';
import './presentation/pages/race_tracking/track_running_screen.dart';
import './presentation/pages/race_results/result_screen.dart';

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
