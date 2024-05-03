import 'package:flutter/material.dart';
import 'package:crypto_currency/core/init/theme/dark/dark_theme.dart';
import 'package:crypto_currency/view/home/view/home_page.dart';

class MyApptradingview extends StatelessWidget {
  const MyApptradingview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ProjectTheme().darkTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePageTradingview(),
    );
  }
}
