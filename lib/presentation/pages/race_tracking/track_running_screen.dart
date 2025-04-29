import 'package:flutter/material.dart';
import '../../../data/models/segment_time.dart';
import 'base_track_screen.dart';

class TrackRunningScreen extends StatefulWidget {
  const TrackRunningScreen({super.key});

  @override
  State<TrackRunningScreen> createState() => _TrackRunningScreenState();
}

class _TrackRunningScreenState
    extends BaseTrackScreenState<TrackRunningScreen> {
  @override
  String get title => 'Running';

  @override
  IconData get icon => Icons.directions_run;

  @override
  Segment get segment => Segment.run;
}
