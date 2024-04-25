import 'dart:convert';
import 'package:crypto_currency/model/crypto_search.dart';
import 'package:crypto_currency/services/global_setting.dart';
import 'package:flutter/material.dart';
import 'package:crypto_currency/services/websocket_manager.dart';
import 'package:provider/provider.dart';
import '../../../../model/futures_data.dart';


class ListSearch extends StatefulWidget {
  final Function() onClose;
  const ListSearch({Key? key,required this.onClose}) : super(key: key);
  @override
  _ListSearchState createState() => _ListSearchState();
}

class _ListSearchState extends State<ListSearch> with AutomaticKeepAliveClientMixin {
  // Your existing code for building the list of cryptocurrencies...

  List<WebSocketManager> coins = [
    WebSocketManager('wss://fstream.binance.com/ws/btcusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/ethusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/icpusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/wldusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/dydxusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/solusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/dogeusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/avaxusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/adausdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/bnbusdt@ticker'),
    WebSocketManager('wss://fstream.binance.com/ws/atomusdt@ticker'),
    // Add more WebSocketManager instances for other coins if necessary
  ];

  List<WebSocketManager> fundingForCoins = [
    WebSocketManager('wss://fstream.binance.com/ws/btcusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/ethusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/icpusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/wldusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/dydxusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/solusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/dogeusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/avaxusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/adausdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/bnbusdt@markPrice'),
    WebSocketManager('wss://fstream.binance.com/ws/atomusdt@markPrice'),
    // Add more WebSocketManager instances for other coins if necessary
  ];

  @override
  void dispose() {
    // Đóng tất cả các kết nối WebSocket khi tab bị dispose
    for (var websocket in coins) {
      websocket.close();
    }

    for (var websocket in fundingForCoins) {
      websocket.close();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Call to super.build is needed when using KeepAlive mixin
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40), // Padding hai bên
                child: Text(
                  'Tên / KL',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32), // Padding hai bên
                child: Text(
                  'Giá gần nhất / Bđ giá 24h',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                  stream: coins[index].stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = json.decode(snapshot.data.toString());
                      return GestureDetector(
                        onTap: () async {
                          final currentContext = context; // Lưu lại BuildContext hiện tại
                          await GlobalSettings.updateUrl(coins[index].url);
                          await GlobalSettings.updateUrlFundingTime(fundingForCoins[index].url);
                          await GlobalSettings.updateUrlAggTrade(coins[index].url);

                          if (mounted) { // Kiểm tra xem widget có còn được gắn kết không
                            Provider.of<FuturesData>(currentContext, listen: false).connectAndUpdateData();
                          }

                          widget.onClose(); // Gọi callback để ẩn dialog
                        },
                        child: CryptoSearch(
                          // Your list item widget here
                          symbol: data['s'], // Assuming these fields exist
                          volume: '\$${data['q']}',
                          price: '\$${data['c']}',
                          priceChangePercentage: double.tryParse(data['P']) ?? 0.0,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            )
        )
      ],
    );
  }

  // Override this method to keep the state alive
  @override
  bool get wantKeepAlive => true;
}