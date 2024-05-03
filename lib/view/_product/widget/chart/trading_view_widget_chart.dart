import 'package:flutter/material.dart';
import 'package:crypto_currency/core/extension/context_extension.dart';
import 'package:crypto_currency/view/home/model/crypto.dart';
import 'package:crypto_currency/view/tradingview/service/crypto_name_data_source.dart';
import 'package:crypto_currency/view/tradingview/service/trading_view_html.dart';

class TradingViewWidgetChart extends StatelessWidget {
  const TradingViewWidgetChart({
    required this.crypto,
    Key? key,
  }) : super(key: key);

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: context.tradingViewWidgetHeight,
          child: Padding(
            padding: const EdgeInsets.only(top: 1.0), // Dịch chuyển biểu đồ lên 70 điểm
            child: TradingViewWidgetHtml(
              cryptoName: CryptoNameDataSource.binanceSourceEuro(crypto.symbol.toString()),
            ),
          ),
        ),
        Container(
          height: 20, // Chiều cao của phần dưới của biểu đồ
           // Màu nền của phần dưới của biểu đồ
        ),
      ],
    );
  }
}
