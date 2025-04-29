import 'package:flutter/material.dart';
import '../../../data/models/segment_time.dart';
import 'base_track_screen.dart';

class TrackSwimmingScreen extends StatefulWidget {
  const TrackSwimmingScreen({super.key});

  @override
  State<TrackSwimmingScreen> createState() => _TrackSwimmingScreenState();
}

class _TrackSwimmingScreenState
    extends BaseTrackScreenState<TrackSwimmingScreen> {
  @override
  String get title => 'Swimming';

  @override
  IconData get icon => Icons.pool;

  @override
  Segment get segment => Segment.swim;
}
