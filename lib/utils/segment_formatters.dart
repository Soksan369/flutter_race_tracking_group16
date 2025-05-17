/// Utility functions for formatting segment-specific durations

/// Format a segment duration to a readable string (MM:SS format)
/// Pass a Duration created from milliseconds for correct display.
String formatSegmentDuration(Duration duration) {
  // For race segments, we typically want minutes:seconds format
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds.remainder(60);

  // Format with leading zeros to ensure consistent display
  final String minutesStr = minutes.toString().padLeft(2, '0');
  final String secondsStr = seconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}
