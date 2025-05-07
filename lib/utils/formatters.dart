/// Utility functions for formatting data in the app

/// Formats a Duration object into a string with format "MM:SS" or "HH:MM:SS"
String formatDuration(Duration duration) {
  // Format to mm:ss or hh:mm:ss if longer than an hour
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
