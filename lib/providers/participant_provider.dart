import 'package:flutter/foundation.dart';
import '../data/models/participant.dart';
import '../data/repositories/participant_repository.dart';
import '../data/services/participant_progression_service.dart';

class ParticipantProvider with ChangeNotifier {
  final ParticipantRepository _repository;
  final ParticipantProgressionService _progressionService;

  List<Participant> _participants = [];
  bool _isLoading = false;
  String? _error;

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

  Future<void> loadParticipantsBySegment(String segment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.getParticipantsBySegment(segment);
      _participants = data;
    } catch (e) {
      _error = 'Failed to load participants: $e';
    } finally {
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

        // Update local list
        _participants.removeAt(index);
        notifyListeners();
      }

      return updatedParticipant;
    } catch (e) {
      _error = 'Failed to update participant: $e';
      notifyListeners();
      return null;
    }
  }

  List<Participant> getFilteredParticipants(String query) {
    if (query.isEmpty) return _participants;

    return _participants
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.bib.toString().contains(query))
        .toList();
  }
}
