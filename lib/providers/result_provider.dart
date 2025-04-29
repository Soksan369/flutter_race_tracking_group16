import 'package:flutter/foundation.dart';
import '../data/models/result.dart';
import '../data/repositories/result_repository.dart';
import '../data/services/result_service.dart';

class ResultProvider with ChangeNotifier {
  final ResultRepository _repository;
  final ResultService _resultService;

  List<Result> _results = [];
  bool _isLoading = false;
  String? _error;

  ResultProvider({
    ResultRepository? repository,
    ResultService? resultService,
  })  : _repository = repository ?? ResultRepository(),
        _resultService = resultService ?? ResultService();

  List<Result> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadResults() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.getResults();
      _results = data;
    } catch (e) {
      _error = 'Failed to load results: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> calculateAndUpdateResult(String participantId) async {
    try {
      await _resultService.calculateAndUpdateResult(participantId);
      await loadResults(); // Refresh results after update
    } catch (e) {
      _error = 'Failed to update result: $e';
      notifyListeners();
    }
  }

  List<Result> getFilteredResults(String query, String category) {
    if (query.isEmpty && category == 'All') return _results;

    return _results.where((r) {
      final matchesQuery = query.isEmpty ||
          r.name.toLowerCase().contains(query.toLowerCase()) ||
          r.bib.toString().contains(query);

      // In a real app, you would have proper category filtering
      final matchesCategory = category == 'All' ||
          (category == 'Running' && r.bib % 3 == 0) || // Just for demonstration
          (category == 'Swimming' && r.bib % 3 == 1) ||
          (category == 'Cycling' && r.bib % 3 == 2);

      return matchesQuery && matchesCategory;
    }).toList();
  }
}
