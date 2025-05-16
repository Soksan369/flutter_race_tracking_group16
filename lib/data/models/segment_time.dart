enum Segment { run, swim, cycle, result }

class SegmentTime {
  final String participantId;
  final Segment segment;
  final Duration time;
  final DateTime recordedAt;

  SegmentTime({
    required this.participantId,
    required this.segment,
    required this.time,
    required this.recordedAt,
  });

  factory SegmentTime.fromJson(Map<String, dynamic> json) {
    try {
      return SegmentTime(
        participantId: json['participantId'],
        segment: Segment.values
            .firstWhere((e) => e.toString().split('.').last == json['segment']),
        time: Duration(seconds: json['time']),
        recordedAt: DateTime.parse(json['recordedAt']),
      );
    } catch (e) {
      throw FormatException('Invalid JSON format for SegmentTime: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'segment': segment.toString().split('.').last,
        'time': time.inSeconds,
        'recordedAt': recordedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SegmentTime &&
          runtimeType == other.runtimeType &&
          participantId == other.participantId &&
          segment == other.segment &&
          time == other.time &&
          recordedAt == other.recordedAt;

  @override
  int get hashCode =>
      participantId.hashCode ^
      segment.hashCode ^
      time.hashCode ^
      recordedAt.hashCode;

  SegmentTime copyWith({
    String? participantId,
    Segment? segment,
    Duration? time,
    DateTime? recordedAt,
  }) {
    return SegmentTime(
      participantId: participantId ?? this.participantId,
      segment: segment ?? this.segment,
      time: time ?? this.time,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}
