/// Utility functions for formatting data in the app

/// Format a duration to a readable string in the format HH:MM:SS.SS
String formatDuration(Duration duration) {
  // Correctly handle large durations by calculating hours properly
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);
  final int milliseconds = duration.inMilliseconds.remainder(1000);

  // Format with leading zeros to ensure consistent display
  final String hoursStr = hours.toString().padLeft(2, '0');
  final String minutesStr = minutes.toString().padLeft(2, '0');
  final String secondsStr = seconds.toString().padLeft(2, '0');
  // Only show hundredths of a second (2 decimal places)
  final String millisecondsStr =
      (milliseconds ~/ 10).toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr.$millisecondsStr';
}

/// Format a duration to a readable string in the format HH:MM:SS (no milliseconds)
String formatDurationHMS(Duration duration) {
  // Correctly handle large durations by calculating hours properly
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  // Format with leading zeros to ensure consistent display
  final String hoursStr = hours.toString().padLeft(2, '0');
  final String minutesStr = minutes.toString().padLeft(2, '0');
  final String secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}
