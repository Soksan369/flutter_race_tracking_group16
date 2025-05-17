import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/participant.dart';
import '../../../data/models/segment_time.dart';
import '../../../services/navigation_service.dart';
import '../../../providers/participant_provider.dart';
import '../../../providers/result_provider.dart';
import '../../../providers/race_timer_provider.dart';
import '../../widgets/timer_section.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/participants_section.dart';
import '../../widgets/race_navigation_bar.dart';

abstract class BaseTrackScreenState<T extends StatefulWidget> extends State<T> {
  // Abstract properties
  String get title;
  IconData get icon;
  Segment get segment;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Load participants when screen initializes - now using streams
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  void _initializeScreen() {
    // Subscribe to participants for this segment
    final segmentString = segment.toString().split('.').last;
    Provider.of<ParticipantProvider>(context, listen: false)
        .loadParticipantsBySegment(segmentString);

    // Make sure timer is still running when coming to this screen
    final raceTimerProvider =
        Provider.of<RaceTimerProvider>(context, listen: false);
    if (!raceTimerProvider.isRunning) {
      raceTimerProvider.initialize();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _completeParticipantSegment(String id) async {
    final raceTimerProvider =
        Provider.of<RaceTimerProvider>(context, listen: false);
    final participantProvider =
        Provider.of<ParticipantProvider>(context, listen: false);
    final resultProvider = Provider.of<ResultProvider>(context, listen: false);

    // Get the segment string (run, swim, cycle) from the enum
    final segmentString = segment.toString().split('.').last;

    // Record split time in Firebase using the repository
    final success = await raceTimerProvider.recordSplit(id, segmentString);

    if (!success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to record time. Please try again.')),
        );
      }
      return;
    }

    // Record current segment time for this participant
    final currentTime = raceTimerProvider.getCurrentTime();

    // Update participant and move to next segment
    final updatedParticipant =
        await participantProvider.completeSegment(id, currentTime);

    if (updatedParticipant != null) {
      // If all segments are completed and we're in cycling screen
      if (updatedParticipant.isAllSegmentsCompleted &&
          segment == Segment.cycle) {
        // Calculate final result without showing any notification
        await resultProvider.calculateAndUpdateResult(id);
        // Participant is already removed from the list by the stream update
      } else {
        // For run and swim segments, or if somehow cycling isn't complete yet
        _showTransitionMessage(id, updatedParticipant.segment);
      }
    }
  }

  void _showTransitionMessage(String participantId, String nextSegment) {
    final participantProvider =
        Provider.of<ParticipantProvider>(context, listen: false);
    final participants = participantProvider.participants;
    final participant = participants.firstWhere((p) => p.id == participantId,
        orElse: () => Participant(
            id: '',
            bib: 0,
            name: 'Participant',
            segment: '',
            completed: false));

    final name = participant.name;
    final nextSegmentName = nextSegment == 'swim'
        ? 'Swimming'
        : nextSegment == 'cycle'
            ? 'Cycling'
            : 'Finished';

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$name completed ${_getSegmentDisplayName()}. Next: $nextSegmentName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getSegmentDisplayName() {
    switch (segment) {
      case Segment.run:
        return 'Running';
      case Segment.swim:
        return 'Swimming';
      case Segment.cycle:
        return 'Cycling';
      // ignore: unreachable-switch-default
      default:
        return 'Segment';
    }
  }

  void _navigateToPage(int index) {
    final route = NavigationService.getRouteForIndex(index);
    if (route != null && ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  void dispose() {
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

            // Timer display - using synchronized race timer
            Consumer<RaceTimerProvider>(
              builder: (context, raceTimerProvider, _) {
                return TimerSection(
                  elapsed: raceTimerProvider.elapsed,
                  isRunning: raceTimerProvider.isRunning,
                  // Don't allow stopping the timer during the race
                  mode: TimerMode.viewOnly,
                );
              },
            ),

            const SizedBox(height: 24),

            // Search bar
            SearchBarWidget(controller: _searchController),

            const SizedBox(height: 16),

            // Participants list - now using Consumer for automatic updates
            Consumer<ParticipantProvider>(
              builder: (context, participantProvider, _) {
                if (participantProvider.isLoading) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (participantProvider.error != null) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            participantProvider.error!,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _initializeScreen,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredParticipants = participantProvider
                    .getFilteredParticipants(_searchQuery)
                    .where((p) =>
                        segment != Segment.cycle || !p.isAllSegmentsCompleted)
                    .toList();

                if (filteredParticipants.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text('No participants found'),
                    ),
                  );
                }

                return ParticipantsSection(
                  participants: filteredParticipants,
                  onComplete: _completeParticipantSegment,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: RaceNavigationBar(
        currentIndex: NavigationService.getNavigationIndex(segment),
        onTap: _navigateToPage,
      ),
    );
  }
}
