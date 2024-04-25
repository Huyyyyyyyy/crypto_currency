import 'package:crypto_currency/view/components/futures_page/futures_components/title_futures_m_component.dart';
import 'package:crypto_currency/view/components/futures_page/futures_components/type_order_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/futures_data.dart';
import 'funding_component.dart';
import 'live_price.dart';

class OrderCoinTab extends StatelessWidget {
  const OrderCoinTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FuturesData>(
      builder: (context, futuresData, _) {
        return Container(
          padding: const EdgeInsets.all(5),
          color: const Color(0xFF1F2630),
          child: Column(
            children: [
              Row(
                children: [
                  FutureInfoTile(
                    symbol: futuresData.symbol,
                    volume: futuresData.volume,
                    price: futuresData.price,
                    priceChangePercentage: futuresData.priceChangePercentage,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Expanded(
                    flex: 6,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TypeOrderComponent(futuresData: futuresData),
                      ],
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: ListView(
                      shrinkWrap: true,
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
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}