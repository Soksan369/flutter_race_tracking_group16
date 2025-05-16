import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data/models/result.dart';
import '../utils/formatters.dart';

class ResultProvider with ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final String _raceId;

  List<Result> _results = [];
  bool _isLoading = false;
  String? _error;

  // Replace timer with subscription
  StreamSubscription<DatabaseEvent>? _splitsSubscription;
  StreamSubscription<DatabaseEvent>? _participantsSubscription;

  ResultProvider({String raceId = 'race1'}) : _raceId = raceId;

  List<Result> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadResults() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Cancel any existing subscriptions
    _splitsSubscription?.cancel();
    _participantsSubscription?.cancel();

    // Set up real-time streams
    _setupStreams();
  }

  void _setupStreams() {
    final splitsRef = _db.child('races/$_raceId/splits');
    final participantsRef1 = _db.child('races/$_raceId/participants');
    final participantsRef2 = _db.child('participants/$_raceId');

    // Listen for changes to splits data
    _splitsSubscription = splitsRef.onValue.listen((event) {
      _fetchResults();
    }, onError: (error) {
      _error = 'Error loading splits data: $error';
      _isLoading = false;
      notifyListeners();
    });

    // Listen for changes to participants data
    _participantsSubscription = participantsRef1.onValue.listen((event) {
      _fetchResults();
    }, onError: (error) {
      _error = 'Error loading participants data: $error';
      _isLoading = false;
      notifyListeners();
    });

    // Initial fetch
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      // Fetch race data
      final raceSnapshot = await _db.child('races/$_raceId').get();
      if (!raceSnapshot.exists) {
        _error = "No race data found";
        _results = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> raceData;
      try {
        raceData = Map<String, dynamic>.from(raceSnapshot.value as Map);
      } catch (e) {
        _error = "Error parsing race data: $e";
        _results = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Extract splits from race data
      final splits = raceData['splits'] as Map<dynamic, dynamic>? ?? {};

      // Get participants from both locations
      final legacyParticipantsSnapshot =
          await _db.child('participants/$_raceId').get();
      final raceParticipantsSnapshot =
          await _db.child('races/$_raceId/participants').get();

      final results = <Result>[];

      // Process participants from races/race1/participants
      if (raceParticipantsSnapshot.exists) {
        final participants =
            Map<dynamic, dynamic>.from(raceParticipantsSnapshot.value as Map);
        _processParticipants(participants, splits, results);
      }

      // Process participants from participants/race1
      if (legacyParticipantsSnapshot.exists) {
        final participants =
            Map<dynamic, dynamic>.from(legacyParticipantsSnapshot.value as Map);
        _processParticipants(participants, splits, results);
      }

      // Sort by total time and assign ranks
      results.sort((a, b) {
        if (a.totalTime == null && b.totalTime == null) return 0;
        if (a.totalTime == null) return 1;
        if (b.totalTime == null) return -1;
        return a.totalTime!.compareTo(b.totalTime!);
      });

      // Assign ranks only to participants who completed all segments
      int rank = 1;
      for (int i = 0; i < results.length; i++) {
        if (results[i].totalTime != null) {
          final result = results[i];
          results[i] = Result(
            participantId: result.participantId,
            bib: result.bib,
            name: result.name,
            runTime: result.runTime,
            swimTime: result.swimTime,
            cycleTime: result.cycleTime,
            totalTime: result.totalTime,
            rank: rank++,
          );
        }
      }

      _results = results;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load results: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _processParticipants(Map<dynamic, dynamic> participants,
      Map<dynamic, dynamic> splits, List<Result> results) {
    participants.forEach((pid, participantData) {
      try {
        final participant = participantData as Map<dynamic, dynamic>;
        final bib = participant['bib'] as int? ?? 0;
        final name = participant['name'] as String? ?? 'Unknown';

        // Check if this participant has splits data
        Duration? runTime, swimTime, cycleTime, totalTime;

        if (splits.containsKey(pid)) {
          final participantSplits = splits[pid];

          if (participantSplits is Map) {
            // Handle the structure with recordedAt and time fields
            runTime = _extractDuration(participantSplits, 'run');
            swimTime = _extractDuration(participantSplits, 'swim');
            cycleTime = _extractDuration(participantSplits, 'cycle');
          } else {
            // Handle the numeric split times - convert milliseconds to proper Duration
            final runMillis = _getSplitValue(participantSplits, 'run');
            final swimMillis = _getSplitValue(participantSplits, 'swim');
            final cycleMillis = _getSplitValue(participantSplits, 'cycle');

            // Convert to durations
            runTime =
                runMillis != null ? Duration(milliseconds: runMillis) : null;
            swimTime =
                swimMillis != null ? Duration(milliseconds: swimMillis) : null;
            cycleTime = cycleMillis != null
                ? Duration(milliseconds: cycleMillis)
                : null;
          }

          // Calculate total time if all segments completed
          if (runTime != null && swimTime != null && cycleTime != null) {
            totalTime = Duration(
                milliseconds: runTime.inMilliseconds +
                    swimTime.inMilliseconds +
                    cycleTime.inMilliseconds);
          }
        }

        results.add(Result(
          participantId: pid.toString(),
          bib: bib,
          name: name,
          runTime: runTime,
          swimTime: swimTime,
          cycleTime: cycleTime,
          totalTime: totalTime,
          rank: null, // Will be assigned after sorting
        ));
      } catch (e) {
        debugPrint("Error processing participant $pid: $e");
      }
    });
  }

  // Helper method to safely get split values from various formats
  int? _getSplitValue(dynamic splitData, String segment) {
    final value = splitData[segment] ?? splitData['${segment}ing'];
    if (value == null) return null;
    return value is int ? value : (value as num).toInt();
  }

  Duration? _extractDuration(Map<dynamic, dynamic> splitData, String segment) {
    final segmentData = splitData[segment];
    if (segmentData == null) return null;

    if (segmentData is Map) {
      final time = segmentData['time'];
      if (time != null) {
        // Make sure we handle seconds properly
        return Duration(seconds: time is int ? time : (time as num).toInt());
      }

      // Check for millisecond-based time
      final timeMs = segmentData['timeMs'];
      if (timeMs != null) {
        return Duration(
            milliseconds: timeMs is int ? timeMs : (timeMs as num).toInt());
      }
    } else if (segmentData is num) {
      // Assume milliseconds for direct numeric values
      return Duration(milliseconds: segmentData.toInt());
    }

    return null;
  }

  List<Result> getFilteredResults(String search, String category) {
    // If results are empty or loading, return empty list
    if (_results.isEmpty || _isLoading) {
      return [];
    }

    // First filter by category
    List<Result> categoryFiltered;
    if (category == 'All') {
      categoryFiltered = _results;
    } else if (category == 'Running') {
      categoryFiltered = _results.where((r) => r.runTime != null).toList();
    } else if (category == 'Swimming') {
      categoryFiltered = _results.where((r) => r.swimTime != null).toList();
    } else if (category == 'Cycling') {
      categoryFiltered = _results.where((r) => r.cycleTime != null).toList();
    } else {
      categoryFiltered = _results;
    }

    // Then filter by search query if not empty
    if (search.trim().isEmpty) {
      return categoryFiltered;
    }

    final searchLower = search.toLowerCase();
    return categoryFiltered
        .where((r) =>
            r.name.toLowerCase().contains(searchLower) ||
            r.bib.toString().contains(searchLower))
        .toList();
  }

  // Calculate and update result for a specific participant
  Future<bool> calculateAndUpdateResult(String participantId) async {
    try {
      // This method would be called when a participant finishes all segments
      loadResults(); // Refresh results to include the latest
      return true;
    } catch (e) {
      debugPrint('Error calculating result: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _splitsSubscription?.cancel();
    _participantsSubscription?.cancel();
    super.dispose();
  }
}
