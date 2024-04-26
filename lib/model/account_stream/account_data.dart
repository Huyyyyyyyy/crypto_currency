import 'package:flutter/cupertino.dart';
import '../../services/global_setting.dart';
import '../../services/websocket_manager.dart';

class AccountData with ChangeNotifier{
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
    String url = await GlobalSettings.getUrl();

    webSocketManager = WebSocketManager(url);

  }
}