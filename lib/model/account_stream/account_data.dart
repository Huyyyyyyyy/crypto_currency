import 'dart:async';
import 'dart:convert';
import 'package:crypto_currency/model/position_stream/positions_stream.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/cupertino.dart';
import '../../services/web_socket_configuration/websocket_manager.dart';

class AccountData with ChangeNotifier {
  WebSocketManager? webSocketManager;
  WebSocketManager? socketForPrice;
  String accountAlias = '';
  String asset = '';
  String balance = '0.0';
  String crossWalletBalance = '0.0';
  String totalMaintMargin = '0.0';
  String totalMarginBalance = '0.0';
  String crossUnPnl = '0.0';
  String availableBalance = '0.0';
  String maxWithdrawAmount = '0.0';
  String marginAvailable = '';
  String marginRatio = '0.0';
  String updateTime = '';
  String infoId = '';
  String posId = '';
  String balId = '';
  String priceId = '';
  List<PositionStreams> currentPositions = [];
  Map<String, StreamController<String>> priceStreamControllers = {};

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
        final processInfoAccountId = await BinanceAPI.getWsAccountInformation(webSocketManager);
        infoId = processInfoAccountId.toString();
        final processPositionAccountId = await BinanceAPI.getWsAccountPositions(webSocketManager);
        posId = processPositionAccountId.toString();
        final processBalanceAccountId = await BinanceAPI.getWsAccountBalance(webSocketManager);
        balId = processBalanceAccountId.toString();
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
      } else if (responseId == balId) {
        handleBalanceResponse(jsonData);
      }

      notifyListeners();
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  void handleInfoResponse(Map<String, dynamic> jsonData) {
    availableBalance = jsonData['result']['availableBalance'];
    totalMarginBalance = jsonData['result']['totalMarginBalance'];
    totalMaintMargin = jsonData['result']['totalMaintMargin'];
    marginRatio = BinanceAPI.calculateMarginRatio(double.parse(totalMaintMargin), double.parse(totalMarginBalance));
  }

  void handleBalanceResponse(Map<String, dynamic> jsonData) {
    List<dynamic> results = jsonData['result'];
    List<dynamic> filteredResults = results.where((obj) =>
    double.parse(obj['balance']) > 0).toList();
    for (var result in filteredResults) {
      balance = result['balance'];
    }
  }

  void handlePositionResponse(Map<String, dynamic> jsonData) async {
    List<dynamic> results = jsonData['result'];
    Map<String, Map<String, PositionStreams>> symbolPositions = {};
    List<String> uniqueSymbols = [];

    List<dynamic> filteredResults = results.where((obj) {
      return obj['updateTime'] > 0 && double.parse(obj['positionAmt']) != 0;
    }).toList();

    for (var result in filteredResults) {
      String symbol = result['symbol'];
      String positionSide = result['positionSide'];

      if (!symbolPositions.containsKey(symbol)) {
        symbolPositions[symbol] = {};
      }
      
      result['marginRatio'] = marginRatio;

      if (!symbolPositions[symbol]!.containsKey(positionSide)) {
        PositionStreams newPosition = PositionStreams.fromJson(result);
        symbolPositions[symbol]![positionSide] = newPosition;
      } else {
        symbolPositions[symbol]![positionSide]!.updateFromJson(result);
      }

      if (!uniqueSymbols.contains(symbol)) {
        uniqueSymbols.add(symbol);
      }
    }

    currentPositions = [];
    symbolPositions.values.forEach((sideMap) {
      currentPositions.addAll(sideMap.values);
    });

    updateCurrentPrices(uniqueSymbols);

    notifyListeners();
  }


  void updateCurrentPrices(List<String> symbols) async{
    for (String symbol in symbols) {
      // Tạo StreamController mới cho mỗi symbol nếu chưa tồn tại
      {
        StreamController<String> priceStreamController = StreamController<String>();
        priceStreamControllers[symbol] = priceStreamController;

        socketForPrice = WebSocketManager(BinanceAPI.testNetEndpoint);
        priceId = await BinanceAPI.getWsCurrentPrice(socketForPrice, symbol);

        socketForPrice?.listenForResponses((response) {
          final jsonData = json.decode(response);
          if (jsonData['id'].toString() == priceId && jsonData['result']['symbol'] == symbol) {
            String currentPrice = jsonData['result']['price'].toString();
            priceStreamController.add(currentPrice);
            updatePositionCurrentPrice(symbol, currentPrice);
          }
        });

      }
    }
  }


  void updatePositionCurrentPrice(String symbol, String currentPrice) {
    for (PositionStreams position in currentPositions) {
      if (position.symbol == symbol) {
        position.currentPrice = currentPrice;
        // print('${position.symbol} : ${position.currentPrice}');
      }
    }
  }
}

