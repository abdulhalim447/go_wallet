import 'dart:convert';
import 'package:http/http.dart' as http;

class SupportService {
  static const String _baseUrl = 'https://gowalletapp.com/php/support.php';

  static Future<Map<String, dynamic>> submitSupportRequest({
    required int userId,
    required String category,
    required String title,
    required String description,
    required String email,
    required bool urgency,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'category': category,
        'title': title,
        'description': description,
        'email': email,
        'urgency': urgency ? 'urgent' : 'normal',
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit support request: ${response.body}');
    }
  }
}
