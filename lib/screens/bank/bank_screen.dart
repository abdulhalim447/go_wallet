import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> banks = [
    'City Bank',
    'Pubali Bank',
    'Islami Bank',
    'Janata Bank',
    'Sonali Bank',
    'Brack Bank',
    'Asia Bank',
    'Dutch Bangla',
    'Prime Bank',
  ];

  final _primaryBlue = const Color(0xFF2196F3);
  final _lightBlue = const Color(0xFFE3F2FD);
  final _darkBlue = const Color(0xFF1565C0);

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement transfer logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer initiated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBlue,
      appBar: AppBar(
        title:
            const Text('Bank Transfer', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedBank,
                          decoration: InputDecoration(
                            labelText: 'Select Bank',
                            labelStyle: TextStyle(color: _primaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _darkBlue, width: 2),
                            ),
                            prefixIcon: Icon(Icons.account_balance,
                                color: _primaryBlue),
                          ),
                          items: banks.map((String bank) {
                            return DropdownMenuItem(
                              value: bank,
                              child: Text(bank),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a bank';
                            }
                            return null;
                          },
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBank = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _accountHolderController,
                          decoration: InputDecoration(
                            labelText: 'Account Holder Name',
                            labelStyle: TextStyle(color: _primaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _darkBlue, width: 2),
                            ),
                            prefixIcon: Icon(Icons.person, color: _primaryBlue),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account holder name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _accountNumberController,
                          decoration: InputDecoration(
                            labelText: 'Account Number',
                            labelStyle: TextStyle(color: _primaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _darkBlue, width: 2),
                            ),
                            prefixIcon:
                                Icon(Icons.account_box, color: _primaryBlue),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account number';
                            }
                            if (value.length < 10) {
                              return 'Account number must be at least 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _amountController,
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            labelStyle: TextStyle(color: _primaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _darkBlue, width: 2),
                            ),
                            prefixIcon:
                                Icon(Icons.attach_money, color: _primaryBlue),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleTransfer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _primaryBlue,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Transfer',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
