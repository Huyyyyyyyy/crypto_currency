import 'package:crypto_currency/services/custom_thumb_shape/custom_tick_mark_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_currency/model/account_stream/account_data.dart';
import 'package:crypto_currency/model/enum/enum_order.dart';
import 'package:crypto_currency/model/futures_data.dart';
import 'package:crypto_currency/model/order_future/order_model.dart';
import '../../../../services/custom_thumb_shape/custom_track_shape.dart';
import '../../../../services/custom_thumb_shape/customer_thumb_shape_balance.dart';
GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  late OrderModel orderModel;
  bool _isChanging = false;
  double _percentage = 0;


  //type order area
  void showTypeOrders(BuildContext context, List<String> options) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          key: UniqueKey(),
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

  Future<void> _incrementValue() async {
    if (!_isChanging) {
      try {
        _isChanging = true;
        double priceLimit = double.parse(_controller.text);
        print('first price limit: $priceLimit');
        priceLimit += 0.1;
        print('after price limit: $priceLimit');
        _controller.text = priceLimit.toStringAsFixed(3);
        print('_controller.text: ${_controller.text}');
      } catch (err) {
        print(err);
      } finally {
        _isChanging = false;
      }
    }
  }

  Future<void> _decrementValue() async {
    if (!_isChanging) {
      try {
        if(double.parse(_controller.text) > 0.2){
          _isChanging = true;
          double priceLimit = double.parse(_controller.text);
          print('first price limit: $priceLimit');
          priceLimit -= 0.1;
          print('after price limit: $priceLimit');
          _controller.text = priceLimit.toStringAsFixed(3);
          print('_controller.text: ${_controller.text}');
        }
      } catch (err) {
        print(err);
      } finally {
        _isChanging = false;
      }
    }
  }

  Future<void> _incrementBalance() async {
    if (!_isChanging) {
      try {
        _isChanging = true;
        if(_percentage >= 0 && _percentage < 100 ){
          _percentage += 1;
          double percentage = _percentage;
          _balanceController.text = '${percentage.toStringAsFixed(0)}%';
          print('_balanceController.text: ${_balanceController.text}');
        }
      } catch (err) {
        print(err);
      } finally {
        _isChanging = false;
      }
    }
  }

  Future<void> _decrementBalance() async {
    if (!_isChanging) {
      try {
        _isChanging = true;
        if(_percentage != 0 ){
          _percentage -= 1;
          double percentage = _percentage;
          _balanceController.text = '${percentage.toStringAsFixed(0)}%';
          print('_balanceController.text: ${_balanceController.text}');
        }
      } catch (err) {
        print(err);
      } finally {
        _isChanging = false;
      }
    }
  }
  //type order area




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
    _controller.text = widget.futuresData.priceMarket;
    _balanceController.text = _percentage.toStringAsFixed(0);

  }

  @override
  void dispose() {
    _controller.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _updatePercentage(double value) {
    setState(() {
      _percentage = value;
      double balancePercentage = _percentage;
      _balanceController.text = '${balancePercentage.toStringAsFixed(0)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> itemTexts = ['Cross', '20x', 'Bán'];
    final List<String> typeOptions = ['Market', 'Limit'];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                            orderModel.type,
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
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if(orderModel.type == 'Limit')
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF29313C),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(45,2,30,2),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Giá(USDT)',
                              style: TextStyle(
                                color: Color(0xFF64748b),
                                fontSize: 12
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              height: 18.0,
                              width: 25,
                              child: IconButton(
                                padding: const EdgeInsets.fromLTRB(5,0,20,15),
                                icon: const Icon(
                                  Icons.remove,
                                  color: Color(0xFF64748b),
                                  size: 15,
                                ),
                                onPressed: _decrementValue,
                              )
                          ),
                          SizedBox(
                            width: 100,
                            height: 25,
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                key: const ValueKey('priceLimitField'),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFe2e8f0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                                ),
                                onChanged: (value){
                                  orderModel.priceLimit = value;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 18.0,
                              width: 25,
                              child: IconButton(
                                padding: const EdgeInsets.fromLTRB(10,0,5,15),
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF64748b),
                                  size: 15,
                                ),
                                onPressed: _incrementValue,
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            if(orderModel.type == 'Limit')
              Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10,0 ),
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF29313C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    textAlign: TextAlign.center,
                    'BBO',
                    style: TextStyle(
                      color: Color(0xFFe2e8f0),
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            ),
            if(orderModel.type == 'Market')
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: 210,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF333B46),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
                  child: Text(
                    'Giá thị trường',
                    key: UniqueKey(),
                    style: const TextStyle(
                      color: Color(0xFF4E5866),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                width: 210,
                height: 50,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: const Color(0xFF29313C),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 18.0,
                            width: 25,
                            child: IconButton(
                              padding: const EdgeInsets.fromLTRB(5,0,20,15),
                              icon: const Icon(
                                Icons.remove,
                                color: Color(0xFF64748b),
                                size: 15,
                              ),
                              onPressed: _decrementBalance,
                            )
                        ),
                        SizedBox(
                          width: 100,
                          child: Form(
                            child: TextFormField(
                              controller: _balanceController,
                              decoration: const InputDecoration(
                                hintText: 'Số tiền',
                                hintStyle: TextStyle(
                                  color: Colors.grey, // Màu của hintText
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                              key: const ValueKey('percentageOfBalance'),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFe2e8f0),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (value) {
                                orderModel.priceLimit = value;
                              },
                            ),
                          )

                        ),
                        SizedBox(
                            height: 18.0,
                            width: 17,
                            child: IconButton(
                              padding: const EdgeInsets.fromLTRB(0,0,5,15),
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xFF64748b),
                                size: 15,
                              ),
                              onPressed: _incrementBalance,
                            )
                        ),
                        const SizedBox(
                          height: 20,
                          width: 40,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'USDT',
                              style: TextStyle(
                                color: Color(0xFFe2e8f0),
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                          width: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0,0,10,10),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF64748b),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 195,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackShape: CustomSliderTrackShape(),
                      activeTrackColor: const Color(0xFF94a3b8),
                      trackHeight: 1.5,
                      tickMarkShape: CustomTickMarkShape(),
                      inactiveTrackColor: const Color(0xFF29313C),
                      thumbShape: CustomSliderComponentShape(),
                    ),
                    child: SizedBox(
                      width: 230,
                      child: Slider(
                        value: _percentage,
                        onChanged: _updatePercentage,
                        min: 0.0,
                        max: 100.0,
                        divisions: 4,
                      ),
                    ),
                  ),
                )
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
