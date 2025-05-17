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

          //
        ],
      ],
    );
  }
}
