import 'package:flutter/material.dart';
import 'timer_display.dart';

enum TimerMode { viewOnly, controllable }

class TimerSection extends StatelessWidget {
  final Duration elapsed;
  final bool isRunning;
  final VoidCallback? onStartStop;
  final VoidCallback? onReset;
  final TimerMode mode;

  const TimerSection({
    super.key,
    required this.elapsed,
    required this.isRunning,
    this.onStartStop,
    this.onReset,
    this.mode = TimerMode.controllable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer display
        TimerDisplay(duration: elapsed, fontSize: 52),

        // Only show controls if in controllable mode
        if (mode == TimerMode.controllable &&
            onStartStop != null &&
            onReset != null) ...[
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
      ],
    );
  }
}
