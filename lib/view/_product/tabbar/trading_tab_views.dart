import 'package:flutter/material.dart';
import 'package:crypto_currency/core/extension/context_extension.dart';
import 'package:crypto_currency/product/widget/divider/medium_full_width_divider.dart';
import 'package:crypto_currency/view/_product/widget/bottom/trading_view_crypto_info_bottom.dart';
import 'package:crypto_currency/view/_product/widget/chart/trading_view_widget_chart.dart';
import 'package:crypto_currency/view/_product/widget/dropdownbutton/global_average_dropdown_button.dart';
import 'package:crypto_currency/view/_product/widget/screen/technical_screen.dart';
import 'package:crypto_currency/view/_product/widget/screen/transaction_screen.dart';
import 'package:crypto_currency/view/_product/widget/text-for-price/price_info.dart';
import 'package:crypto_currency/view/home/model/crypto.dart';

class TradingTabViews extends StatelessWidget {
  const TradingTabViews({
    required this.crypto,
    Key? key,
  }) : super(key: key);

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: TradingViewWidgetChart(crypto: crypto),
                  ),
                  const MediumFullWidthDivider(),
                  Padding(
                    padding: context.halfVerticalSmallPad,
                    child: TradingViewCryptoInfoInBottom(crypto: crypto),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: context.halfVerticalSmallPad,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceInfo(crypto: crypto),
                      const GlobalAverageDropdownButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const TechinalsScreen(),
          const TransactionScreen(),
        ],
      ),
    );
  }
}
