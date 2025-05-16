// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';

class FirebaseDataNormalizer {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// Normalizes the database structure by standardizing segment names
  /// from "running/swimming/cycling" to "run/swim/cycle"
  static Future<void> normalizeSegmentNames() async {
    try {
      final racesRef = _db.ref().child('races/race1/splits');
      final splitsSnapshot = await racesRef.get();

      if (!splitsSnapshot.exists) return;

      final splits = splitsSnapshot.value as Map<dynamic, dynamic>;

      // For each participant's splits
      for (var participantId in splits.keys) {
        final participantSplits =
            splits[participantId] as Map<dynamic, dynamic>;

        // Check and rename each segment type
        if (participantSplits.containsKey('running')) {
          final value = participantSplits['running'];
          await racesRef.child('$participantId/run').set(value);
          await racesRef.child('$participantId/running').remove();
        }

        if (participantSplits.containsKey('swimming')) {
          final value = participantSplits['swimming'];
          await racesRef.child('$participantId/swim').set(value);
          await racesRef.child('$participantId/swimming').remove();
        }

        if (participantSplits.containsKey('cycling')) {
          final value = participantSplits['cycling'];
          await racesRef.child('$participantId/cycle').set(value);
          await racesRef.child('$participantId/cycling').remove();
        }
      }
    } catch (e) {
      print('Error normalizing data: $e');
    }
  }

  /// Consolidates participants from participants/race1 to races/race1/participants
  /// This ensures all participant data is in one place
  static Future<void> consolidateParticipants() async {
    try {
      // Get participants from the separate participants node
      final participantsSnapshot =
          await _db.ref().child('participants/race1').get();

      if (!participantsSnapshot.exists) return;

      final participants = participantsSnapshot.value as Map<dynamic, dynamic>;
      final raceParticipantsRef = _db.ref().child('races/race1/participants');

      // For each participant, copy to the races node
      for (var participantId in participants.keys) {
        final participant = participants[participantId];

        // Only copy essential data for the races/race1/participants structure
        final Map<String, dynamic> essentialData = {
          'bib': participant['bib'],
          'name': participant['name'],
        };

        await raceParticipantsRef
            .child(participantId.toString())
            .update(essentialData);
      }
    } catch (e) {
      print('Error consolidating participants: $e');
    }
  }
}
