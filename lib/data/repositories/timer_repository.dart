import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TimerRepository {
  final FirebaseDatabase _db;
  final String raceId;

  TimerRepository(this.raceId) : _db = FirebaseDatabase.instance;

  DatabaseReference get _raceRef => _db.ref().child('races/$raceId');
  DatabaseReference get _participantsRef => _raceRef.child('participants');
  DatabaseReference get _splitsRef => _raceRef.child('splits');
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
  }) {
    return _splitsRef.child(participantId).child(segment).set(elapsedMs);
  }

  Future<Map<String, dynamic>> fetchAllParticipants() async {
    final snapshot = await _participantsRef.get();
    if (!snapshot.exists || snapshot.value == null) return {};
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  Future<Map<String, Map<String, dynamic>>> fetchAllSplits() async {
    final snapshot = await _splitsRef.get();
    if (!snapshot.exists || snapshot.value == null) return {};

    final data = snapshot.value as Map;
    final result = <String, Map<String, dynamic>>{};

    data.forEach((key, value) {
      if (value is Map) {
        result[key.toString()] = Map<String, dynamic>.from(value);
      }
    });

    return result;
  }
}
