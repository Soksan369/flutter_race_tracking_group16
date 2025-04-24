import 'package:cloud_firestore/cloud_firestore.dart';

class Race {
  final String id;
  final String name;
  final DateTime startTime;
  final String status; // NotStarted, Started, Finished

  Race({
    required this.id,
    required this.name,
    required this.startTime,
    required this.status,
  });

  factory Race.fromJson(Map<String, dynamic> json) => Race(
        id: json['id'],
        name: json['name'],
        startTime: (json['startTime'] as Timestamp).toDate(),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startTime': Timestamp.fromDate(startTime),
        'status': status,
      };
}
