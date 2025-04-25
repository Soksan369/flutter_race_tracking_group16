import 'package:flutter/material.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_buttons.dart';
import '../widgets/participant_list.dart';
import '../widgets/bottom_nav_bar.dart';

class TrackRunningScreen extends StatefulWidget {
  const TrackRunningScreen({super.key});

  @override
  State<TrackRunningScreen> createState() => _TrackRunningScreenState();
}

class _TrackRunningScreenState extends State<TrackRunningScreen> {
  Duration duration = const Duration(hours: 1, minutes: 23, seconds: 1, milliseconds: 80);
  bool isRunning = false;
  int _currentIndex = 1;

  final List<Map<String, String>> participants = List.generate(
    6,
    (index) => {
      'id': '101',
      'name': 'Sok Sothy',
      'status': 'Finish',
    },
  );

  void _start() {
    setState(() {
      isRunning = true;
    });
    // Add timer logic here
  }

  void _stop() {
    setState(() {
      isRunning = false;
    });
    // Add timer logic here
  }

  void _reset() {
    setState(() {
      duration = Duration.zero;
      isRunning = false;
    });
    // Add timer logic here
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Handle navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Running ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Icon(Icons.directions_run, size: 22),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    TimerDisplay(duration: duration),
                    const SizedBox(height: 18),
                    TimerButtons(
                      onStart: _start,
                      onStop: _stop,
                      onReset: _reset,
                      isRunning: isRunning,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    hintText: 'Search participants...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Text(
                    'Participants',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ParticipantList(participants: participants),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}