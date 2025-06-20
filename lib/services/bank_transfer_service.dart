import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_endpoints.dart';

class BankTransferService {
  static final String _baseUrl = ApiEndpoints.bankTransfer;

  static Future<Map<String, dynamic>> submitBankTransfer({
    required int userId,
    required String selectedBank,
    required String accountNumber,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'selected_bank': selectedBank,
        'account_number': accountNumber,
        'amount': amount,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit bank transfer: ${response.body}');
    }
  }
}
