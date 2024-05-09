import 'dart:async';
import 'dart:convert';
import 'package:crypto_currency/model/position_stream/positions_stream.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import '../../db/objects/orders.dart';
import '../../services/global_key_storage/global_setting.dart';
import '../../services/web_socket_configuration/websocket_manager.dart';
import '../assets_stream/assets_streams.dart';

class AccountData with ChangeNotifier {
  WebSocketManager? webSocketManager;
  String accountAlias = '';
  String asset = '';
  String balance = '0.0';
  String crossWalletBalance = '0.0';
  String totalInitialMargin = '0.0';
  String totalMaintMargin = '0.0';
  String totalMarginBalance = '0.0';
  String totalUnrealizedProfit = '0.0';
  String totalCrossUnPnl = '0.0';
  String availableBalance = '0.0';
  String maxWithdrawAmount = '0.0';
  String marginAvailable = '';
  String marginRatio = '0.0';
  String updateTime = '';
  String infoId = '';
  String posId = '';
  String balId = '';
  String startUserId = '';
  String pingUserId = '';
  String listenKey = '';
  List<PositionStreams> currentPositions = [];
  List<AssetStream> currentAssets = [];

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

      if(listenKey.isEmpty || listenKey == ''){
        final processStartUserDataStream = await BinanceAPI.startWsUserDataStream(webSocketManager);
        startUserId = processStartUserDataStream;
      }

      Timer.periodic(const Duration(minutes: 50), (timer) async {
        final processPingUserDataStream = await BinanceAPI.pingWsUserDataStream(webSocketManager, listenKey);
        pingUserId = processPingUserDataStream;
      });

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
      } else if (responseId == startUserId) {
        handleStartUserResponse(jsonData);
      } else if (responseId == pingUserId){
        handlePingUserResponse(jsonData);
      }

      notifyListeners();
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  void handleInfoResponse(Map<String, dynamic> jsonData) {
    Map<String, dynamic> result = jsonData['result'];

    availableBalance = jsonData['result']['availableBalance'];
    totalMarginBalance = jsonData['result']['totalMarginBalance'];
    totalMaintMargin = jsonData['result']['totalMaintMargin'];
    totalInitialMargin = jsonData['result']['totalInitialMargin'];
    totalUnrealizedProfit = jsonData['result']['totalUnrealizedProfit'];
    totalCrossUnPnl = jsonData['result']['totalCrossUnPnl'];
    marginRatio = BinanceAPI.calculateMarginRatio(double.parse(totalMaintMargin), double.parse(totalMarginBalance));
    List<dynamic> listAssets = result['assets'].toList();


    Map<String, AssetStream> assetSymbol = {}; // Change to hold AssetStream directly
    for (var assetData in listAssets) {
      String asset = assetData['asset'];

      if (!assetSymbol.containsKey(asset)) {
        // If asset doesn't exist, create a new AssetStream
        assetSymbol[asset] = AssetStream.fromJson(assetData);
      } else {
        // If asset exists, update its data
        assetSymbol[asset]!.updateFromJson(assetData);
      }
    }
    currentAssets = [];
    for (var asset in assetSymbol.values) {
      currentAssets.add(asset);
    }
      notifyListeners();
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

    List<dynamic> filteredResults = results.where((obj) {
      return obj['updateTime'] > 0 && double.parse(obj['positionAmt']) != 0;
    }).toList();

    String apiKey = await GlobalSettings.getApiKey();

    List<Orders> listOrders = await Orders.getPositions(apiKey);
    Map<String, Map<String, String>> orderInfoMap = {};

    for (var order in listOrders) {
      String clientOrderId = order.clientOrderId;
      String orderId = order.orderId;

      // Use a composite key (symbol + positionSide) to store clientOrderId and orderId
      String key = '${order.symbol}-${order.positionSide}';
      orderInfoMap[key] = {
        'clientOrderId': clientOrderId,
        'orderId': orderId,
      };
    }

    for (var result in filteredResults) {
      String symbol = result['symbol'];
      String positionSide = result['positionSide'];

      String key = '$symbol-$positionSide';
      if (orderInfoMap.containsKey(key)) {
        result['clientOrderId'] = orderInfoMap[key]!['clientOrderId'];
        result['orderId'] = orderInfoMap[key]!['orderId'];
      }

      if (!symbolPositions.containsKey(symbol)) {
        symbolPositions[symbol] = {};
      }
      
      result['marginRatio'] = marginRatio;
      // print(result);

      if (!symbolPositions[symbol]!.containsKey(positionSide)) {
        PositionStreams newPosition = PositionStreams.fromJson(result);
        symbolPositions[symbol]![positionSide] = newPosition;
      } else {
        symbolPositions[symbol]![positionSide]!.updateFromJson(result);
      }

    }
    currentPositions = [];
    for (var sideMap in symbolPositions.values) {
      currentPositions.addAll(sideMap.values);
    }

    notifyListeners();
  }

  void handleStartUserResponse(Map<String, dynamic> jsonData) {
    print(jsonData);
    listenKey = jsonData['result']['listenKey'];
  }

  void handlePingUserResponse(Map<String, dynamic> jsonData) {
    listenKey = jsonData['result']['listenKey'];
  }
}

