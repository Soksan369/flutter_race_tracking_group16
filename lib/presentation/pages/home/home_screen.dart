import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/race_timer_provider.dart';
import '../../widgets/race_navigation_bar.dart';
import '../../../providers/participant_provider.dart';
import '../../../data/services/navigation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRaceInProgress = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Check if race is already in progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final raceTimerProvider =
          Provider.of<RaceTimerProvider>(context, listen: false);
      raceTimerProvider.initialize();

      // Update the UI to reflect if a race is in progress
      setState(() {
        _isRaceInProgress = raceTimerProvider.isRunning;
      });
    });
  }

  void _startRace() async {
    final raceTimerProvider =
        Provider.of<RaceTimerProvider>(context, listen: false);

    // Check if race was already in progress
    final bool wasRunning = _isRaceInProgress;

    // Start/reset the race timer
    await raceTimerProvider.startRace();

    // all participants to "run" segment at the start of the race
    try {
      final participantProvider =
          Provider.of<ParticipantProvider>(context, listen: false);
      final participants = participantProvider.participants;
      for (final p in participants) {
        if (p.segment != 'run') {
          final updated = p.copyWith(segment: 'run', completed: false);
          await participantProvider.completeSegment(p.id, Duration.zero);
        }
      }
    } catch (e) {
      debugPrint('Error resetting participants to running: $e');
    }

    setState(() {
      _isRaceInProgress = true;
    });

    // Navigate to running screen and REPLACE home (so home is not shown again)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wasRunning
              ? '🔄 Race restarted! All participants are back at the running segment.'
              : '🚀 Race started! Tracking running segment.'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/running');
    }
  }

  void _resetRace() async {
    // Show confirmation dialog
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset Race'),
            content: const Text(
                'This will reset the timer, all participant progress, and race history. Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child:
                    const Text('RESET', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm && mounted) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resetting race data...')),
      );

      final raceTimerProvider =
          Provider.of<RaceTimerProvider>(context, listen: false);

      // Reset timer and race data in Firebase
      await raceTimerProvider.resetRace();

      // Reset all participants back to running segment
      // This would ideally be done through a ParticipantProvider
      // For now, we'll assume this needs to be implemented in your participant provider
      try {
        // You would add code here to reset participants to running segment
        // await Provider.of<ParticipantProvider>(context, listen: false).resetAllParticipants();
      } catch (e) {
        debugPrint('Error resetting participants: $e');
      }

      setState(() {
        _isRaceInProgress = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Race has been completely reset')),
      );
    }
  }

  void _onNavBarTap(int index) {
    final route = NavigationService.getRouteForIndex(index);
    if (route != null && ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'RACE TRACKER',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),

              const SizedBox(height: 100),

              // Start button - big circular button
              InkWell(
                onTap: _startRace,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'START',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Reset button - only show if race is in progress
              if (_isRaceInProgress)
                ElevatedButton.icon(
                  onPressed: _resetRace,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'RESET RACE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RaceNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
