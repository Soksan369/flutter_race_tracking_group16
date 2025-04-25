import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final Duration duration;
  const TimerDisplay({super.key, required this.duration});

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMs(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final ms = twoDigitsMs((d.inMilliseconds % 1000) ~/ 10);
    return "$hours:$minutes:$seconds:$ms";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(duration),
      style: const TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }
}