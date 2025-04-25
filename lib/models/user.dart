class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl; // Optional profile picture
  final double? totalDistance; // Optional: total distance run

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.totalDistance,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalDistance: (json['totalDistance'] as num?)?.toDouble(),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'totalDistance': totalDistance,
    };
  }
}