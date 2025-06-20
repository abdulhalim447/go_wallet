import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_endpoints.dart';

class RingitService {
  static final RingitService _instance = RingitService._internal();
  factory RingitService() => _instance;
  RingitService._internal();

  // Store the current ringit value
  String? _ringitValue;

  // Stream controller to broadcast ringit value changes
  final _ringitController = StreamController<String>.broadcast();

  // Getter for the stream
  Stream<String> get ringitStream => _ringitController.stream;

  // Getter for current value
  String get currentRingit => _ringitValue ?? '0';

  // Initialize the service
  Future<void> initialize() async {
    await fetchRingitValue();
  }

  // Fetch ringit value from API
  Future<void> fetchRingitValue() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getRingit),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          _ringitValue = jsonResponse['data']['ringit'].toString();
          _ringitController.add(_ringitValue!);
        }
      }
    } catch (e) {
      print('Error fetching ringit value: $e');
    }
  }

  // Method to calculate value using ringit
  double calculateWithRingit(double amount) {
    final ringit = double.tryParse(_ringitValue ?? '0') ?? 0;
    return amount * ringit;
  }

  // Dispose of the controller when no longer needed
  void dispose() {
    _ringitController.close();
  }
}
