import 'package:flutter/material.dart';
import 'package:crypto_currency/view/home/home_page.dart';
import 'package:provider/provider.dart';

import 'model/futures_data.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FuturesData(),
      child: MaterialApp(
        title: 'Crypto Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}