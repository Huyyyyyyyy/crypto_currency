import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoTile extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final double priceChangePercentage;
  final String icon;

  const CryptoTile({
    super.key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.priceChangePercentage,
    required this.icon
  });


  //formatted price before using
  String getFormattedPrice(String price) {
    // Remove the dollar sign if it exists in the price string
    String priceWithoutSymbol = price.replaceAll(RegExp(r'[^0-9.]'), '');
    // Parse the price string into a double
    double priceValue = double.tryParse(priceWithoutSymbol) ?? 0.0;
    // Use NumberFormat to convert the price to a currency format
    String formattedPrice = NumberFormat.currency(symbol: '\$', decimalDigits: 2, locale: "en_US").format(priceValue);
    // Return the formatted price
    return formattedPrice;
  }

  //formatted price before using
  static String getFormattedPriceVND(String price, double exchangeRate) {
    // Remove any non-numeric characters except the decimal point
    String priceWithoutSymbol = price.replaceAll(RegExp(r'[^0-9.]'), '');
    // Parse the price string into a double
    double priceValue = double.tryParse(priceWithoutSymbol) ?? 0.0;
    // Convert the price from USD to VND using the exchange rate
    double priceInVND = priceValue * exchangeRate;
    // Use NumberFormat to convert the price to a currency format with Vietnamese currency symbol 'đ'
    String formattedPrice = NumberFormat.currency(
        symbol: 'đ',
        decimalDigits: 2, // Number of decimal places to display
        locale: "vi_VN" // Locale for Vietnam to get the correct thousand separator
    ).format(priceInVND);
    // Return the formatted price with a space after the symbol for better readability
    return formattedPrice.replaceFirst('','');
  }

  String formatSymbol(String symbol) {
    if (symbol.contains("USDT")) {
      // Tìm vị trí của "USDT" trong chuỗi
      int index = symbol.indexOf("USDT");
      // Tách chuỗi và thêm "/"
      String base = symbol.substring(0, index);
      String quote = symbol.substring(index, symbol.length);
      return "$base / $quote";
    }
    return symbol; // Trả về nguyên gốc nếu không chứa "USDT"
  }

  @override
  Widget build(BuildContext context) {

    // Call getFormattedPrice to format the price before displaying it
    String formattedPrice = getFormattedPrice(price);
    String formattedPriceVnd ='đ ${getFormattedPriceVND(price,23000)}';
    String formattedSymbol = formatSymbol(symbol);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xFF1F2630),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Image.network(icon, width: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  formattedSymbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.grey,
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
                ),
              ),
              Text(
                formattedPriceVnd,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: priceChangePercentage >= 0 ? Colors.green : Colors.red, // Background color
              borderRadius: BorderRadius.circular(4), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Expanded padding for the text
              child: Text(
                priceChangePercentage >= 0 ? '+${priceChangePercentage.toStringAsFixed(2)}%' : '${priceChangePercentage.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ),
        ],
      ),
    );
  }
}