import 'package:cloud_firestore/cloud_firestore.dart';

class SegmentTime {
  final String participantId;
  final String segment; // run, swim, cycle
  final Duration time;
  final DateTime recordedAt;

  SegmentTime({
    required this.participantId,
    required this.segment,
    required this.time,
    required this.recordedAt,
  });

  factory SegmentTime.fromJson(Map<String, dynamic> json) => SegmentTime(
        participantId: json['participantId'],
        segment: json['segment'],
        time: Duration(seconds: json['time']),
        recordedAt: (json['recordedAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'segment': segment,
        'time': time.inSeconds,
        'recordedAt': Timestamp.fromDate(recordedAt),
      };
}
