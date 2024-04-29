import 'package:crypto_currency/view/components/tab_in_list_page/popular_tab.dart';
import 'package:crypto_currency/view/components/tab_in_list_page/wishlist_tab.dart';
import 'package:flutter/material.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  _CryptoListPageState createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Tab _customTab(String title) {
    return Tab(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1F2630), // Set the background color for the label here
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2630),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          // Adjust the height to fit your balance component and TabBar
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng số dư (USDT)',
                          style: TextStyle(color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0.00',
                          style: TextStyle(color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '≈ đ0',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle the press action
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.amberAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )// Text color
                      ),
                      child: const Text(
                          'Nạp',
                          style: TextStyle(color: Color(0xFF1F2630),
                                          fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Colors.amber,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                splashFactory: NoSplash.splashFactory,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                tabs: [
                  _customTab('Phổ biến'),
                  _customTab('Danh sách yêu thích'),
                  _customTab('Tăng giá'),
                  _customTab('Giảm giá'),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF1F2630),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PopularTab(),
          WishlistTab(),
          WishlistTab(),
          WishlistTab(),
        ],
      ),
    );
  }
}