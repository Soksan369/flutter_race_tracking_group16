import 'package:flutter/material.dart';
import 'package:flutter_race_tracking_group16/presentation/pages/participants/add_participant.dart';
import 'package:flutter_race_tracking_group16/presentation/pages/participants/list_participants.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/home/home_screen copy.dart';
import 'presentation/pages/race_results/result_screen.dart';
import 'presentation/pages/race_tracking/track_running_screen.dart';
import 'presentation/pages/race_tracking/track_swimming_screen.dart';
import 'presentation/pages/race_tracking/track_cycling_screen.dart';
import 'providers/participant_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/segment_time_provider.dart';
import 'providers/result_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => SegmentTimeProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
      ],
      child: MaterialApp(
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
          '/add_participant': (context) => const AddParticipant(),
          '/list_participants': (context) => const ListParticipants(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
