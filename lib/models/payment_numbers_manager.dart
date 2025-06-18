import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentNumbersManager {
  static final PaymentNumbersManager _instance =
      PaymentNumbersManager._internal();
  factory PaymentNumbersManager() => _instance;
  PaymentNumbersManager._internal();

  Map<String, String> _numbers = {
    'bkash': '',
    'nagad': '',
    'rocket': '',
    'upay': '',
  };

  final _numbersController = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get numbersStream => _numbersController.stream;
  Map<String, String> get currentNumbers => _numbers;

  Future<void> initialize() async {
    await refreshNumbers();
    // Refresh numbers every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (_) {
      refreshNumbers();
    });
  }

  Future<void> refreshNumbers() async {
    try {
      final response = await http.get(
        Uri.parse('https://gowalletapp.com/php/add_money/get_numbers.php'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          final latestNumbers = jsonResponse.last; // Get the latest numbers
          _numbers = {
            'bkash': latestNumbers['bkash']?.toString() ?? '',
            'nagad': latestNumbers['nagad']?.toString() ?? '',
            'rocket': latestNumbers['rocket']?.toString() ?? '',
            'upay': latestNumbers['upay']?.toString() ?? '',
          };
          _numbersController.add(_numbers);
        }
      }
    } catch (e) {
      print('Error fetching payment numbers: $e');
    }
  }

  String getNumber(String method) {
    return _numbers[method.toLowerCase()] ?? '';
  }

  void dispose() {
    _numbersController.close();
  }
}
