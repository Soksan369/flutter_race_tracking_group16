/// Utility functions for formatting data in the app

/// Formats a Duration object into a string with format "HH:MM:SS.cc"
String formatDuration(Duration duration) {
  // Format as HH:MM:SS.cc for precision timing (only showing centiseconds)
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  // Convert to centiseconds (2 digits instead of 3 for milliseconds)
  final centiseconds = (duration.inMilliseconds.remainder(1000) / 10).floor();

  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}.'
      '${centiseconds.toString().padLeft(2, '0')}';
}
