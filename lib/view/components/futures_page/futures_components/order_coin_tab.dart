import 'package:crypto_currency/view/components/futures_page/all_positions/all_positions.dart';
import 'package:crypto_currency/view/components/futures_page/futures_components/title_futures_m_component.dart';
import 'package:crypto_currency/view/components/futures_page/futures_components/type_order_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/account_stream/account_data.dart';
import '../../../../model/futures_currency_stream/futures_data.dart';
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


  @override
  Widget build(BuildContext context) {
    return Consumer2<FuturesData, AccountData>(
      builder: (context, futuresData, accountData, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                        tabAlignment: TabAlignment.start,
                        padding: const EdgeInsets.only(left: 5),
                        controller: _tabController,
                        isScrollable: true,
                        unselectedLabelColor: const Color(0xFF858E9C),
                        labelColor: Colors.white,
                        labelPadding: const EdgeInsets.only(right: 20),
                        dividerColor: const Color(0xFF334155),
                        indicatorColor: const Color(0xFFF1B90C),
                        splashFactory: NoSplash.splashFactory,
                        indicatorWeight: 0.5,
                        tabs: [
                          const Tab(
                            child: Text(
                              'Lệnh mở (0)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Vị thế (${accountData.currentPositions.length})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            ),
                          ),
                          const Tab(
                            child: Text(
                              'Lưới hợp đồng tương lai',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                const Center(child: Text('Nội dung tab Lệnh mở')),
                AllPositions(positions: accountData.currentPositions),
                const Center(child: Text('Nội dung tab Lưới hợp đồng tương lai')),
              ],
            ),
          ),
        );
      },
    );
  }
}
