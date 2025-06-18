import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_wallet/models/user_session.dart';

class BalanceManager {
  static final BalanceManager _instance = BalanceManager._internal();
  factory BalanceManager() => _instance;
  BalanceManager._internal();

  String _balance = '0';
  Timer? _refreshTimer;
  final _balanceController = StreamController<String>.broadcast();

  Stream<String> get balanceStream => _balanceController.stream;
  String get currentBalance => _balance;

  // Initialize balance manager
  Future<void> initialize() async {
    await refreshBalance();
    // Refresh balance every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      refreshBalance();
    });
  }

  Future<void> refreshBalance() async {
    try {
      final userId = await UserSession.getUserId();
      final response = await http.post(
        Uri.parse('https://gowalletapp.com/php/get_u_balance.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('balance')) {
          _balance = jsonResponse['balance'].toString();
          _balanceController.add(_balance);
        } else if (jsonResponse.containsKey('error')) {
          print('Balance error: ${jsonResponse['error']}');
        }
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  // Format balance with commas for display
  String getFormattedBalance() {
    try {
      final numBalance = double.parse(_balance);
      return numBalance.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return _balance;
    }
  }

  void dispose() {
    _refreshTimer?.cancel();
    _balanceController.close();
  }
}
