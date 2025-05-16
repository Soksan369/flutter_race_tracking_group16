// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'package:firebase_database/firebase_database.dart';
import '../models/participant.dart';

class ParticipantRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final String _currentRaceId;

  ParticipantRepository({String raceId = 'race1'}) : _currentRaceId = raceId;

  // Get reference for participants in "races/race1/participants"
  DatabaseReference get _raceParticipantsRef =>
      _db.child('races/$_currentRaceId/participants');

  // Get reference for participants in "participants/race1"
  DatabaseReference get _legacyParticipantsRef =>
      _db.child('participants/$_currentRaceId');

  // Get all participants for the current race as a real-time stream
  Stream<List<Participant>> participantsStream() {
    // Combine streams from both locations
    return Stream.fromFuture(getAllParticipants());
  }

  // Fetch participants from both locations and combine them
  Future<List<Participant>> getAllParticipants() async {
    List<Participant> participants = [];

    // First, try to get participants from races/race1/participants
    try {
      final snapshot = await _raceParticipantsRef.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((key, value) {
          try {
            participants.add(Participant.fromJson(
                {...Map<String, dynamic>.from(value as Map), 'id': key}));
          } catch (e) {
            print('Error parsing participant $key: $e');
          }
        });
      }
    } catch (e) {
      print('Error fetching from races path: $e');
    }

    // Then, get participants from participants/race1
    try {
      final snapshot = await _legacyParticipantsRef.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((key, value) {
          try {
            participants.add(Participant.fromJson(
                {...Map<String, dynamic>.from(value as Map), 'id': key}));
          } catch (e) {
            print('Error parsing participant $key: $e');
          }
        });
      }
    } catch (e) {
      print('Error fetching from participants path: $e');
    }

    return participants;
  }

  // Get participants for a specific segment as a real-time stream
  Stream<List<Participant>> participantsBySegmentStream(String segment) {
    return participantsStream().map((participants) {
      return participants.where((p) => p.segment == segment).toList();
    });
  }

  // Add a new participant
  Future<void> addParticipant(Participant participant) {
    // Always add to the races/raceId/participants path for consistency
    return _raceParticipantsRef.child(participant.id).set(participant.toJson());
  }

  // Update a participant (used when completing a segment)
  Future<void> updateParticipant(Participant participant) async {
    // Try to update in both places to ensure consistency
    try {
      // First check if participant exists in races path
      final racesSnapshot =
          await _raceParticipantsRef.child(participant.id).get();
      if (racesSnapshot.exists) {
        await _raceParticipantsRef
            .child(participant.id)
            .update(participant.toJson());
      } else {
        // If not in races path, check in participants path
        final legacySnapshot =
            await _legacyParticipantsRef.child(participant.id).get();
        if (legacySnapshot.exists) {
          await _legacyParticipantsRef
              .child(participant.id)
              .update(participant.toJson());
        } else {
          // If not found in either place, create it in the races path
          await _raceParticipantsRef
              .child(participant.id)
              .set(participant.toJson());
        }
      }
    } catch (e) {
      print('Error updating participant ${participant.id}: $e');
      throw e;
    }
  }

  // Get a single participant by ID
  Future<Participant?> getParticipant(String id) async {
    // Try races path first
    final racesSnapshot = await _raceParticipantsRef.child(id).get();
    if (racesSnapshot.exists) {
      try {
        final data = Map<String, dynamic>.from(racesSnapshot.value as Map);
        return Participant.fromJson({...data, 'id': id});
      } catch (e) {
        print('Error getting participant $id from races path: $e');
      }
    }

    // If not found, try participants path
    final legacySnapshot = await _legacyParticipantsRef.child(id).get();
    if (legacySnapshot.exists) {
      try {
        final data = Map<String, dynamic>.from(legacySnapshot.value as Map);
        return Participant.fromJson({...data, 'id': id});
      } catch (e) {
        print('Error getting participant $id from participants path: $e');
      }
    }

    return null;
  }
}
