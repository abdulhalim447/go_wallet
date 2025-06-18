import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_wallet/models/notice.dart';

class NoticeService {
  static const String _baseUrl = 'https://gowalletapp.com/php/notice.php';

  static Future<List<Notice>> getNotices() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          if (responseData.containsKey('data')) {
            final List<dynamic> noticesJson = responseData['data'];
            return noticesJson.map((json) => Notice.fromJson(json)).toList();
          }
        }
        return [];
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching notices: $e');
    }
  }
}
