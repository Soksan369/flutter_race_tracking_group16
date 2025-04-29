import '../models/participant.dart';
import '../repositories/participant_repository.dart';

class ParticipantProgressionService {
  final ParticipantRepository _participantRepo;

  ParticipantProgressionService({ParticipantRepository? participantRepo})
      : _participantRepo = participantRepo ?? ParticipantRepository();

  /// Move a participant to the next segment after completing current segment
  Future<Participant?> moveToNextSegment(
      Participant participant, Duration segmentTime) async {
    // Mark current segment as completed
    final updatedCompletedSegments =
        Map<String, bool>.from(participant.completedSegments);
    updatedCompletedSegments[participant.segment] = true;

    // Determine next segment
    final nextSegment = participant.getNextSegment();

    // If no next segment (cycling is completed), mark participant as fully completed
    if (nextSegment == null) {
      final completedParticipant = participant.copyWith(
        completed: true,
        completedSegments: updatedCompletedSegments,
      );

      // In a real app, save to database
      // await _participantRepo.updateParticipant(completedParticipant);

      return completedParticipant;
    }

    // Move to next segment
    final nextSegmentParticipant = participant.copyWith(
      segment: nextSegment,
      completed: false, // Reset completion for new segment
      completedSegments: updatedCompletedSegments,
    );

    // In a real app, save to database
    // await _participantRepo.updateParticipant(nextSegmentParticipant);

    return nextSegmentParticipant;
  }
}
