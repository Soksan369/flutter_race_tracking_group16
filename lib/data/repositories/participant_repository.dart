import '../models/participant.dart';
import '../services/firebase_http_service.dart';

class ParticipantRepository {
  final FirebaseHttpService _firebaseService;
  final String _currentRaceId =
      'race1'; // In a real app, this would be configurable

  ParticipantRepository({FirebaseHttpService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseHttpService();

  // Get all participants for the current race
  Future<List<Participant>> getAllParticipants() async {
    try {
      final data = await _firebaseService.get('participants/$_currentRaceId');

      final List<Participant> participants = [];
      if (data != null) {
        data.forEach((key, value) {
          participants.add(Participant.fromJson({...value, 'id': key}));
        });
      }

      return participants;
    } catch (e) {
      print('Error fetching all participants: $e');
      throw Exception('Failed to load participants: $e');
    }
  }

  // Get participants for a specific segment
  Future<List<Participant>> getParticipantsBySegment(String segment) async {
    try {
      // In Firebase, we'd typically query by segment
      // But with REST, we'll fetch all and filter
      final allParticipants = await getAllParticipants();
      return allParticipants.where((p) => p.segment == segment).toList();
    } catch (e) {
      print('Error fetching participants by segment: $e');
      throw Exception('Failed to load participants for segment $segment: $e');
    }
  }

  // Update participant
  Future<void> updateParticipant(Participant participant) async {
    try {
      await _firebaseService.put(
        'participants/$_currentRaceId/${participant.id}',
        participant.toJson(),
      );
    } catch (e) {
      print('Error updating participant: $e');
      throw Exception('Failed to update participant: $e');
    }
  }

  // Update participant status only
  Future<void> updateParticipantStatus(String id, bool completed) async {
    try {
      await _firebaseService.patch(
        'participants/$_currentRaceId/$id',
        {'completed': completed},
      );
    } catch (e) {
      print('Error updating participant status: $e');
      throw Exception('Failed to update participant status: $e');
    }
  }
}
