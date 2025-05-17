import 'package:flutter/material.dart';
import '../../../data/models/segment_time.dart';
import 'base_track_screen.dart';

class TrackCyclingScreen extends StatefulWidget {
  const TrackCyclingScreen({super.key});

  @override
  State<TrackCyclingScreen> createState() => _TrackCyclingScreenState();
}

class _TrackCyclingScreenState
    extends BaseTrackScreenState<TrackCyclingScreen> {
  @override
  String get title => 'Cycling';

  @override
  IconData get icon => Icons.directions_bike;

  @override
  Segment get segment => Segment.cycle;
}
