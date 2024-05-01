import 'package:crypto_currency/model/position_stream/positions_stream.dart';
import 'package:crypto_currency/services/custom_checkbox/custom_checkbox_rectangle.dart';
import 'package:crypto_currency/services/custom_dot_line_border/custom_dot_line_border.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class AllPositions extends StatefulWidget {
  final List<PositionStreams> positions;

  const AllPositions({Key? key, required this.positions}) : super(key: key);

  @override
  State<AllPositions> createState() => _AllPositionsState();
}

class _AllPositionsState extends State<AllPositions> {
  bool showTpSlOptions = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,0,5,5),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF858E9C),
                  width: 0.3
                )
              )
            ),
            child: Row(
              children: [
                CustomCheckboxRect(
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
                    'Ẩn các cặp tỉ giá khác',
                    style: TextStyle(
                      color: Color(0xFFDDE0E5),
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:90),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10,3,10,3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333B46),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print('Close all positions');
                      },
                      child: const Text(
                        'Đóng tất cả',
                        style: TextStyle(
                          color: Color(0xFFE9ECF1),
                          fontWeight: FontWeight.w500,
                          fontSize: 15
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.positions.length,
                itemBuilder: (context, index) {
                  PositionStreams position = widget.positions[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF2A323D),
                            width: 0.8
                          )
                        ),
                      ),
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: position.positionSide == 'LONG' ? const Color(0xFF2DBD83) : const Color(0xFFF6465D),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(
                                    position.positionSide == 'LONG' ? 'Mua' : 'Bán',
                                    style: const TextStyle(
                                      color: Color(0xFFFFFBFD),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  position.symbol,
                                  style: const TextStyle(
                                    color: Color(0xFFEAECF0),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5,0,0,5),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF28313C),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Text(
                                    'Hợp đồng tương lai vĩnh cửu',
                                    style: TextStyle(
                                      color: Color(0xFFE1E1E8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2,0,0,5),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF28313C),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(
                                    'Cross ${position.leverage}x',
                                    style: const TextStyle(
                                        color: Color(0xFFE1E1E8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.share,
                                  color: Color(0xFF4F5867),
                                  size: 18,
                                  weight: 500,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(
                                width : 215,
                                child: DottedBorderUnderText(
                                  color: const Color(0xFF818A96),
                                  strokeWidth: 0.8,
                                  gapWidth: 1,
                                  child: const Text(
                                    'PNL chưa được ghi nhận (USDT)',
                                    style: TextStyle(
                                        color: Color(0xFF818A96),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 130),
                                child: SizedBox(
                                  width : 25,
                                  child: DottedBorderUnderText(
                                    color: const Color(0xFF818A96),
                                    strokeWidth: 0.8,
                                    gapWidth: 1,
                                    child: const Text(
                                      'ROI',
                                      style: TextStyle(
                                          color: Color(0xFF818A96),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  double.parse(position.unRealizedProfit).toStringAsFixed(2),
                                  style: TextStyle(
                                    color: (double.parse(position.unRealizedProfit) > 0) ? const Color(0xFF2EBD85): const Color(0xFFF5455E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                   '${BinanceAPI.calculatePositionROI(
                                       double.parse(position.unRealizedProfit),
                                       double.parse(position.positionAmt),
                                       double.parse(position.markPrice),
                                       double.parse(position.leverage)
                                   )}%',
                                    style: TextStyle(
                                      color: (double.parse(position.unRealizedProfit) > 0) ? const Color(0xFF2EBD85): const Color(0xFFF5455E),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height : 8),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: DottedBorderUnderText(
                                  color: const Color(0xFF818A96),
                                  strokeWidth: 0.8,
                                  gapWidth: 1,
                                  child: const Text(
                                    'Kích thước (USDT)',
                                    style: TextStyle(
                                        color: Color(0xFF818A96),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                child: Text(
                                  'Margin (USDT)',
                                  style: TextStyle(
                                      color: Color(0xFF818A96),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 57),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: DottedBorderUnderText(
                                    color: const Color(0xFF818A96),
                                    strokeWidth: 0.8,
                                    gapWidth: 1,
                                    child: const Text(
                                      'Tỉ lệ ký quỹ',
                                      style: TextStyle(
                                          color: Color(0xFF818A96),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  BinanceAPI.calculateSizeOfPosition(
                                      double.parse(position.leverage),
                                      double.parse(position.positionAmt),
                                      double.parse(position.markPrice)
                                  ),
                                  style: const TextStyle(
                                      color: Color(0xFFEAECF1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                child: Text(
                                  BinanceAPI.calculateMargin(
                                      double.parse(position.leverage),
                                      double.parse(position.positionAmt),
                                      double.parse(position.markPrice)
                                  ),
                                  style: const TextStyle(
                                      color: Color(0xFFEAECF1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: Text(
                                  textAlign: TextAlign.end,
                                  '${position.marginRatio}%',
                                  style: TextStyle(
                                    color: (double.parse(position.marginRatio) < 20) ? const Color(0xFF2EBD85): const Color(0xFFF0B90B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: DottedBorderUnderText(
                                  color: const Color(0xFF818A96),
                                  strokeWidth: 0.8,
                                  gapWidth: 1,
                                  child: const Text(
                                    'Giá vào lệnh (USDT)',
                                    style: TextStyle(
                                        color: Color(0xFF818A96),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text(
                                  'G.Đánh dấu (USDT)',
                                  style: TextStyle(
                                      color: Color(0xFF818A96),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'G.Thanh lý (USDT)',
                                    style: TextStyle(
                                        color: Color(0xFF818A96),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  double.parse(position.entryPrice).toStringAsFixed(3),
                                  style: const TextStyle(
                                      color: Color(0xFFEAECF1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              Container(
                                width: 90,
                                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                child: Text(
                                  double.parse(position.markPrice).toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Color(0xFFEAECF1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 155,
                                child: Text(
                                  textAlign: TextAlign.end,
                                  double.parse(position.liquidationPrice) < 0.00001 ?
                                  '- -' :
                                  double.parse(position.liquidationPrice).toStringAsFixed(3) ,
                                  style: const TextStyle(
                                      color: Color(0xFFEAECF1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
