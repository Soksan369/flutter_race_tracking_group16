import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/segment_time.dart';
import '../data/services/segment_time_service.dart';

class SegmentTimeProvider with ChangeNotifier {
  final SegmentTimeService _service;

  List<SegmentTime> _segmentTimes = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<SegmentTime>>? _subscription;
  String? _currentParticipantId;

  SegmentTimeProvider({SegmentTimeService? service})
      : _service = service ?? SegmentTimeService();

  List<SegmentTime> get segmentTimes => _segmentTimes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadSegmentTimesForParticipant(String participantId) {
    if (_currentParticipantId == participantId && _subscription != null) {
      return; // Already subscribed to this participant
    }

    _isLoading = true;
    _error = null;
    _currentParticipantId = participantId;
    notifyListeners();

    // Cancel any existing subscription
    _subscription?.cancel();

    // Subscribe to real-time updates
    _subscription = _service.segmentTimesStream(participantId).listen((times) {
      _segmentTimes = times;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _error = 'Failed to load segment times: $e';
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> recordSegmentTime(SegmentTime segmentTime) async {
    try {
      return await _service.recordSegmentTime(segmentTime);
    } catch (e) {
      _error = 'Failed to record segment time: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
