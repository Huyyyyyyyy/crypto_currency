import 'dart:ui';

import 'package:crypto_currency/view/components/futures_page/futures_components/title_futures_m_component.dart';
import 'package:crypto_currency/view/components/futures_page/futures_components/type_order_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/account_stream/account_data.dart';
import '../../../../model/futures_data.dart';
import 'funding_component.dart';
import 'live_price.dart';

class OrderCoinTab extends StatefulWidget {
  const OrderCoinTab({Key? key}) : super(key: key);

  @override
  State<OrderCoinTab> createState() => _OrderCoinTabState();
}

class _OrderCoinTabState extends State<OrderCoinTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          color: Color(0xFF1F2630),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FuturesData, AccountData>(
      builder: (context, futuresData, accountData, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FutureInfoTile(
                        symbol: futuresData.symbol,
                        volume: futuresData.volume,
                        price: futuresData.price,
                        priceChangePercentage: futuresData.priceChangePercentage,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          TypeOrderComponent(futuresData: futuresData, accountData: accountData),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            FundingComponent(
                              fundingRates: futuresData.fundingRates,
                              nextFundingTime: futuresData.nextFundingTime,
                            ),
                            LivePriceUpdateTile(
                              prices: futuresData.livePrices,
                              quantity: futuresData.quantity,
                              lastPrice: futuresData.lastPrice,
                              lowPrice: futuresData.lowPrice,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        tabs: <Widget> [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: _customTab('Lệnh mở (0)'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: _customTab('Vị thế (0)'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: _customTab('Lưới hợp đồng tương lai'),
                          ),
                        ],
                        isScrollable: true,
                        controller: _tabController,
                        splashFactory: NoSplash.splashFactory,
                        indicatorColor: Colors.amber,
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFF858E9D),
                        dividerColor: Colors.transparent,
                        dividerHeight: 0.2,
                        tabAlignment: TabAlignment.start,
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Center(child: Text('Nội dung tab Lệnh mở')),
                Center(child: Text('Nội dung tab Vị thế')),
                Center(child: Text('Nội dung tab Lưới hợp đồng tương lai')),
              ],
            ),
          ),
        );
      },
    );
  }
}
