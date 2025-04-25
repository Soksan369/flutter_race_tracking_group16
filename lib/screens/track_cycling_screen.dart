import 'package:flutter/material.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_buttons.dart';
import '../widgets/participant_list.dart';
import '../widgets/bottom_nav_bar.dart';

class TrackCyclingScreen extends StatefulWidget {
  const TrackCyclingScreen({super.key});

  @override
  State<TrackCyclingScreen> createState() => _TrackCyclingScreenState();
}

class _TrackCyclingScreenState extends State<TrackCyclingScreen> {
  Duration duration = const Duration(hours: 1, minutes: 23, seconds: 1, milliseconds: 80);
  bool isRunning = false;
  int _currentIndex = 2;

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
                  'Cycling ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.directions_bike, size: 22),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade300),
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
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.groups, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Participant',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
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