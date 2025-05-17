// ignore_for_file: unreachable_switch_default

import '../models/segment_time.dart';

class NavigationService {
  static int getNavigationIndex(Segment segment) {
    switch (segment) {
      case Segment.run:
        return 1; // Updated index for Running
      case Segment.swim:
        return 2; // Updated index for Swimming
      case Segment.cycle:

        return 3; // Updated index for Cycling

      default:
        return 0; // Default to Home
    }
  }

  static String getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/'; // Home
      case 1:
        return '/running'; // Running
      case 2:
        return '/swimming'; // Swimming
      case 3:
        return '/cycling'; // Cycling
      case 4:
        return '/result'; // Results
      default:
        return '/'; // Default to Home
    }
  }

  // New method to get route based on segment string
  static String? getRouteForSegment(String segment) {
    switch (segment) {
      case 'run':
        return '/running';
      case 'swim':
        return '/swimming';
      case 'cycle':
        return '/cycling';
      default:
        return null;
    }
  }

  static getSegmentByIndex(int index) {}
}
