import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data/repositories/timer_repository.dart';

class RaceTimerProvider with ChangeNotifier {
  final TimerRepository repository;

  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  StreamSubscription<DateTime?>? _subscription;

  RaceTimerProvider({required this.repository}) {
    // Initialize subscription on creation
    _initializeSubscription();
  }

  void _initializeSubscription() {
    // Cancel any existing subscription
    _subscription?.cancel();

    // Listen for remote startTime - this ensures all devices stay in sync
    _subscription = repository.startTimeStream().listen((serverTime) {
      if (serverTime != null) {
        _startTime = serverTime;

        // Only start the timer if it's not already running
        if (!_isRunning) {
          _startTimer();
        }
      }
    });
  }

  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  // Initialize - check if race is already started
  Future<void> initialize() async {
    // No additional initialization needed - subscription is set up in constructor
    debugPrint('Timer initialized, waiting for start event');
  }

  // Start race timer - called from home screen
  Future<void> startRace() async {
    // First reset everything
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;
    _isRunning = false;

    // Reset all participants to running segment before starting a new race
    await _resetParticipantsToRunning();

    // Now set the new start time
    _startTime = DateTime.now();

    try {
      // Save start time to Firebase - all devices will get this update
      await repository.setStartTime(_startTime!);
      notifyListeners();
      // Local timer will be started by the subscription
    } catch (e) {
      debugPrint('Error starting race: $e');
    }
  }

  // Helper method to reset all participants back to running segment
  Future<void> _resetParticipantsToRunning() async {
    try {
      // Reset race data in Firebase
      await repository.resetRaceData();

      // Reset participants back to running segment
      final participants1Ref =
          FirebaseDatabase.instance.ref().child('participants/race1');
      final participants2Ref =
          FirebaseDatabase.instance.ref().child('races/race1/participants');

      // Reset participants in participants/race1
      final snapshot1 = await participants1Ref.get();
      if (snapshot1.exists) {
        final participants = Map<dynamic, dynamic>.from(snapshot1.value as Map);
        for (var pid in participants.keys) {
          await participants1Ref.child(pid.toString()).update({
            'segment': 'run',
            'completed': false,
            'completedSegments': {'run': false, 'swim': false, 'cycle': false}
          });
        }
      }

      // Also reset participants in races/race1/participants
      final snapshot2 = await participants2Ref.get();
      if (snapshot2.exists) {
        final participants = Map<dynamic, dynamic>.from(snapshot2.value as Map);
        for (var pid in participants.keys) {
          await participants2Ref.child(pid.toString()).update({
            'segment': 'run',
            'completed': false,
            'completedSegments': {'run': false, 'swim': false, 'cycle': false}
          });
        }
      }
    } catch (e) {
      debugPrint('Error resetting participants: $e');
    }
  }

  // Reset race timer
  Future<void> resetRace() async {
    try {
      // Reset local state
      _timer?.cancel();
      _timer = null;
      _startTime = null;
      _elapsed = Duration.zero;
      _isRunning = false;

      // Reset all data including participants
      await _resetParticipantsToRunning();

      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting race: $e');
    }
  }

  void _startTimer() {
    if (_startTime == null) return;

    _isRunning = true;

    // Initial calculation
    _updateElapsed();

    // Regular updates - more frequent for smoother UI
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _updateElapsed();
    });

    notifyListeners();
  }

  void _updateElapsed() {
    if (_startTime != null) {
      _elapsed = DateTime.now().difference(_startTime!);
      notifyListeners();
    }
  }

  // Get current elapsed time (for segment completion)
  Duration getCurrentTime() {
    return _elapsed;
  }

  // Record a split time for a participant
  Future<bool> recordSplit(String participantId, String segment) async {
    try {
      await repository.recordSplit(
        participantId: participantId,
        segment: segment,
        elapsedMs: _elapsed.inMilliseconds,
      );
      return true;
    } catch (e) {
      debugPrint('Error recording split: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
