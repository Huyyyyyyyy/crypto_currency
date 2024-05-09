import 'package:flutter/material.dart';
import 'package:crypto_currency/core/component/text/label_small_text_manatee.dart';
import 'package:crypto_currency/product/init/locale/project_keys.dart';
import 'package:crypto_currency/view/_product/widget/text/day_percent_change_price.dart';
import 'package:crypto_currency/view/_product/widget/text/eur_text_colored.dart';
import 'package:crypto_currency/view/_product/widget/text/euro_price_colored.dart';
import 'package:crypto_currency/view/home/model/crypto.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo({
    required this.crypto,
    super.key,
  });

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            EurPriceColored(crypto: crypto),
            EurTextColored(crypto: crypto),
          ],
        ),
        Row(
          children: [
            LabelSmallTextManatee(text: '= ${crypto.quote?.uSD?.price?.toStringAsFixed(2)} ${ProjectKeys.usd} '),
            DayPercentChangeColored(crypto: crypto),
          ],
        ),
      ],
    );
  }
}
