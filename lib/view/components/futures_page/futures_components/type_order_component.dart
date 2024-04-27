import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_currency/model/account_stream/account_data.dart';
import 'package:crypto_currency/model/enum/enum_order.dart';
import 'package:crypto_currency/model/futures_data.dart';
import 'package:crypto_currency/model/order_future/order_model.dart';

class TypeOrderComponent extends StatefulWidget {
  final FuturesData futuresData;
  final AccountData accountData;

  TypeOrderComponent({
    Key? key,
    required this.futuresData,
    required this.accountData,
  }) : super(key: key);

  @override
  State<TypeOrderComponent> createState() => _TypeOrderComponentState();
}

class _TypeOrderComponentState extends State<TypeOrderComponent> {
  late OrderModel orderModel;


  void showTypeOrders(BuildContext context, List<String> options) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  print(option);
                  handleOptionSelected(option);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void handleOptionSelected(String option) {
    orderModel.type = option;
  }

  @override
  void initState() {
    super.initState();
    orderModel = OrderModel(
      widget.futuresData.symbol,
      SideOrder.BUY,
      'Market',
      additionalForLimit.TIME_INFORCE,
      0.02, // quantity
      additionalForLimit.recvWindow,
      widget.futuresData.priceMarket, // limit price
      widget.futuresData.priceMarket, // market price
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> itemTexts = ['Cross', '20x', 'Bán'];
    final List<String> typeOptions = ['Market', 'Limit'];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      shrinkWrap: true,
      children: [
        Row(
          children: itemTexts.map((text) {
            return GestureDetector(
              onTap: () async {},
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF1F2630),
                    border: const Border(
                      top: BorderSide(color: Color(0xFF475569)),
                      left: BorderSide(color: Color(0xFF475569)),
                      right: BorderSide(color: Color(0xFF475569)),
                      bottom: BorderSide(color: Color(0xFF475569)),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFcbd5e1),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  'Khả dụng',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748b),
                    fontSize: 13,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  '${double.parse(widget.accountData.availableBalance).toStringAsFixed(2)} USDT',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFcbd5e1),
                    fontSize: 13,
                  ),
                )),
            const Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.swap_horiz_sharp,
                color: Color(0xFFF1B90C),
                size: 22,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                showTypeOrders(context, typeOptions);
              },
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: 210,
                  decoration: BoxDecoration(
                      color: const Color(0xFF29313C),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.info_sharp,
                            color: Color(0xFF64748b),
                            size: 14,
                          ),
                        ),
                        Container(
                          width: 162,
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.center,
                          child: Text(
                            orderModel.type, // Hiển thị giá trị type của orderModel
                            style: const TextStyle(
                              color: Color(0xFFf1f5f9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF64748b),
                          ),
                        )
                      ]
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
