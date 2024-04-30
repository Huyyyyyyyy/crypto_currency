import 'package:crypto_currency/model/position_stream/positions_stream.dart';
import 'package:crypto_currency/services/custom_checkbox/custom_checkbox_rectangle.dart';
import 'package:flutter/material.dart';

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
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Symbol: ${position.symbol}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8.0),
                          Text('Position Side: ${position.positionSide}'),
                          Text('Entry Price: ${position.entryPrice}'),
                          Text('Unrealized Profit: ${position.unRealizedProfit}'),
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
