import 'package:go_wallet/pages/splash_screen_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_wallet/models/balance_manager.dart';
import 'package:go_wallet/models/payment_numbers_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BalanceManager().initialize();
  await PaymentNumbersManager().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Go  Wallet ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreenPage(),
      ),
    );
  }
}
