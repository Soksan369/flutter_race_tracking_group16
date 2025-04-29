import 'package:flutter/material.dart';
import 'presentation/pages/home/home_screen.dart';
import 'presentation/pages/race_results/result_screen.dart';
import 'presentation/pages/race_tracking/track_running_screen.dart';
import 'presentation/pages/race_tracking/track_swimming_screen.dart';
import 'presentation/pages/race_tracking/track_cycling_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        useMaterial3: true,
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
