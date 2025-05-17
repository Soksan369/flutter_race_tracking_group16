/// Utility functions for formatting data in the app

/// Format a duration to a readable string in the format HH:MM:SS.mmm (with optional milliseconds)
String formatDuration(Duration duration, {bool showMilliseconds = false}) {
  // Correctly handle large durations by calculating hours properly
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  // Format with leading zeros to ensure consistent display
  final String hoursStr = hours.toString().padLeft(2, '0');
  final String minutesStr = minutes.toString().padLeft(2, '0');
  final String secondsStr = seconds.toString().padLeft(2, '0');

  String result = '$hoursStr:$minutesStr:$secondsStr';

  if (showMilliseconds) {
    final int milliseconds = duration.inMilliseconds.remainder(1000);
    final String msStr = milliseconds.toString().padLeft(3, '0');
    result += '.$msStr';
  }

  return result;
}

/// Format a duration as MM:SS specifically for race result displays
String formatRaceTime(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds.remainder(60);

  // Format seconds with leading zeros
  final String secondsStr = seconds.toString().padLeft(2, '0');

  return '$minutes:$secondsStr';
}
