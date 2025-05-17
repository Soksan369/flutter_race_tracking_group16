import 'package:flutter/material.dart';
import '../../utils/formatters.dart';

class TimerDisplay extends StatelessWidget {
  final Duration duration;
  final double fontSize;
  final bool showMilliseconds;

  const TimerDisplay({
    super.key,
    required this.duration,
    this.fontSize = 36,
    this.showMilliseconds = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use full time format with optional milliseconds
    final String formattedTime =
        formatDuration(duration, showMilliseconds: showMilliseconds);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        formattedTime,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontFamily: 'monospace',
          color: Colors.black,
        ),
      ),
    );
  }
}
