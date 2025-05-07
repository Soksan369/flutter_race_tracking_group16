import 'dart:async';
import 'package:flutter/foundation.dart';
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
    if (_isRunning) return;

    _startTime = DateTime.now();
    try {
      // Save start time to Firebase - all devices will get this update
      await repository.setStartTime(_startTime!);
      // Local timer will be started by the subscription
    } catch (e) {
      debugPrint('Error starting race: $e');
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
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
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
