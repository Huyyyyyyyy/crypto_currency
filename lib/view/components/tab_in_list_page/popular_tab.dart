import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto_currency/services/websocket_manager.dart';

import '../../../model/crypto_title.dart';



class PopularTab extends StatefulWidget {
  const PopularTab({Key? key}) : super(key: key);
  @override
  _PopularTabState createState() => _PopularTabState();
}

class _PopularTabState extends State<PopularTab> with AutomaticKeepAliveClientMixin {
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

  List<String> coinNames = [
    'Bitcoin',
    'Ethereum',
    'Internet Computer',
    'Worldcoin',
    'dYdX',
    'Solana',
    'Dogecoin',
    'Avalanche',
    'Cardano',
    'BNB',
    'Cosmos'
    // Add more coin names corresponding to your WebSocketManager instances
  ];

  List<String> coinIcons = [
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/87496d50-2408-43e1-ad4c-78b47b448a6a.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/3a8c9fe6-2a76-4ace-aa07-415d994de6f0.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20220126/b0a24999-f7b2-4ae5-b1f2-083c9df79447.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20230724/ca2898e2-26e5-40ac-a766-10f8e0c345fc',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20220126/3d0a3cb6-4ebf-417f-adef-694ab90c19ff.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20230404/b2f0c70f-4fb2-4472-9fe7-480ad1592421.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/22ef2baf-b210-4882-afd9-1317bb7a3603.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20200922/3fc414d2-c33b-4c01-8138-0b0acac5657b.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/3bc4f3c3-c142-4379-9ebd-a72f332776bc.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20220218/94863af2-c980-42cf-a139-7b9f462a36c2.png',
    'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/b6b0ea3d-995f-4c16-b635-c76a21c0a726.png'
    // Thêm URL của icon các coin tương ứng
  ];


  @override
  void dispose() {
    // Đóng tất cả các kết nối WebSocket khi tab bị dispose
    for (var websocket in coins) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50), // Padding hai bên
                child: Text(
                  'Tên',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30), // Padding hai bên
                child: Text(
                  'Giá gần nhất',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0), // Padding hai bên
                child: Text(
                  'Thay đổi 24h',
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
                    double priceChangePercentage = double.tryParse(data['P']) ?? 0.0;
                    return CryptoTile(
                      symbol: data['s'],
                      name: coinNames[index],
                      price: '\$${data['c']}',
                      priceChangePercentage: priceChangePercentage,
                      icon: coinIcons[index],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  // Placeholder widget while the data is loading
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          )
        ),
      ],
    );
  }

  // Override this method to keep the state alive
  @override
  bool get wantKeepAlive => true;
}