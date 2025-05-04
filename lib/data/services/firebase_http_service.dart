import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseHttpService {
  final String _baseUrl;
  final http.Client _client;

  FirebaseHttpService({
    String? baseUrl,
    http.Client? client,
  })  : _baseUrl = baseUrl ?? 'https://flutter-fire-base-2ac06-default-rtdb.asia-southeast1.firebasedatabase.app/', _client = client ?? http.Client();

  Future<dynamic> get(String path) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl$path.json'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        if (response.body == 'null') return {};
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> post( String path, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl$path.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {'id': responseData['name'], ...data};
      } else {
        throw Exception('Failed to create data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> patch(String path, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch(
        Uri.parse('$_baseUrl$path.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> put(String path, Map<String, dynamic> data) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl$path.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to replace data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> delete(String path) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl$path.json'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
