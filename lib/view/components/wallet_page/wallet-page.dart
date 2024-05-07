import 'package:crypto_currency/view/components/wallet_page/futures_wallet/future-wallet.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2630),
      appBar: null, // Remove the default app bar
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top, // Use the status bar height as top padding
          ),
          TabBar(
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.only(left: 5),
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: const Color(0xFF858E9C),
            labelColor: Colors.white,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            dividerColor: const Color(0xFF334155),
            indicatorColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(
                child: Text(
                  'Tài khoản',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Giao ngay',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Funding',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Earn',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Futures',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Margin',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Tài khoản')),
                Center(child: Text('Giao ngay')),
                Center(child: Text('Funding')),
                Center(child: Text('Earn')),
                Center(child: FuturesWallet()),
                Center(child: Text('Margin')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
