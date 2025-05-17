import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService with ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  DateTime? _startTime;
  DateTime? _pauseTime;
  Duration _pausedDuration = Duration.zero;

  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;

    // If continuing from pause
    if (_pauseTime != null) {
      _pausedDuration += DateTime.now().difference(_pauseTime!);
      _pauseTime = null;
    } else {
      // Fresh start
      _startTime = DateTime.now();
      _pausedDuration = Duration.zero;
    }

    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _updateElapsed();
    });

    _isRunning = true;
    notifyListeners();
  }

  void _updateElapsed() {
    if (_startTime != null) {
      _elapsed = DateTime.now().difference(_startTime!) - _pausedDuration;
      notifyListeners();
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _pauseTime = DateTime.now();
    notifyListeners();
  }

  void reset() {
    stop();
    _elapsed = Duration.zero;
    _startTime = null;
    _pauseTime = null;
    _pausedDuration = Duration.zero;
    notifyListeners();
  }

  void toggle() {
    if (_isRunning) {
      stop();
    } else {
      start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
