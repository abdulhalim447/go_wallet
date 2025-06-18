import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_wallet/models/history.dart';

class HistoryService {
  static const String _baseUrl = 'https://gowalletapp.com/php/history.php';

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
