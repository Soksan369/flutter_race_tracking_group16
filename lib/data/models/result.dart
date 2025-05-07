class Result {
  final String participantId;
  final int bib;
  final String name;
  final Duration? runTime;
  final Duration? swimTime;
  final Duration? cycleTime;
  final Duration? totalTime;
  final int? rank;

  Result({
    required this.participantId,
    required this.bib,
    required this.name,
    this.runTime,
    this.swimTime,
    this.cycleTime,
    this.totalTime,
    this.rank,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    Duration? parse(String key) {
      final value = json[key];
      if (value == null) return null;
      // Handle both int and double values
      if (value is num) return Duration(seconds: value.toInt());
      return null;
    }

    return Result(
      participantId: json['participantId']?.toString() ?? '',
      bib: (json['bib'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      runTime: parse('runTime'),
      swimTime: parse('swimTime'),
      cycleTime: parse('cycleTime'),
      totalTime: parse('totalTime'),
      rank: json['rank'] != null ? (json['rank'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'bib': bib,
        'name': name,
        'runTime': runTime?.inSeconds,
        'swimTime': swimTime?.inSeconds,
        'cycleTime': cycleTime?.inSeconds,
        'totalTime': totalTime?.inSeconds,
        'rank': rank,
      };
}
