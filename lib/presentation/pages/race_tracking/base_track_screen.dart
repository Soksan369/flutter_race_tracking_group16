import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models/participant.dart';
import '../../../data/models/segment_time.dart';
import '../../../data/repositories/participant_repository.dart';
import '../../../data/services/segment_time_service.dart';
import '../../widgets/timer_display.dart';
import '../../widgets/participant_list_item.dart';

abstract class BaseTrackScreenState<T extends StatefulWidget> extends State<T> {
  // Timer variables
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;

  // Participants list
  List<Participant> _participants = [];
  List<Participant> _filteredParticipants = [];

  // Search functionality
  final TextEditingController _searchController = TextEditingController();

  // Services
  late final ParticipantRepository _participantRepo;
  late final SegmentTimeService _segmentTimeService;

  // Abstract properties
  String get title;
  IconData get icon;
  Segment get segment;

  @override
  void initState() {
    super.initState();
    _participantRepo = ParticipantRepository();
    _segmentTimeService = SegmentTimeService();
    _loadParticipants();

    // Add listener for search functionality
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
    // In a real app, you would do:
    // final participants = await _participantRepo.getParticipantsBySegment(segment.toString().split('.').last);
    final participants = List.generate(
      6,
      (index) => Participant(
        id: '101',
        bib: 101,
        name: 'Sok Sothy',
        segment: segment.toString().split('.').last,
        completed: false,
      ),
    );

    setState(() {
      _participants = participants;
      _filteredParticipants = List.from(participants);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _elapsed += const Duration(milliseconds: 100);
      });
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _elapsed = Duration.zero;
    });
  }

  void _markParticipantCompleted(String participantId) {
    setState(() {
      final index = _participants.indexWhere((p) => p.id == participantId);
      if (index != -1) {
        // In a real app, you'd update this in your database
        final participant = _participants[index];
        _participants[index] = Participant(
          id: participant.id,
          bib: participant.bib,
          name: participant.name,
          segment: participant.segment,
          completed: true,
        );

        // Record segment time
        _recordSegmentTime(participant.id);
      }
    });
  }

  void _recordSegmentTime(String participantId) {
    // In a real app, you'd save this to your database
    final segmentTime = SegmentTime(
      participantId: participantId,
      segment: segment,
      time: _elapsed,
      recordedAt: DateTime.now(),
    );

    // For now just log it
    debugPrint('Recorded segment time: ${segmentTime.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Title
            _buildHeaderSection(),
            const SizedBox(height: 24),
            // Timer display
            _buildTimerSection(),
            const SizedBox(height: 24),
            // Search bar
            _buildSearchBar(),
            const SizedBox(height: 16),
            // Participants list
            _buildParticipantsSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
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
    );
  }

  Widget _buildTimerSection() {
    return Column(
      children: [
        // Timer display
        TimerDisplay(duration: _elapsed, fontSize: 52),

        const SizedBox(height: 20),

        // Timer controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _isRunning ? _stopTimer : _startTimer,
              icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
              label: Text(_isRunning ? 'Stop' : 'Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRunning
                    ? const Color(0xFFFF3B30)
                    : const Color(0xFF4CD964),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(100, 45),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _resetTimer,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(100, 45),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[500]),
              onPressed: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Participant',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredParticipants.length,
              itemBuilder: (context, index) {
                final participant = _filteredParticipants[index];
                return ParticipantListItem(
                  participant: participant,
                  onComplete: () => _markParticipantCompleted(participant.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: getNavigationIndex(),
      onTap: (index) => navigateToPage(index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'Running',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pool),
          label: 'Swimming',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bike),
          label: 'Cycling',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Results',
        ),
      ],
    );
  }

  int getNavigationIndex() {
    switch (segment) {
      case Segment.run:
        return 0;
      case Segment.swim:
        return 1;
      case Segment.cycle:
        return 2;
      default:
        return 0;
    }
  }

  void navigateToPage(int index) {
    if ((index == 0 && segment == Segment.run) ||
        (index == 1 && segment == Segment.swim) ||
        (index == 2 && segment == Segment.cycle)) {
      return;
    }

    String route;
    switch (index) {
      case 0:
        route = '/running';
        break;
      case 1:
        route = '/swimming';
        break;
      case 2:
        route = '/cycling';
        break;
      case 3:
        route = '/result';
        break;
      default:
        route = '/';
    }

    Navigator.pushReplacementNamed(context, route);
  }
}
