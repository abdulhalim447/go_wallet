import 'package:go_wallet/auth/register.dart';
import 'package:go_wallet/pages/splash_screen_page.dart';
import 'package:go_wallet/screens/pin/pin_screen.dart';
import 'package:go_wallet/widgets/appbar_widget.dart';
import 'package:go_wallet/widgets/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
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
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreenPage(),
      ),
    );
  }
}
