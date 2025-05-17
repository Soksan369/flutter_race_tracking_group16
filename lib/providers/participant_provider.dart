import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/participant.dart';
import '../data/repositories/participant_repository.dart';
import '../data/services/participant_progression_service.dart';

class ParticipantProvider with ChangeNotifier {
  final ParticipantRepository _repository;
  final ParticipantProgressionService _progressionService;

  List<Participant> _participants = [];
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;

  ParticipantProvider({
    ParticipantRepository? repository,
    ParticipantProgressionService? progressionService,
  })  : _repository = repository ?? ParticipantRepository(),
        _progressionService = progressionService ??
            ParticipantProgressionService(
                participantRepo: repository ?? ParticipantRepository());

  List<Participant> get participants => _participants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load participants for a specific segment
  void loadParticipantsBySegment(String segment) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    

    
  }

  // Private method to fetch participants for a specific segment
  Future<void> _fetchParticipantsBySegment(String segment) async {
    try {
      // Updated to use the public getAllParticipants method
      final allParticipants = await _repository.getAllParticipants();
      // Filter by segment
      _participants =
          allParticipants.where((p) => p.segment == segment).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load participants: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Participant?> completeSegment(String id, Duration segmentTime) async {
    try {
      final index = _participants.indexWhere((p) => p.id == id);
      if (index == -1) return null;

      final participant = _participants[index];
      final updatedParticipant =
          await _progressionService.moveToNextSegment(participant, segmentTime);

      if (updatedParticipant != null) {
        // Update participant in repository
        await _repository.updateParticipant(updatedParticipant);
      }

      return updatedParticipant;
    } catch (e) {
      _error = 'Failed to update participant: $e';
      notifyListeners();
      return null;
    }
  }

  // Make sure this method only filters for display and doesn't modify participant data
  List<Participant> getFilteredParticipants(String query) {
    if (query.isEmpty)
      return List.from(_participants); // Return a copy, not the original

    final lowercaseQuery = query.toLowerCase();
    return _participants
        .where((p) =>
            p.name.toLowerCase().contains(lowercaseQuery) ||
            p.bib.toString().contains(lowercaseQuery))
        .toList();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
