import 'package:flutter/material.dart';
import 'timer_display.dart';

class TimerSection extends StatelessWidget {
  final Duration elapsed;
  final bool isRunning;
  final VoidCallback onStartStop;
  final VoidCallback onReset;

  const TimerSection({
    Key? key,
    required this.elapsed,
    required this.isRunning,
    required this.onStartStop,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer display
        TimerDisplay(duration: elapsed, fontSize: 52),

        const SizedBox(height: 20),

        // Timer controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onStartStop,
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
              label: Text(isRunning ? 'Stop' : 'Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning
                    ? const Color(0xFFFF3B30)
                    : const Color(0xFF4CD964),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(100, 45),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(100, 45),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
