import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoSearch extends StatelessWidget {
  final String symbol;
  final String price;
  final String volume;
  final double priceChangePercentage;

  const CryptoSearch({
    super.key,
    required this.symbol,
    required this.price,
    required this.volume,
    required this.priceChangePercentage,
  });


  //formatted price before using
  String getFormattedPrice(String price) {
    // Remove the dollar sign if it exists in the price string
    String priceWithoutSymbol = price.replaceAll(RegExp(r'[^0-9.]'), '');
    // Parse the price string into a double
    double priceValue = double.tryParse(priceWithoutSymbol) ?? 0.0;
    // Use NumberFormat to convert the price to a currency format
    String formattedPrice = NumberFormat.currency(symbol: '', decimalDigits: 2, locale: "en_US").format(priceValue);
    // Return the formatted price
    return formattedPrice;
  }


  String getFormattedVolumn(String volume) {
    // Parse the volume string into a double
    double volumeValue = double.tryParse(volume.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    // Format the volume with 'M' for millions, 'K' for thousands, etc.
    String formattedVolume;
    if (volumeValue >= 1e9) {
      formattedVolume = '${(volumeValue / 1e9).toStringAsFixed(2)}B';
    } else if (volumeValue >= 1e6) {
      formattedVolume = '${(volumeValue / 1e6).toStringAsFixed(2)}M';
    } else if (volumeValue >= 1e3) {
      formattedVolume = '${(volumeValue / 1e3).toStringAsFixed(2)}K';
    } else {
      formattedVolume = volumeValue.toStringAsFixed(2);
    }
    return 'KL $formattedVolume USDT'; // Add your currency symbol here
  }


  @override
  Widget build(BuildContext context) {

    // Call getFormattedPrice to format the price before displaying it
    String formattedPrice = getFormattedPrice(price);
    String formattedVolumn = getFormattedVolumn(volume);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2630),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(width: 8), // Provide some spacing between the text widgets
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: const Text(
                          'Hợp đồng tương lai vĩnh cửu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    )
                    // ... You can add more widgets here as needed
                  ],
                ),
                Text(
                  formattedVolumn,
                  style: const TextStyle(
                    color: Color(0xFF64748b),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formattedPrice,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
              Text(
                priceChangePercentage >= 0 ? '+${priceChangePercentage.toStringAsFixed(2)}%' : '${priceChangePercentage.toStringAsFixed(2)}%',
                style:  TextStyle(
                  color: priceChangePercentage >=0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}