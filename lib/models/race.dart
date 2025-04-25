class Race {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final double distance; // in kilometers
  final List<String> participants; // List of user IDs or names

  Race({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.distance,
    required this.participants,
  });

  // Factory constructor to create a Race from JSON
  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      distance: (json['distance'] as num).toDouble(),
      participants: List<String>.from(json['participants'] ?? []),
    );
  }

  // Convert Race to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'distance': distance,
      'participants': participants,
    };
  }
}