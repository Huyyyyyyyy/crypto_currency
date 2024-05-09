import 'package:crypto_currency/view/components/crypto_list_page.dart';
import 'package:crypto_currency/view/components/futures_page/futures_page.dart';
import 'package:crypto_currency/view/components/wallet_page/wallet-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_currency/app.dart';
import 'package:crypto_currency/cubit_observer.dart';
import 'package:crypto_currency/view/home/service/get-it/get_it_source.dart';
import 'package:crypto_currency/view/home/view/home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final GlobalKey<NavigatorState> keyForFutures = GlobalKey<NavigatorState>();



  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Optionally: Reinitialize or reopen the socket when switching to the 'Futures' tab
    if (_currentIndex == 3) {
      final futuresNavigator = keyForFutures.currentState;
      if (futuresNavigator != null) {
        futuresNavigator.pushReplacement(MaterialPageRoute(builder: (_) => const FuturesPage()));
      }
    }
    GetItSource.setup();
    Bloc.observer = CubitObserver();
  }



  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> keyForHome = GlobalKey<NavigatorState>();
    final GlobalKey<NavigatorState> keyForMarket = GlobalKey<NavigatorState>();
    final GlobalKey<NavigatorState> keyForTrading = GlobalKey<NavigatorState>();
    final GlobalKey<NavigatorState> keyForFutures = GlobalKey<NavigatorState>();
    final GlobalKey<NavigatorState> keyForWallet = GlobalKey<NavigatorState>();
    return Scaffold(
      backgroundColor: const Color(0xFF1F2630),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Navigator(
            key: keyForHome,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (context) => const CryptoListPage()); // Your default page
            },
          ),
          Navigator(
            key: keyForMarket,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (context) => const MyApptradingview()); // Your default page
            },
          ),
          Navigator(
            key: keyForTrading,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (context) => const Text('Giao dịch')); // Your default page
            },
          ),
          Navigator(
            key: keyForFutures,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (context) =>  const FuturesPage()); // Your default page
            },
          ),
          Navigator(
            key: keyForWallet,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (context) => const WalletPage()); // Your default page
            },
          ),
          // Other tabs here...
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: const Color(0xFF1F2630),
          selectedItemColor: const Color(0xFFEBECF0),
          unselectedItemColor: const Color(0xFF858E9D),
          items:  const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.poll),
              label: 'Thị trường',
            ),
            // Assuming the lightning bolt icon represents 'Discover'
            BottomNavigationBarItem(
              icon: Icon(Icons.transform),
              label: 'Giao dịch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
              label: 'Futures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Ví',
            ),
          ],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}