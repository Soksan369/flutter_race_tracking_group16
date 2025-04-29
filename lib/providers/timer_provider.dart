import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;

  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _elapsed += const Duration(milliseconds: 100);
      notifyListeners();
    });

    _isRunning = true;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    stop();
    _elapsed = Duration.zero;
    notifyListeners();
  }

  void toggle() {
    if (_isRunning) {
      stop();
    } else {
      start();
    }
  }

  Duration recordCurrentTime() {
    return _elapsed;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
