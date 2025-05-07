import 'package:firebase_database/firebase_database.dart';
import '../models/segment_time.dart';

class SegmentTimeService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final String _currentRaceId;

  SegmentTimeService({String raceId = 'race1'}) : _currentRaceId = raceId;

  DatabaseReference get _segmentTimesRef =>
      _db.child('segmentTimes/$_currentRaceId');

  Future<bool> recordSegmentTime(SegmentTime segmentTime) async {
    try {
      final segmentString = segmentTime.segment.toString().split('.').last;

      // In Firebase, segment times are stored by participant > segment
      await _segmentTimesRef
          .child(segmentTime.participantId)
          .child(segmentString)
          .set({
        'time': segmentTime.time.inSeconds,
        'recordedAt': segmentTime.recordedAt.toIso8601String(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Stream of segment times for a participant
  Stream<List<SegmentTime>> segmentTimesStream(String participantId) {
    return _segmentTimesRef.child(participantId).onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value == null) return <SegmentTime>[];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final List<SegmentTime> times = [];

      data.forEach((segmentKey, value) {
        value = Map<String, dynamic>.from(value as Map);
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

      return times;
    });
  }

  Future<List<SegmentTime>> getSegmentTimesForParticipant(
      String participantId) async {
    final snapshot = await _segmentTimesRef.child(participantId).get();
    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final List<SegmentTime> times = [];

    data.forEach((segmentKey, value) {
      value = Map<String, dynamic>.from(value as Map);
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

    return times;
  }
}
