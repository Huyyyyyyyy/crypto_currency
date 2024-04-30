import 'dart:async';
import 'dart:convert';
import 'package:crypto_currency/model/position_stream/positions_stream.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/cupertino.dart';
import '../../services/web_socket_configuration/websocket_manager.dart';

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
  String infoId = '';
  String posId = '';
  List<PositionStreams> currentPositions = [];

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
    if (webSocketManager != null) {
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        final processInfoAccountId = await BinanceAPI.getWsAccountInformation(
            webSocketManager);
        infoId = processInfoAccountId.toString();
        final processPositionAccountId = await BinanceAPI.getWsAccountPositions(
            webSocketManager);
        posId = processPositionAccountId.toString();
      });

      webSocketManager?.listenForResponses((dynamic response) {
        handleResponse(response);
      });
    }
  }


  void handleResponse(dynamic response) {
    try {
      final jsonData = json.decode(response);

      String responseId = jsonData['id'] ?? '';

      if (responseId == infoId) {
        handleInfoResponse(jsonData);
      } else if (responseId == posId) {
        handlePositionResponse(jsonData);
      }

      notifyListeners();
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  void handleInfoResponse(Map<String, dynamic> jsonData) {
    availableBalance = jsonData['result']['availableBalance'];
  }

  void handlePositionResponse(Map<String, dynamic> jsonData) {
    List<dynamic> results = jsonData['result'];
    Map<String, Map<String, PositionStreams>> symbolPositions = {};
    List<dynamic> filteredResults = results.where((obj) =>obj['updateTime'] > 0).toList();

    for (var result in filteredResults) {
      String symbol = result['symbol'];
      String positionSide = result['positionSide'];

      if (!symbolPositions.containsKey(symbol)) {
        symbolPositions[symbol] = {};
      }

      if (!symbolPositions[symbol]!.containsKey(positionSide)) {
        PositionStreams newPosition = PositionStreams.fromJson(result);
        symbolPositions[symbol]![positionSide] = newPosition;
      } else {
        symbolPositions[symbol]![positionSide]!.updateFromJson(result);
      }
    }

    currentPositions = [];
    symbolPositions.values.forEach((sideMap) {
      currentPositions.addAll(sideMap.values);
    });

    // for (var position in positions) {
    //   print('coin: ${position.symbol} , side : ${position.positionSide} , PnL : ${position.unRealizedProfit}');
    // }
  }
}

