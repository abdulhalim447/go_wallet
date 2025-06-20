import 'package:flutter/material.dart';
import 'package:go_wallet/config/api_endpoints.dart';
import 'package:go_wallet/models/user_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:go_wallet/models/payment_numbers_manager.dart';
import 'package:flutter/services.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  final TextEditingController _trnxIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PaymentNumbersManager().refreshNumbers();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a receipt image')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Get user ID from session
        final userId = await UserSession.getUserId();

        // Create multipart request
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://gowalletapp.xyz/php/add_money/add_money.php'),
        );

        // Add text fields
        request.fields['account'] = userId;
        request.fields['transaction_id'] = _trnxIdController.text;
        request.fields['amount'] = _amountController.text;

        // Add image file
        var imageStream = http.ByteStream(_image!.openRead());
        var length = await _image!.length();

        if (length > 2097152) {
          // 2MB in bytes
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size should be less than 2MB')),
          );
          setState(() => _isLoading = false);
          return;
        }

        var multipartFile = http.MultipartFile(
          'image',
          imageStream,
          length,
          filename: _image!.path.split('/').last,
        );

        request.files.add(multipartFile);

        // Send request
        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
          if (!mounted) return;

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );

          // Clear form
          _trnxIdController.clear();
          _amountController.clear();
          _pinController.clear();
          setState(() {
            _image = null;
          });

          // Navigate back
          Navigator.pop(context);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(jsonResponse['message'] ?? 'Failed to add money')),
          );
        }
      } catch (e) {
        print(e);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
        print('Error during add money: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildPaymentMethods() {
    return StreamBuilder<Map<String, String>>(
      stream: PaymentNumbersManager().numbersStream,
      builder: (context, snapshot) {
        final numbers = snapshot.data ?? PaymentNumbersManager().currentNumbers;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              'bkash',
            ].map((method) {
              final number = numbers[method.toLowerCase()] ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/${method.toLowerCase()}.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.payment),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        number,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (number.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: number));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$method number copied!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        tooltip: 'Copy number',
                        splashRadius: 20,
                        color: Colors.blue,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text(
          'Add Money',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Money Account Numbers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Methods
                _buildPaymentMethods(),

                const SizedBox(height: 24),

                // Transaction ID Field
                TextFormField(
                  controller: _trnxIdController,
                  decoration: InputDecoration(
                    labelText: 'Transaction ID',
                    prefixIcon: const Icon(Icons.receipt_long),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter transaction ID';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter amount';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // PIN Field
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter PIN';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Image Upload Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (_image != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _image!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload_file),
                        label: Text(_image == null
                            ? 'Upload Receipt'
                            : 'Change Receipt'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ADD NOW',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
