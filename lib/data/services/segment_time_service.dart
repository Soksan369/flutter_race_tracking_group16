import '../models/segment_time.dart';
import 'firebase_http_service.dart';

class SegmentTimeService {
  final FirebaseHttpService _firebaseService;
  final String _currentRaceId =
      'race1'; // In a real app, this would be configurable

  SegmentTimeService({FirebaseHttpService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseHttpService();

  Future<bool> recordSegmentTime(SegmentTime segmentTime) async {
    try {
      final segmentString = segmentTime.segment.toString().split('.').last;

      // In Firebase, segment times are stored by participant > segment
      await _firebaseService.put(
        'segmentTimes/$_currentRaceId/${segmentTime.participantId}/$segmentString',
        {
          'time': segmentTime.time.inSeconds,
          'recordedAt': segmentTime.recordedAt.toIso8601String(),
        },
      );

      return true;
    } catch (e) {
      // print('Error recording segment time: $e');
      return false;
    }
  }

  Future<List<SegmentTime>> getSegmentTimesForParticipant(
      String participantId) async {
    try {
      final data = await _firebaseService
          .get('segmentTimes/$_currentRaceId/$participantId');

      final List<SegmentTime> times = [];
      if (data != null) {
        data.forEach((segmentKey, value) {
          final segment = Segment.values.firstWhere(
            (s) => s.toString().split('.').last == segmentKey,
            orElse: () => Segment.run,
          );

          times.add(SegmentTime(
            participantId: participantId,
            segment: segment,
            time: Duration(seconds: value['time']),
            recordedAt: DateTime.parse(value['recordedAt']),
          ));
        });
      }

      return times;
    } catch (e) {
      // print('Error fetching segment times: $e');
      return [];
    }
  }
}
