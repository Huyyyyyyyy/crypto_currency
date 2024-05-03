import 'package:flutter/material.dart';
import 'package:crypto_currency/core/extension/context_extension.dart';
import 'package:crypto_currency/product/widget/text-area/custom_multi_text_size.dart';
import 'package:crypto_currency/view/_product/widget/text-area/cap_view.dart';
import 'package:crypto_currency/view/_product/widget/text-area/circulation_view.dart';
import 'package:crypto_currency/view/_product/widget/text-area/day_high_view.dart';
import 'package:crypto_currency/view/_product/widget/text-area/day_low_view.dart';
import 'package:crypto_currency/view/_product/widget/text-area/day_vol_view.dart';
import 'package:crypto_currency/view/home/model/crypto.dart';

class TradingViewCryptoInfoInBottom extends StatelessWidget {
  const TradingViewCryptoInfoInBottom({
    required this.crypto,
    super.key,
  });

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        context.smallHeightSize,

        context.smallHeightSize,

      ],
    );
  }
}
