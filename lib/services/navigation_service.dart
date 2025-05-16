// ignore_for_file: unreachable_switch_default

import '../data/models/segment_time.dart';

class NavigationService {
  static int getNavigationIndex(Segment segment) {
    switch (segment) {
      case Segment.run:
        return 0;
      case Segment.swim:
        return 1;
      case Segment.cycle:
        return 2;
      case Segment.result:
        return 3; // ✅ MUST be here
      default:
        return 0;
    }
  }

  static String getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/running';
      case 1:
        return '/swimming';
      case 2:
        return '/cycling';
      case 3:
        return '/result';
      default:
        return '/';
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
