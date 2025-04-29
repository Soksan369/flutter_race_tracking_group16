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
}
