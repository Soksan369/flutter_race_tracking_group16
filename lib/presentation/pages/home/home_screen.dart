import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/race_timer_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRaceInProgress = false;

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

    // Start the race timer
    await raceTimerProvider.startRace();

    setState(() {
      _isRaceInProgress = true;
    });

    // Navigate to running screen
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('🚀 Race started! Tracking running segment.')),
      );
      Navigator.pushNamed(context, '/running');
    }
  }

  void _resetRace() async {
    // Show confirmation dialog
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset Race'),
            content: const Text(
                'This will stop and reset the timer for all participants. Are you sure?'),
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
      final raceTimerProvider =
          Provider.of<RaceTimerProvider>(context, listen: false);
      await raceTimerProvider.resetRace();

      setState(() {
        _isRaceInProgress = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Race timer has been reset')),
      );
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

              const SizedBox(height: 40),

              // Manage button - text button with icon
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/list_participants'),
                icon: const Icon(Icons.people),
                label: const Text(
                  'MANAGE PARTICIPANTS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3366FF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
