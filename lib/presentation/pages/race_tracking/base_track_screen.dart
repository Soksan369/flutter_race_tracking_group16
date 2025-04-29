import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models/participant.dart';
import '../../../data/models/segment_time.dart';
import '../../../data/repositories/participant_repository.dart';
import '../../../data/services/segment_time_service.dart';
import '../../../data/services/participant_progression_service.dart';
import '../../../services/navigation_service.dart';
import '../../../services/timer_service.dart';
import '../../widgets/timer_section.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/participants_section.dart';
import '../../widgets/race_navigation_bar.dart';

abstract class BaseTrackScreenState<T extends StatefulWidget> extends State<T> {
  // Services
  late final TimerService _timerService;
  late final ParticipantRepository _participantRepo;
  late final SegmentTimeService _segmentTimeService;
  late final ParticipantProgressionService _progressionService;

  // Participants list
  List<Participant> _participants = [];
  List<Participant> _filteredParticipants = [];

  // Search functionality
  final TextEditingController _searchController = TextEditingController();

  // Abstract properties
  String get title;
  IconData get icon;
  Segment get segment;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService();
    _participantRepo = ParticipantRepository();
    _segmentTimeService = SegmentTimeService();
    _progressionService =
        ParticipantProgressionService(participantRepo: _participantRepo);

    _loadParticipants();
    _searchController.addListener(_filterParticipants);
  }

  void _filterParticipants() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredParticipants = List.from(_participants);
      } else {
        _filteredParticipants = _participants
            .where((p) =>
                p.name.toLowerCase().contains(query) ||
                p.bib.toString().contains(query))
            .toList();
      }
    });
  }

  Future<void> _loadParticipants() async {
    // For now, let's use dummy data since we might not have backend setup
    final participants = List.generate(
      6,
      (index) => Participant(
        id: '101${index}',
        bib: 101 + index,
        name: 'Sok Sothy ${index + 1}',
        segment: segment.toString().split('.').last,
        completed: false,
      ),
    );

    setState(() {
      _participants = participants;
      _filteredParticipants = List.from(participants);
    });
  }

  void _markParticipantCompleted(String participantId) async {
    final index = _participants.indexWhere((p) => p.id == participantId);
    if (index == -1) return;

    // Get participant
    final participant = _participants[index];

    // Record segment time
    await _recordSegmentTime(participant.id);

    // Move to next segment
    final updatedParticipant = await _progressionService.moveToNextSegment(
        participant, _timerService.elapsed);

    if (updatedParticipant != null) {
      setState(() {
        // Remove from current list
        _participants.removeAt(index);
        _filteredParticipants = List.from(_participants);

        // Show transition message
        _showTransitionMessage(participant, updatedParticipant);
      });
    }
  }

  Future<void> _recordSegmentTime(String participantId) async {
    // In a real app, you'd save this to your database
    final segmentTime = SegmentTime(
      participantId: participantId,
      segment: segment,
      time: _timerService.elapsed,
      recordedAt: DateTime.now(),
    );

    // For now just log it
    debugPrint('Recorded segment time: ${segmentTime.toJson()}');
  }

  void _showTransitionMessage(
      Participant oldParticipant, Participant updatedParticipant) {
    final String nextSegmentName;

    if (updatedParticipant.segment == 'swim') {
      nextSegmentName = 'Swimming';
    } else if (updatedParticipant.segment == 'cycle') {
      nextSegmentName = 'Cycling';
    } else {
      // All segments completed - show immediate toast
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Hide any existing snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${oldParticipant.name} has completed all segments'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          duration: const Duration(seconds: 1), // Shorter duration
          animation: null, // Remove animation for immediate appearance
        ),
      );
      return;
    }

    // Show immediate notification
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // Hide any existing snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${oldParticipant.name} moved to $nextSegmentName'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 800), // Very short duration
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        animation: null, // Remove animation for immediate appearance
      ),
    );
  }

  void navigateToPage(int index) {
    if ((index == 0 && segment == Segment.run) ||
        (index == 1 && segment == Segment.swim) ||
        (index == 2 && segment == Segment.cycle)) {
      return;
    }

    String route = NavigationService.getRouteForIndex(index);
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    _timerService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header section with title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$title ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, size: 22),
              ],
            ),
            const SizedBox(height: 24),
            // Timer display and controls
            AnimatedBuilder(
              animation: _timerService,
              builder: (context, _) {
                return TimerSection(
                  elapsed: _timerService.elapsed,
                  isRunning: _timerService.isRunning,
                  onStartStop: _timerService.toggle,
                  onReset: _timerService.reset,
                );
              },
            ),
            const SizedBox(height: 24),
            // Search bar
            SearchBarWidget(controller: _searchController),
            const SizedBox(height: 16),
            // Participants list
            ParticipantsSection(
              participants: _filteredParticipants,
              onComplete: _markParticipantCompleted,
            ),
          ],
        ),
      ),
      bottomNavigationBar: RaceNavigationBar(
        currentIndex: NavigationService.getNavigationIndex(segment),
        onTap: navigateToPage,
      ),
    );
  }
}
