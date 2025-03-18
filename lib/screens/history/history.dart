import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('No history found'),
      ),
    );
  }
}
