import '../models/result.dart';
import '../services/firebase_http_service.dart';

class ResultRepository {
  final FirebaseHttpService _firebaseService;
  final String _currentRaceId = 'race1'; // In a real app, this would be configurable

  ResultRepository({FirebaseHttpService? firebaseService}) : _firebaseService = firebaseService ?? FirebaseHttpService();

  Future<List<Result>> getResults() async {
    try {
      final data = await _firebaseService.get('results/$_currentRaceId');

      final results = <Result>[];
      if (data != null) {
        data.forEach((key, value) {
          if (value != null && value['totalTime'] != null) {
            results.add(Result.fromJson(value));
          }
        });
      }

      // Sort by rank
      results.sort((a, b) => a.rank.compareTo(b.rank));
      return results;
    } catch (e) {
      // print('Error fetching results: $e');
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
