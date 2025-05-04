// Utility functions for formatting data in the app

// Formats a Duration object into a string with format "HH:MM:SS:MS"
String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(d.inHours);
  final minutes = twoDigits(d.inMinutes.remainder(60));
  final seconds = twoDigits(d.inSeconds.remainder(60));
  final ms = twoDigits((d.inMilliseconds % 1000) ~/ 10);
  return "$hours:$minutes:$seconds:$ms";
}
