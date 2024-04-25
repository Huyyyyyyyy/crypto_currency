import 'package:crypto_currency/view/components/futures_page/futures_components/search_crypto.dart';
import 'package:flutter/material.dart';


class FutureInfoTile extends StatelessWidget {
  final String symbol;
  final String volume;
  final String price;
  final double priceChangePercentage;

  const FutureInfoTile ({
    super.key,
    required this.symbol,
    required this.volume,
    required this.price,
    required this.priceChangePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CryptoSearchDialog();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 5, 0,0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    priceChangePercentage >= 0 ? '+${priceChangePercentage.toStringAsFixed(2)}%' : '${priceChangePercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color:  priceChangePercentage >= 0 ? Colors.green : Colors.red, // Change to red if the value is negative
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                        'Hợp đồng tương lai vĩnh cửu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
