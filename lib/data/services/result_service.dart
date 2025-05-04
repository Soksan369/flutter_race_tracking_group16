// ignore_for_file: unused_import

import '../models/result.dart';
import '../models/segment_time.dart';
import '../models/participant.dart';
import '../repositories/participant_repository.dart';
import '../repositories/result_repository.dart';
import 'segment_time_service.dart';

class ResultService {
  final SegmentTimeService _segmentTimeService;
  final ParticipantRepository _participantRepository;
  final ResultRepository _resultRepository;

  ResultService({
    SegmentTimeService? segmentTimeService,
    ParticipantRepository? participantRepository,
    ResultRepository? resultRepository,
  })  : _segmentTimeService = segmentTimeService ?? SegmentTimeService(),
        _participantRepository =
            participantRepository ?? ParticipantRepository(),
        _resultRepository = resultRepository ?? ResultRepository();

  Future<void> calculateAndUpdateResult(String participantId) async {
    try {
      // Get all segment times for participant
      final segmentTimes = await _segmentTimeService .getSegmentTimesForParticipant(participantId);

      // Get participant details
      final allParticipants = await _participantRepository.getAllParticipants();
      final participant =
          allParticipants.firstWhere((p) => p.id == participantId);

      // Calculate total time
      Duration totalTime = Duration.zero;
      for (var time in segmentTimes) {
        totalTime += time.time;
      }

      // For now, assign rank based on total time
      // In a real app, this would involve more complex logic
      const int rank = 1; // Placeholder

      // Create or update result
      final result = Result(
        participantId: participantId,
        bib: participant.bib,
        name: participant.name,
        totalTime: totalTime,
        rank: rank,
      );

      await _resultRepository.updateResult(result);
    } catch (e) {
      // print('Error calculating result: $e');
      throw Exception('Failed to calculate result: $e');
    }
  }
}
