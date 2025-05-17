import 'package:flutter/foundation.dart';

class TimeUtils {
  /// Standardizes duration from various formats to a consistent Duration object
  static Duration standardizeDuration(dynamic value) {
    if (value == null) {
      return Duration.zero;
    }

    if (value is Duration) {
      return value;
    }

    if (value is int) {
      // Be more definitive about time interpretation based on Firebase format
      // In Firebase JSON, segmentDuration is always in seconds
      return Duration(seconds: value);
    }

    if (value is Map) {
      // Handle json-structured duration with different time units
      if (value.containsKey('seconds')) {
        return Duration(seconds: (value['seconds'] as num).toInt());
      }

      if (value.containsKey('milliseconds')) {
        return Duration(milliseconds: (value['milliseconds'] as num).toInt());
      }

      if (value.containsKey('segmentDuration')) {
        // segmentDuration is stored as seconds in the database
        return Duration(seconds: (value['segmentDuration'] as num).toInt());
      }

      if (value.containsKey('time')) {
        // 'time' field in Firebase is cumulative time in seconds
        return Duration(seconds: (value['time'] as num).toInt());
      }

      if (value.containsKey('timeMs')) {
        return Duration(milliseconds: (value['timeMs'] as num).toInt());
      }
    }

    if (value is String) {
      // Try to parse time string in format HH:MM:SS.mmm
      try {
        final parts = value.split(':');
        if (parts.length == 3) {
          final hoursPart = int.parse(parts[0]);
          final minutesPart = int.parse(parts[1]);

          final secondsParts = parts[2].split('.');
          final secondsPart = int.parse(secondsParts[0]);
          final millisecondsPart = secondsParts.length > 1
              ? int.parse(secondsParts[1].padRight(3, '0').substring(0, 3))
              : 0;

          return Duration(
            hours: hoursPart,
            minutes: minutesPart,
            seconds: secondsPart,
            milliseconds: millisecondsPart,
          );
        }
      } catch (e) {
        debugPrint('Error parsing duration string: $e');
      }
    }

    // Default case - return zero duration if can't parse
    debugPrint('Warning: Could not parse duration from value: $value');
    return Duration.zero;
  }

  /// Converts duration to milliseconds for database storage
  static int toMilliseconds(Duration duration) {
    return duration.inMilliseconds;
  }

  /// Converts duration to seconds for database storage
  static int toSeconds(Duration duration) {
    return duration.inSeconds;
  }
}
