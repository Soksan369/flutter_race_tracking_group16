import '../models/result.dart';
import '../services/firebase_http_service.dart';
import 'package:flutter/foundation.dart';

class ResultRepository {
  final FirebaseHttpService _firebaseService;
  final String _currentRaceId =
      'race1'; // In a real app, this would be configurable

  ResultRepository({FirebaseHttpService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseHttpService();

  Future<List<Result>> getResults() async {
    try {
      final data = await _firebaseService.get('results/$_currentRaceId');
      final results = <Result>[];

      if (data != null) {
        data.forEach((key, value) {
          if (value != null) {
            try {
              // Ensure participantId is set from the key if missing in the data
              final Map<String, dynamic> resultData =
                  Map<String, dynamic>.from(value as Map);
              if (!resultData.containsKey('participantId')) {
                resultData['participantId'] = key;
              }

              final result = Result.fromJson(resultData);
              debugPrint('Loaded result: ${result.name}, BIB: ${result.bib}');
              results.add(result);
            } catch (e) {
              debugPrint('Error parsing result: $e');
            }
          }
        });
      }

      // sort by rank, nulls last
      results.sort((a, b) {
        final ra = a.rank, rb = b.rank;
        if (ra == null && rb == null) return 0;
        if (ra == null) return 1;
        if (rb == null) return -1;
        return ra.compareTo(rb);
      });
      return results;
    } catch (e) {
      debugPrint('Error fetching results: $e');
      throw Exception('Failed to load results: $e');
    }
  }

  Future<void> updateResult(Result result) async {
    try {
      await _firebaseService.put(
        'results/$_currentRaceId/${result.participantId}',
        result.toJson(),
      );
    } catch (e) {
      // print('Error updating result: $e');
      throw Exception('Failed to update result: $e');
    }
  }
}
