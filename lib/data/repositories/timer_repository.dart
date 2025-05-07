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

  Future<void> recordSplit(
      {required String participantId,
      required String segment,
      required int elapsedMs}) {
    return _raceRef.child('splits/$participantId/$segment').set({
      'time': elapsedMs,
      'recordedAt': DateTime.now().toIso8601String(),
    });
  }

  // Stream of all splits for tracking race progress in real-time
  Stream<Map<String, dynamic>> splitsStream() {
    return _raceRef.child('splits').onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value == null) return <String, dynamic>{};
      return Map<String, dynamic>.from(snapshot.value as Map);
    });
  }
}
