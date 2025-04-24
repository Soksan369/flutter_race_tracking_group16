import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String participantId;
  final int bib;
  final String name;
  final Duration totalTime;
  final int rank;

  Result({
    required this.participantId,
    required this.bib,
    required this.name,
    required this.totalTime,
    required this.rank,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        participantId: json['participantId'],
        bib: json['bib'],
        name: json['name'],
        totalTime: Duration(seconds: json['totalTime']),
        rank: json['rank'],
      );

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'bib': bib,
        'name': name,
        'totalTime': totalTime.inSeconds,
        'rank': rank,
      };
}
