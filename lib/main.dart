import 'package:crypto_currency/model/account_stream/account_data.dart';
import 'package:flutter/material.dart';
import 'package:crypto_currency/view/home/home_page.dart';
import 'package:provider/provider.dart';

import 'model/futures_currency_stream/futures_data.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FuturesData()),
        ChangeNotifierProvider(create: (context) => AccountData())
      ],
      child: MaterialApp(
        title: 'Final - Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}