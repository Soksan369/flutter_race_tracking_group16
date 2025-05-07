class Participant {
  final String id;
  final int bib;
  final String name;
  final String segment; // run, swim, cycle
  final bool completed;
  final Map<String, bool>
      completedSegments; // Track completion status for each segment

  Participant({
    required this.id,
    required this.bib,
    required this.name,
    required this.segment,
    required this.completed,
    Map<String, bool>? completedSegments,
  }) : completedSegments = completedSegments ??
            {
              'run': false,
              'swim': false,
              'cycle': false,
            };

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json['id'] ?? '', // Add null safety
        bib: (json['bib'] ?? 0) as int, // Add null safety and ensure int type
        name: json['name'] ?? 'Unknown', // Add null safety
        segment:
            json['segment'] ?? 'run', // Add null safety with default segment
        completed: json['completed'] ?? false, // Add null safety
        completedSegments: json['completedSegments'] != null
            ? Map<String, bool>.from(json['completedSegments'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'bib': bib,
        'name': name,
        'segment': segment,
        'completed': completed,
        'completedSegments': completedSegments,
      };

  // Create a copy of this participant with updated properties
  Participant copyWith({
    String? id,
    int? bib,
    String? name,
    String? segment,
    bool? completed,
    Map<String, bool>? completedSegments,
  }) {
    return Participant(
      id: id ?? this.id,
      bib: bib ?? this.bib,
      name: name ?? this.name,
      segment: segment ?? this.segment,
      completed: completed ?? this.completed,
      completedSegments:
          completedSegments ?? Map<String, bool>.from(this.completedSegments),
    );
  }

  // Check if all segments are completed
  bool get isAllSegmentsCompleted =>
      completedSegments['run'] == true &&
      completedSegments['swim'] == true &&
      completedSegments['cycle'] == true;

  // Get next segment after current one
  String? getNextSegment() {
    if (segment == 'run') return 'swim';
    if (segment == 'swim') return 'cycle';
    return null; // No next segment after cycling
  }
}
