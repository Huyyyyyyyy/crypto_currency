import 'dart:async';
import 'dart:convert';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../services/global_setting.dart';
import '../../services/websocket_manager.dart';

class AccountData with ChangeNotifier {
  WebSocketManager? webSocketManager;
  String accountAlias = '';
  String asset = '';
  String balance = '0.0';
  String crossWalletBalance = '0.0';
  String crossUnPnl = '0.0';
  String availableBalance = '0.0';
  String maxWithdrawAmount = '0.0';
  String marginAvailable = '';
  String updateTime = '';

  AccountData() {
    connectAndUpdateData();
  }

  @override
  void dispose() {
    disconnectWebSocket();
    super.dispose();
  }

  void disconnectWebSocket() {
    webSocketManager?.close();
  }

  void connectAndUpdateData() async {
    webSocketManager = WebSocketManager(BinanceAPI.testNetEndpoint);
    if(webSocketManager != null){
      // Gửi tin nhắn định kỳ sau mỗi 3 giây
      Timer.periodic(const Duration(seconds: 3), (timer) async{
        final process = await BinanceAPI.getWsAccountInformation(webSocketManager);
        print(process);
      });

      // Lắng nghe các phản hồi từ WebSocket
      webSocketManager?.listenForResponses((dynamic response) {
        handleResponse(response);
      });
    }
  }


  void handleResponse(dynamic response) {
    try {
      // Xử lý phản hồi từ WebSocket
      final jsonData = json.decode(response);
      availableBalance = jsonData['result']['availableBalance'];
      // print('Received response: $jsonData');
      notifyListeners();
    } catch (e) {
      print('Error processing response: $e');
    }
  }
}
