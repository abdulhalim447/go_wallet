import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_wallet/models/top_notice.dart';

class TopNoticeService {
  static const String _baseUrl = 'https://gowalletapp.com/php/top_notice.php';

  static Future<TopNotice?> getTopNotice() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isNotEmpty) {
          return TopNotice.fromJson(jsonData.first);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching top notice: $e');
    }
  }
}
