import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_endpoints.dart';
import '../models/history.dart';

class HistoryService {
  static final String _baseUrl = ApiEndpoints.history;

  static Future<List<History>> getHistory(String userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?user_id=$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => History.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      throw Exception('Error fetching history: $e');
    }
  }
}
