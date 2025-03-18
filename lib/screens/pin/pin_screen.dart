import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_wallet/models/user_session.dart';

import '../../widgets/bottom_navigation_widget.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  final int _pinLength = 4;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyPin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await UserSession.getUserId();

      final response = await http.post(
        Uri.parse('https://gowalletapp.com/php/pin.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'id': userId,
          'pin': _pin,
        }),
      );

      final responseData = response.body;
      final cleanedResponse =
          responseData.replaceFirst('Connected successfully', '');
      final jsonResponse = json.decode(cleanedResponse);

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        if (!mounted) return;
        // TODO: Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN verified successfully!')),
        );
      } else {
        setState(() {
          _errorMessage = jsonResponse['message'] ?? 'PIN verification failed';
          _pin = ''; // Clear PIN on error
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _pin = ''; // Clear PIN on error
      });
      print('Error during PIN verification: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onNumberPressed(String number) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += number;
      });

      // Automatically verify when PIN is complete
      if (_pin.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _pin.length ? Colors.pink : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () => _onNumberPressed(number),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.grey.shade100,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(
              flex: 1,
            ),
            FutureBuilder<String>(
              future: UserSession.getProfileImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 50,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  );
                } else {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(snapshot.data!),
                    onBackgroundImageError: (_, __) =>
                        const Icon(Icons.person, size: 50),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: UserSession.getName(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            FutureBuilder<String>(
              future: UserSession.getPhone(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildPinDots(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: _pin.length == _pinLength ? () {} : null,
                style: TextButton.styleFrom(
                  backgroundColor: _pin.length == _pinLength
                      ? Colors.pink
                      : Colors.grey.shade300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: _pin.length == _pinLength
                            ? Colors.white
                            : Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: _pin.length == _pinLength
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildNumberButton('1'),
                      _buildNumberButton('2'),
                      _buildNumberButton('3'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildNumberButton('4'),
                      _buildNumberButton('5'),
                      _buildNumberButton('6'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildNumberButton('7'),
                      _buildNumberButton('8'),
                      _buildNumberButton('9'),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      _buildNumberButton('0'),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextButton(
                              onPressed: _onDeletePressed,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: Colors.grey.shade100,
                              ),
                              child: const Icon(
                                Icons.backspace_outlined,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
