import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/track_running_screen.dart';
import 'screens/track_swimming_screen.dart';
import 'screens/track_cycling_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Race Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/result': (context) => const ResultScreen(),
        '/running': (context) => const TrackRunningScreen(),
        '/swimming': (context) => const TrackSwimmingScreen(),
        '/cycling': (context) => const TrackCyclingScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}