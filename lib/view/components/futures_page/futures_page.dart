import 'package:crypto_currency/view/components/futures_page/futures_components/order_coin_tab.dart';
import 'package:flutter/material.dart';

class FuturesPage extends StatefulWidget {
  const FuturesPage({super.key});

  @override
  _FuturesPageState createState() => _FuturesPageState();
}

class _FuturesPageState extends State<FuturesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            dividerColor: const Color(0xFF334155),
            indicatorColor: Colors.transparent,
            tabs: const [
              Tab(
                  child: Text(
                    'USDⓈ-M',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  ),
              ),
              Tab(
                child: Text(
                  'COIN-M',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Quyền chọn',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Bot',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Sao chép giao dịch',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                OrderCoinTab(),
                Center(child: Text('COINⓂ️')),
                Center(child: Text('Quyền chọn')),
                Center(child: Text('Bot')),
                Center(child: Text('Sao chép')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
