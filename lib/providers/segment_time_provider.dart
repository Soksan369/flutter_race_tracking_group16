import 'package:flutter/foundation.dart';
import '../data/models/segment_time.dart';
import '../data/services/segment_time_service.dart';

class SegmentTimeProvider with ChangeNotifier {
  final SegmentTimeService _service;

  List<SegmentTime> _segmentTimes = [];
  bool _isLoading = false;
  String? _error;

  SegmentTimeProvider({SegmentTimeService? service})
      : _service = service ?? SegmentTimeService();

  List<SegmentTime> get segmentTimes => _segmentTimes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSegmentTimesForParticipant(String participantId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.getSegmentTimesForParticipant(participantId);
      _segmentTimes = data;
    } catch (e) {
      _error = 'Failed to load segment times: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> recordSegmentTime(SegmentTime segmentTime) async {
    try {
      final result = await _service.recordSegmentTime(segmentTime);
      if (result) {
        _segmentTimes.add(segmentTime);
        notifyListeners();
      }
      return result;
    } catch (e) {
      _error = 'Failed to record segment time: $e';
      notifyListeners();
      return false;
    }
  }
}
