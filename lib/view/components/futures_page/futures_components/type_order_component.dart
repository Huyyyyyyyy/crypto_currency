import 'package:crypto_currency/model/enum/enum_order.dart';
import 'package:crypto_currency/model/futures_data.dart';
import 'package:crypto_currency/model/order_future/order_model.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/material.dart';

class TypeOrderComponent extends StatelessWidget {
  final FuturesData futuresData;

  const TypeOrderComponent({
    Key? key,
    required this.futuresData
  });


  @override
  Widget build(BuildContext context) {
    final List<String> itemTexts = ['Cross', '20x', 'Bán'];
    return Row(
      children: itemTexts.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3), // Khoảng cách giữa các mục
          child: GestureDetector(
            onTap: () async {
              OrderModel orderModel = OrderModel(
                  futuresData.symbol,
                  SideOrder.BUY,
                  TypeOrder.MARKET,
                  additionalForLimit.TIME_INFORCE,
                  0.02, // quantity
                  additionalForLimit.recvWindow,
                  futuresData.priceMarket, //limit price
                  futuresData.priceMarket // market price
              );

              // String status = await BinanceAPI.getExchangeInfo(orderModel.symbol);
              // BinanceAPI.filterTheOrder(status, orderModel.symbol);
              // await BinanceAPI.getExchangeInfo(futuresData.symbol);
              // await BinanceAPI.createNewOrderFuture(orderModel);
              // await BinanceAPI.getMarkPrice(futuresData.symbol);
              // await BinanceAPI.getAccount();
              // await BinanceAPI.getServerTime();
              await BinanceAPI.getListenKey();
              // await BinanceAPI.getWsAccountBalance();
            },
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF1F2630),
                  border: const Border(
                    top: BorderSide(color: Color(0xFF475569)),
                    left: BorderSide(color: Color(0xFF475569)),
                    right: BorderSide(color: Color(0xFF475569)),
                    bottom: BorderSide(color: Color(0xFF475569)),
                  )
                ),
                padding: const EdgeInsets.fromLTRB(15,5,15,5),
                child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFcbd5e1)
                    ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDialog(BuildContext context, String index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Dialog for Item $index'), // Tiêu đề của dialog
          content: Text('This is the content of Item $index'), // Nội dung của dialog
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog khi nhấn vào nút
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
