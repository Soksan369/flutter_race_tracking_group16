import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  final String id;
  final int bib;
  final String name;
  final String segment; // run, swim, cycle
  final bool completed;

  Participant({
    required this.id,
    required this.bib,
    required this.name,
    required this.segment,
    required this.completed,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json['id'],
        bib: json['bib'],
        name: json['name'],
        segment: json['segment'],
        completed: json['completed'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'bib': bib,
        'name': name,
        'segment': segment,
        'completed': completed,
      };
}
