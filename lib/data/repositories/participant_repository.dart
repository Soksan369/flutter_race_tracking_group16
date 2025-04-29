import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/participant.dart';

class ParticipantRepository {
  final String apiBaseUrl = 'https://your-api-url.com/api';
  final http.Client _client;

  ParticipantRepository({http.Client? client})
      : _client = client ?? http.Client();

  // Get participants for a specific segment
  Future<List<Participant>> getParticipantsBySegment(String segment) async {
    try {
      final response = await _client.get(
        Uri.parse('$apiBaseUrl/participants?segment=$segment'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Participant.fromJson(item)).toList();
      } else {
        // In a real app, you'd use proper error handling/logging
        print('Error fetching participants: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching participants: $e');
      return [];
    }
  }

  // Update participant status
  Future<bool> updateParticipantStatus(String id, bool completed) async {
    try {
      final response = await _client.patch(
        Uri.parse('$apiBaseUrl/participants/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'completed': completed}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error updating participant: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating participant: $e');
      return false;
    }
  }
}
