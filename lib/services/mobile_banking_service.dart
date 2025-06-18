import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_wallet/models/user_session.dart';

class MobileBankingService {
  static const String _baseUrl =
      'https://gowalletapp.com/php/mobile_banking/mobile_banking.php';

  static Future<Map<String, dynamic>> submitTransaction({
    required String operator,
    required String type,
    required String number,
    required double balance,
  }) async {
    try {
      final userId = await UserSession.getUserId();

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
          'operator': operator,
          'type': type,
          'number': number,
          'balance': balance,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201 && jsonResponse['status'] == 'success') {
        return {'success': true, 'message': jsonResponse['message']};
      } else {
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'Transaction failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.'
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final userId = await UserSession.getUserId();

      final response = await http.get(
        Uri.parse('$_baseUrl?user_id=$userId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        return List<Map<String, dynamic>>.from(jsonResponse['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
