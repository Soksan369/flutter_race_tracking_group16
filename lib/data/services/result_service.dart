// ignore_for_file: unused_import, unused_field, avoid_print

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
      // Fetch all segment times for this participant
      final segmentTimes = await _segmentTimeService
          .getSegmentTimesForParticipant(participantId);

      // Extract segment times
      Duration? runTime, swimTime, cycleTime;
      Duration totalTime = Duration.zero;
      bool allSegmentsCompleted = true;

      for (var segmentTime in segmentTimes) {
        switch (segmentTime.segment) {
          case Segment.run:
            runTime = segmentTime.time;
            totalTime += segmentTime.time;
            break;
          case Segment.swim:
            swimTime = segmentTime.time;
            totalTime += segmentTime.time;
            break;
          case Segment.cycle:
            cycleTime = segmentTime.time;
            totalTime += segmentTime.time;
            break;
          default:
            // Segment.result or any unexpected value — safely ignored
            break;
        }
      }

      // Only set totalTime if all segments are completed
      if (runTime == null || swimTime == null || cycleTime == null) {
        allSegmentsCompleted = false;
      }

      // For now, hardcode participant info. In a real app, you'd fetch this
      String name = "Unknown";
      int bib = 0;

      // Try to find existing result to get name/bib
      try {
        final results = await _resultRepository.getResults();
        for (var result in results) {
          if (result.participantId == participantId) {
            name = result.name;
            bib = result.bib;
            break;
          }
        }
      } catch (e) {
        // Ignore errors, use default name/bib
      }

      // Create and update result
      final result = Result(
        participantId: participantId,
        name: name,
        bib: bib,
        runTime: runTime,
        swimTime: swimTime,
        cycleTime: cycleTime,
        totalTime: allSegmentsCompleted ? totalTime : null,
        rank: null, // Ranking would be calculated separately
      );

      await _resultRepository.updateResult(result);
    } catch (e) {
      print('Error calculating result: $e');
      throw Exception('Failed to calculate result: $e');
    }
  }
}
