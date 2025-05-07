import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data/models/result.dart';

class ResultProvider with ChangeNotifier {
  final _db = FirebaseDatabase.instance.ref();
  final String _raceId = 'race1';

  List<Result> _results = [];
  bool _isLoading = false;
  String? _error;

  List<Result> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadResults() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint("Fetching race data from Firebase...");

      // Get participants data to combine with splits data
      final raceSnapshot = await _db.child('races/$_raceId').get();

      if (!raceSnapshot.exists) {
        debugPrint("No race data found");
        _error = "No race data found";
        _results = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final raceData = raceSnapshot.value as Map<dynamic, dynamic>;

      // Get both participant sources - they might exist in either location
      Map<String, dynamic> participants = {};

      // 1. Get participants from races/race1/participants
      if (raceData.containsKey('participants')) {
        final raceParticipants =
            raceData['participants'] as Map<dynamic, dynamic>;
        raceParticipants.forEach((key, value) {
          participants[key.toString()] = value;
        });
      }

      // 2. Also check participants/race1 - as seen in your database export
      final participantsSnapshot =
          await _db.child('participants/$_raceId').get();
      if (participantsSnapshot.exists) {
        final participantsData =
            participantsSnapshot.value as Map<dynamic, dynamic>;
        participantsData.forEach((key, value) {
          // Only add if it's a map structure
          if (value is Map) {
            participants[key.toString()] = value;
          }
        });
      }

      // Get splits data
      final splits = raceData.containsKey('splits')
          ? raceData['splits'] as Map<dynamic, dynamic>
          : {};

      debugPrint("Participants data: ${participants.length} entries");
      debugPrint("Splits data: ${splits.length} entries");

      final results = <Result>[];

      // Process each participant
      participants.forEach((pid, participantData) {
        try {
          final participant = participantData as Map<dynamic, dynamic>;
          final bib = participant['bib'] as int;
          final name = participant['name'] as String;

          // Check if this participant has splits data
          Duration? runTime, swimTime, cycleTime, totalTime;

          if (splits.containsKey(pid)) {
            final participantSplits = splits[pid] as Map<dynamic, dynamic>;

            // Handle both naming conventions
            final runMillis =
                participantSplits['run'] ?? participantSplits['running'];
            final swimMillis =
                participantSplits['swim'] ?? participantSplits['swimming'];
            final cycleMillis =
                participantSplits['cycle'] ?? participantSplits['cycling'];

            // Convert to actual segment durations
            // Running time is from race start (0) to running completion
            runTime = runMillis != null
                ? Duration(
                    milliseconds: runMillis is int
                        ? runMillis
                        : (runMillis as double).toInt())
                : null;

            // Swimming duration is swimming timestamp minus running timestamp
            if (swimMillis != null && runMillis != null) {
              final swimMs = swimMillis is int
                  ? swimMillis
                  : (swimMillis as double).toInt();
              final runMs =
                  runMillis is int ? runMillis : (runMillis as double).toInt();
              swimTime = Duration(milliseconds: swimMs - runMs);
            }

            // Cycling duration is cycling timestamp minus swimming timestamp
            if (cycleMillis != null && swimMillis != null) {
              final cycleMs = cycleMillis is int
                  ? cycleMillis
                  : (cycleMillis as double).toInt();
              final swimMs = swimMillis is int
                  ? swimMillis
                  : (swimMillis as double).toInt();
              cycleTime = Duration(milliseconds: cycleMs - swimMs);
            }

            // Calculate total time if all segments are completed
            if (runTime != null && swimTime != null && cycleTime != null) {
              totalTime = Duration(
                  microseconds: runTime.inMicroseconds +
                      swimTime.inMicroseconds +
                      cycleTime.inMicroseconds);
            }

            debugPrint(
                "Processing splits for $name (#$bib): Run=${formatDuration(runTime)}, Swim=${formatDuration(swimTime)}, Cycle=${formatDuration(cycleTime)}");
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
          debugPrint("Ranked ${results[i].name} as #${results[i].rank}");
        }
      }

      debugPrint("Finished processing ${results.length} results");
      _results = results;
    } catch (e) {
      _error = 'Failed to load results: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Result> getFilteredResults(String query, String category) {
    return _results.where((r) {
      // Search query filtering
      final matchesQuery = query.isEmpty ||
          r.name.toLowerCase().contains(query.toLowerCase()) ||
          r.bib.toString().contains(query);

      // Category filtering
      bool matchesCategory = true;
      if (category != 'All') {
        switch (category) {
          case 'Running':
            matchesCategory = r.runTime != null;
            break;
          case 'Swimming':
            matchesCategory = r.swimTime != null;
            break;
          case 'Cycling':
            matchesCategory = r.cycleTime != null;
            break;
        }
      }

      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<void> calculateAndUpdateResult(String participantId) async {
    // This will be triggered when all segments are complete
    // For now, just reload results to get the latest data
    await loadResults();
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return '-';
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
