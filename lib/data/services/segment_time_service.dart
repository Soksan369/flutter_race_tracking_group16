import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/segment_time.dart';

class SegmentTimeService {
  final String apiBaseUrl = 'https://your-api-url.com/api';
  final http.Client _client;

  SegmentTimeService({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> recordSegmentTime(SegmentTime segmentTime) async {
    try {
      final response = await _client.post(
        Uri.parse('$apiBaseUrl/segment_times'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(segmentTime.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Error recording segment time: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error recording segment time: $e');
      return false;
    }
  }

  Future<List<SegmentTime>> getSegmentTimesForParticipant(
      String participantId) async {
    try {
      final response = await _client.get(
        Uri.parse('$apiBaseUrl/segment_times?participantId=$participantId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => SegmentTime.fromJson(item)).toList();
      } else {
        print('Error fetching segment times: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching segment times: $e');
      return [];
    }
  }
}
