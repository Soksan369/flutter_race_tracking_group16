import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/pages/home/home_screen.dart';
import 'presentation/pages/race_results/result_screen.dart';
import 'presentation/pages/race_tracking/track_running_screen.dart';
import 'presentation/pages/race_tracking/track_swimming_screen.dart';
import 'presentation/pages/race_tracking/track_cycling_screen.dart';
import 'presentation/pages/participants/add_participant.dart';
import 'presentation/pages/participants/list_participants.dart';
import 'providers/participant_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/segment_time_provider.dart';
import 'providers/result_provider.dart';
import 'providers/race_timer_provider.dart';
import 'data/repositories/timer_repository.dart';
import 'data/repositories/participant_repository.dart';
import 'data/services/segment_time_service.dart'; // Make sure this import is present

// Create a separate function for initialization
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable persistence for offline capabilities (optional)
  FirebaseDatabase.instance.setPersistenceEnabled(true);
}

void main() async {
  // Make sure initialization is complete before continuing
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repositories with fixed raceId
    const String raceId = 'race1';
    final timerRepository = TimerRepository(raceId);
    final participantRepository = ParticipantRepository(raceId: raceId);

    return MultiProvider(
      providers: [
        // Make the repository available directly
        Provider<ParticipantRepository>.value(value: participantRepository),

        ChangeNotifierProvider(
          create: (_) => ParticipantProvider(
            repository: participantRepository,
          ),
        ),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(
          create: (_) => SegmentTimeProvider(
            service: SegmentTimeService(raceId: raceId),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ResultProvider(raceId: raceId),
        ),
        ChangeNotifierProvider(
          create: (_) => RaceTimerProvider(repository: timerRepository),
        ),
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
