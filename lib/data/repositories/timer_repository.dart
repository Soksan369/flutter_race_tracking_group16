import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TimerRepository {
  final DatabaseReference _raceRef;
  final String raceId;

  TimerRepository(this.raceId)
      : _raceRef = FirebaseDatabase.instance.ref().child('races/$raceId');

  DatabaseReference get _startTimeRef => _raceRef.child('startTime');

  Future<void> setStartTime(DateTime t) {
    return _startTimeRef.set(t.toIso8601String());
  }

  Stream<DateTime?> startTimeStream() {
    return _startTimeRef.onValue.map((event) {
      final snapshot = event.snapshot;
      final value = snapshot.value;
      if (value == null || value is! String) return null;
      try {
        return DateTime.parse(value);
      } catch (e) {
        debugPrint('Error parsing time: $e');
        return null;
      }
    });
  }

  Future<void> recordSplit({
    required String participantId,
    required String segment,
    required int elapsedMs,
  }) async {
    // Calculate segment-specific duration
    int segmentDurationMs = elapsedMs;

    // Get previous segment's split time to calculate this segment's duration
    if (segment != 'run') {
      final prevSplits = await getParticipantSplits(participantId);
      final prevSegment = segment == 'swim' ? 'run' : 'swim';

      if (prevSplits.containsKey(prevSegment)) {
        final prevData = prevSplits[prevSegment];
        if (prevData is Map && prevData.containsKey('time')) {
          // Segment duration = current total time - previous segment end time
          segmentDurationMs = elapsedMs - (prevData['time'] as int);
        }
      }
    }

    return _raceRef.child('splits/$participantId/$segment').set({
      'time': elapsedMs,
      'segmentDuration': segmentDurationMs,
      'recordedAt': DateTime.now().toIso8601String(),
    });
  }

  // Helper method to get a participant's splits
  Future<Map<String, dynamic>> getParticipantSplits(
      String participantId) async {
    final snapshot = await _raceRef.child('splits/$participantId').get();
    if (!snapshot.exists) return {};
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  // Stream of all splits for tracking race progress in real-time
  Stream<Map<String, dynamic>> splitsStream() {
    return _raceRef.child('splits').onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value == null) return <String, dynamic>{};
      return Map<String, dynamic>.from(snapshot.value as Map);
    });
  }

  // Add method to reset race data
  Future<void> resetRaceData() async {
    try {
      // Clear start time
      await _startTimeRef.remove();

      // Clear all participant splits
      await _raceRef.child('splits').remove();

      debugPrint('Race data reset successfully');
    } catch (e) {
      debugPrint('Error resetting race data: $e');
      throw e;
    }
  }
}
