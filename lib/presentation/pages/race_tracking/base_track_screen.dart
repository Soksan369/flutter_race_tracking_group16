import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/participant.dart';
import '../../../data/models/segment_time.dart';
import '../../../services/navigation_service.dart';
import '../../../providers/participant_provider.dart';
import '../../../providers/timer_provider.dart';
import '../../../providers/segment_time_provider.dart';
import '../../../providers/result_provider.dart';
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
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Load participants when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadParticipants();
    });

    // Set up polling for updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        _loadParticipants();
      }
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _loadParticipants() {
    final segmentString = segment.toString().split('.').last;
    Provider.of<ParticipantProvider>(context, listen: false)
      .loadParticipantsBySegment(segmentString);
  }

  Future<void> _completeParticipantSegment(String id) async {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final participantProvider = Provider.of<ParticipantProvider>(context, listen: false);
    final segmentTimeProvider = Provider.of<SegmentTimeProvider>(context, listen: false);
    final resultProvider = Provider.of<ResultProvider>(context, listen: false);

    // Record current segment time
    final currentTime = timerProvider.recordCurrentTime();

    // Record segment time in database
    final segmentTime = SegmentTime(
      participantId: id,
      segment: segment,
      time: currentTime,
      recordedAt: DateTime.now(),
    );
    await segmentTimeProvider.recordSegmentTime(segmentTime);

    // Update participant and move to next segment
    final updatedParticipant = await participantProvider.completeSegment(id, currentTime);

    if (updatedParticipant != null) {
      // Show transition message
      _showTransitionMessage(id, updatedParticipant.segment);

      // If all segments are completed, calculate final result
      if (updatedParticipant.isAllSegmentsCompleted) {
        await resultProvider.calculateAndUpdateResult(id);
      }
    }
  }

  void _showTransitionMessage(String participantId, String nextSegment) {
    final participantProvider =
        Provider.of<ParticipantProvider>(context, listen: false);
    final participants = participantProvider.participants;
    final name = participants
        .firstWhere((p) => p.id == participantId,
            orElse: () => Participant(
                id: '',
                bib: 0,
                name: 'Participant',
                segment: '',
                completed: false))
        .name;

    final nextSegmentName = nextSegment == 'swim' ? 'Swimming' : nextSegment == 'cycle' ? 'Cycling' : 'Finished';

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name moved to $nextSegmentName'),
        backgroundColor: nextSegmentName == 'Finished' ? Colors.green : Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToPage(int index) {
    final currentIndex = NavigationService.getNavigationIndex(segment);
    if (index == currentIndex) return;

    Navigator.pushReplacementNamed( context, NavigationService.getRouteForIndex(index));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshTimer?.cancel();
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
            Consumer<TimerProvider>(
              builder: (context, timerProvider, _) {
                return TimerSection(
                  elapsed: timerProvider.elapsed,
                  isRunning: timerProvider.isRunning,
                  onStartStop: timerProvider.toggle,
                  onReset: timerProvider.reset,
                );
              },
            ),

            const SizedBox(height: 24),

            // Search bar
            SearchBarWidget(controller: _searchController),

            const SizedBox(height: 16),

            // Participants list
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
                            onPressed: _loadParticipants,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredParticipants =
                    participantProvider.getFilteredParticipants(_searchQuery);

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
