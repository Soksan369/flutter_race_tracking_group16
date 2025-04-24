import 'package:flutter/material.dart';

class TrackSwimmingScreen extends StatefulWidget {
  const TrackSwimmingScreen({super.key});

  @override
  State<TrackSwimmingScreen> createState() => _TrackSwimmingScreenState();
}

class _TrackSwimmingScreenState extends State<TrackSwimmingScreen> {
  // Timer variables
  Duration duration =
      const Duration(hours: 1, minutes: 23, seconds: 1, milliseconds: 80);

  // Dummy participant data
  final List<Map<String, String>> participants = List.generate(
    6,
    (index) => {
      'id': '101',
      'name': 'Sok Sothy',
      'status': 'Finish',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Swimming ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.pool, size: 22),
              ],
            ),
            const SizedBox(height: 24),
            // ...existing code...
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMs(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final ms = twoDigitsMs((d.inMilliseconds % 1000) ~/ 10);
    return "$hours:$minutes:$seconds:$ms";
  }
}
