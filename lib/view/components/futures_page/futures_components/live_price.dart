import 'package:flutter/material.dart';

import '../../../../services/custom_dot_line_border/custom_dot_line_border.dart';

class LivePriceUpdateTile extends StatelessWidget {
  final List<String> prices;
  final List<String> quantity;
  final String lastPrice;
  final String lowPrice;

  const LivePriceUpdateTile({
    Key? key,
    required this.prices,
    required this.quantity,
    required this.lastPrice,
    required this.lowPrice
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      decoration: const BoxDecoration(
        color: Color(0xFF1F2630),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0), // Padding giữa hai cột
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nhãn cho cột giá
                      const Text(
                        'Giá\n(USDT)',
                        style: TextStyle(
                          color: Color(0xFF64748b),
                          fontWeight: FontWeight.w500,
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: prices.sublist(0, prices.length ~/ 2).map((price) => Text(
                          price,
                          style: const TextStyle(
                              color: Color(0xFFe11d48),
                              fontWeight : FontWeight.w500,
                              fontSize: 13.5,
                              height: 1.5
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0), // Padding giữa hai cột
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Nhãn cho cột số lượng
                      const Text(
                        'Số lượng \n (USDT)',
                        style: TextStyle(
                          color: Color(0xFF64748b),
                          fontWeight: FontWeight.w500,
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: quantity.sublist(0, quantity.length ~/ 2).map((quantity) => Text(
                          quantity,
                          style: const TextStyle(
                              color: Color(0xFFe2e8f0),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              height: 1.6
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  double.parse(lastPrice).toStringAsFixed(3),
                  style : const TextStyle(
                  color: Color(0xFF2EBD86),
                  fontSize : 20,
                  fontWeight: FontWeight.w600
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Center(
                      child: DottedBorderUnderText(
                        color: const Color(0xFFcbd5e1),
                        strokeWidth: 0.8,
                        gapWidth: 1,
                        child: Text(
                        double.parse(lowPrice).toStringAsFixed(3),
                          style : const TextStyle(
                              color: Color(0xFF94a3b8),
                              fontSize : 13,
                              fontWeight: FontWeight.w400
                          )
                        ),
                    ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0), // Padding giữa hai cột
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: prices.sublist(prices.length ~/ 2).map((price) => Text(
                          price,
                          style: const TextStyle(
                            color: Color(0xFF2EBD86),
                            fontWeight : FontWeight.w500,
                            fontSize: 13,
                            height: 1.5
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0), // Padding giữa hai cột
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: quantity.sublist(quantity.length ~/ 2).map((quantity) => Text(
                          quantity,
                          style: const TextStyle(
                              color: Color(0xFFe2e8f0),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              height: 1.5
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
