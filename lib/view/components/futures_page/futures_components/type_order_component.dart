import 'package:crypto_currency/services/custom_checkbox/custom_checkbox.dart';
import 'package:crypto_currency/services/custom_thumb_shape/custom_tick_mark_shape.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/material.dart';
import 'package:crypto_currency/model/account_stream/account_data.dart';
import 'package:crypto_currency/model/enum/enum_order.dart';
import 'package:crypto_currency/model/futures_data.dart';
import 'package:crypto_currency/model/order_future/order_model.dart';
import 'package:flutter/services.dart';
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
  late final OrderModel orderModel;
  bool _isChanging = false;
  double _percentage = 0;
  double _costBaseOnPercentageForLong = 0;
  double _costBaseOnPercentageForShort = 0;
  bool showTpSlOptions = false;
  bool showOnlyDecrease = false;


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
        priceLimit += 0.1;
        _controller.text = priceLimit.toStringAsFixed(3);
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
          priceLimit -= 0.1;
          _controller.text = priceLimit.toStringAsFixed(3);
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
          _costBaseOnPercentageForLong = _percentage * double.parse(widget.accountData.availableBalance) / 100;
          _updatePercentage(percentage);
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
          _costBaseOnPercentageForLong = _percentage * double.parse(widget.accountData.availableBalance) / 100;
          _updatePercentage(percentage);
        }
      } catch (err) {
        print(err);
      } finally {
        _isChanging = false;
      }
    }
  }

  void _updatePercentage(double value) async{
    final getMarkPrices = await BinanceAPI.getMarkPrice(widget.futuresData.symbol);
    String markPrice = await getMarkPrices.toString();
    double openLoss = 0.0 ;
    if(orderModel.type == 'Limit'){
      openLoss = await calculateOpenLossShortOrder(1,double.parse(markPrice),double.parse(orderModel.priceLimit));
    }else{
      orderModel.priceMarket = await widget.futuresData.priceMarket;
      openLoss = await calculateOpenLossShortOrder(1,double.parse(markPrice),double.parse(orderModel.priceMarket));
    }
    setState(() {
      _percentage = value;
      double balancePercentage = _percentage;
      _balanceController.text = '${balancePercentage.toStringAsFixed(0)}%';
      _costBaseOnPercentageForLong = _percentage * double.parse(widget.accountData.availableBalance) / 100;
      _costBaseOnPercentageForShort = _costBaseOnPercentageForLong + openLoss;
    });
  }

  final List<TextInputFormatter> _inputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,3}')),
    TextInputFormatter.withFunction((oldValue, newValue) {
      try {
        final intValue = int.parse(newValue.text);
        return intValue >= 0 && intValue <= 100 ? newValue : oldValue;
      } catch (e) {
        return oldValue;
      }
    }),
  ];

  Future<void> _updateOrderModel() async{
    setState(() {
      orderModel.symbol = widget.futuresData.symbol;
      orderModel.priceMarket = widget.futuresData.priceMarket;
      orderModel.priceLimit = widget.futuresData.priceMarket;
      _controller.text = orderModel.priceLimit;
    });
  }

  Future<double> calculateOpenLossShortOrder(double numberOfContracts, double markPrice, double orderPrice) async{
    double directionOfOrder = -1;
    double priceDifference = markPrice - orderPrice;
    double openLoss = numberOfContracts * (priceDifference < 0 ? directionOfOrder * priceDifference : priceDifference);

    return openLoss;
  }
  //type order area


  @override
  void initState() {
    setState(() {
      orderModel = OrderModel(
        widget.futuresData.symbol,
        SideOrder.BUY,
        'Market',
        additionalForLimit.TIME_INFORCE,
        0,
        additionalForLimit.recvWindow,
        widget.futuresData.priceMarket,
        widget.futuresData.priceMarket,
      );
    });


    _controller.text = widget.futuresData.priceMarket;
    _balanceController.text = _percentage.toStringAsFixed(0);

    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    _balanceController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final List<String> itemTexts = ['Cross', '20x', 'Bán'];
    final List<String> typeOptions = ['Market', 'Limit'];

    (
        widget.futuresData.symbol != orderModel.symbol
        || double.parse(orderModel.priceLimit) == 0.0
        || double.parse(orderModel.priceMarket) == 0.0
    ) ? _updateOrderModel() : null;


    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        children: [
          // Type of Cross, Leverage, Buy
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
          // Type of Cross, Leverage, Buy

          // Available Balance
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
          // Available Balance

          // Side of Order
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
          // Type of Order

          // Price Limit or Market
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
          // Price Limit or Market

          //Using Cost
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
                                keyboardType: TextInputType.number,
                                inputFormatters: _inputFormatters,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFe2e8f0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (String? value) {
                                  double parsedValue = 0.0;
                                  if (value != null && value.isNotEmpty) {
                                    value = value.replaceAll('%', '');
                                    parsedValue = double.tryParse(value) ?? 0.0;
                                  }
                                  _updatePercentage (parsedValue);
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
          //Using Cost

          //Slider for controlling using balance
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 195,
                    height: 50,
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
            ],
          ),
          //Slider for controlling using balance


          // Take profit or Stop loss
          Row(
            children: [
              CustomCheckbox(
                isChecked: showTpSlOptions,
                onChanged: (value){
                  setState(() {
                    showTpSlOptions = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'TP/SL',
                  style: TextStyle(
                    color: Color(0xFFcbd5e1),
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                  ),
                ),
              ),
              if(showTpSlOptions)
                Container(
                  padding: const EdgeInsets.only(left: 65),
                  child: const SizedBox(
                    height: 25,
                    width:90,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children:[
                          Text(
                            'Nâng cao',
                            style: TextStyle(
                                color: Color(0xFFe2e8f0),
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF64748b),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if(showTpSlOptions)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                                width: 140,
                                child: Form(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Chốt lời',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF64748b), // Màu của hintText
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    key: const ValueKey('takeProfit'),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFe2e8f0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    onChanged: (value) {
                                      print('set take profit at: $value');
                                    },
                                  ),
                                )
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFF64748b),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              child: const SizedBox(
                                height: 20,
                                width: 45,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Gần ...',
                                    style: TextStyle(
                                        color: Color(0xFFe2e8f0),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500
                                    ),
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
          if(showTpSlOptions)
            Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
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
                              width: 140,
                              child: Form(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Cắt lỗ',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF64748b), // Màu của hintText
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  key: const ValueKey('stopLoss'),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFe2e8f0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (value) {
                                    print('set stop loss at: $value');
                                  },
                                ),
                              )
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFF64748b),
                                  width: 0.8,
                                ),
                              ),
                            ),
                            child: const SizedBox(
                              height: 20,
                              width: 45,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Gần ...',
                                  style: TextStyle(
                                      color: Color(0xFFe2e8f0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500
                                  ),
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
          const SizedBox(height: 8),
          // Take profit or Stop loss

          //Only down
          Row(
            children: [
              CustomCheckbox(
                isChecked: showOnlyDecrease,
                onChanged: (value){
                  showOnlyDecrease = value;
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Chỉ giảm',
                  style: TextStyle(
                      color: Color(0xFFcbd5e1),
                      fontWeight: FontWeight.w500,
                      fontSize: 13
                  ),
                ),
              ),
              if(showOnlyDecrease)
              Container(
                  padding: const EdgeInsets.only(left: 80),
                  child: const SizedBox(
                    height: 25,
                    width:50,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                          children:[
                            Text(
                              'GTC',
                              style: TextStyle(
                                  color: Color(0xFFe2e8f0),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF64748b),
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          //Only down

          //Max Price Long
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'TỐI ĐA',
                  style: TextStyle(
                    color: Color(0xFF7A8491)
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    textAlign: TextAlign.end,
                    '${widget.futuresData.maxPrice} USDT',
                    style: const TextStyle(
                        color: Color(0xFFcbd5e1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 2),
          //Max Price Long

          //Cost Long
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Chi phí',
                  style: TextStyle(
                      color: Color(0xFF7A8491)
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    textAlign: TextAlign.end,
                    '${_costBaseOnPercentageForLong.toStringAsFixed(2)} USDT',
                    style: const TextStyle(
                        color: Color(0xFFcbd5e1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          //Cost Long

          //Long button
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  print('open Long position');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 63, vertical: 12),
                  backgroundColor: const Color(0xFF2EBD85)
                ),
                child: const Text(
                  'Mua / Long',
                  style: TextStyle(
                    color: Color(0xFFF3FFFD),
                    fontSize: 17,
                    fontWeight: FontWeight.w500
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          //Long button

          //Max Price Short
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'TỐI ĐA',
                  style: TextStyle(
                      color: Color(0xFF7A8491)
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    textAlign: TextAlign.end,
                    '${widget.futuresData.minprice} USDT',
                    style: const TextStyle(
                        color: Color(0xFFcbd5e1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 2),
          //Max Price Short

          //Cost Short
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Chi phí',
                  style: TextStyle(
                      color: Color(0xFF7A8491)
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    textAlign: TextAlign.end,
                    '${_costBaseOnPercentageForShort.toStringAsFixed(2)} USDT',
                    style: const TextStyle(
                        color: Color(0xFFcbd5e1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          //Cost Short

          //Short button
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  print('open Short position');
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 63, vertical: 12),
                    backgroundColor: const Color(0xFFF6465D)
                ),
                child: const Text(
                  'Bán / Short',
                  style: TextStyle(
                      color: Color(0xFFF3FFFD),
                      fontSize: 17,
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          //Short button
        ],
      ),
    );
  }
}
