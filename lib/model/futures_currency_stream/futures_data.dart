import 'dart:convert';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:crypto_currency/services/web_socket_configuration/websocket_manager.dart';
import 'package:crypto_currency/services/global_key_storage/global_setting.dart';
import 'package:flutter/material.dart';

class FuturesData with ChangeNotifier {
  String symbol = 'BTCUSDT';
  String volume = 'N/A';
  String price = 'N/A';
  double priceChangePercentage = 0.0;
  String fundingRates = 'N/A';
  int nextFundingTime = 0;
  WebSocketManager? webSocketManager;
  WebSocketManager? websocketForFundingTime;
  WebSocketManager? websocketForAggTrade;
  WebSocketManager? websocketForMarkPrice;

  List<String> livePrices = [];
  List<String> quantity = [];

  String lastPrice = '0.0';
  String lowPrice = '0.0';

  String priceMarket = '0.0';

  String maxPrice = '0.0';
  String minprice = '0.0';

  FuturesData() {
    connectAndUpdateData();
  }

  @override
  void dispose() {
    disconnectWebSocket();
    super.dispose();
  }

  void updateLivePrices(String newPrice){
      // Làm tròn output đến 3 chữ số thập phân
      double output = double.tryParse(newPrice) ?? 0.0;
      String formattedOutput = output.toStringAsFixed(3);
      if(livePrices.length < 20){
        livePrices.add(formattedOutput);
      }else{
        livePrices.removeAt(0);
        livePrices.add(formattedOutput);
      }
  }

  void updateAggTrade(String newQuantityString, String newPriceString){
    double newQuantity = double.tryParse(newQuantityString) ?? 0.0;
    double newPrice = double.tryParse(newPriceString) ?? 0.0;
    double output = newQuantity * newPrice;

    String formattedOutput = output.toStringAsFixed(3);

    if (output >= 1000) {
      double outputInK = output / 1000;
      formattedOutput = '${outputInK.toStringAsFixed(2)}K';
    }

    if (quantity.length < 20) {
      quantity.add(formattedOutput);
    } else {
      quantity.removeAt(0);
      quantity.add(formattedOutput);
    }
  }


  void disconnectWebSocket() {
    webSocketManager?.close();
    websocketForFundingTime?.close();
    websocketForAggTrade?.close();
  }


  void connectAndUpdateData() async {
    disconnectWebSocket();

    String url = await GlobalSettings.getUrl();
    String urlFundingTime = await GlobalSettings.getUrlFundingTime();
    String urlAggTrade = await GlobalSettings.getUrlAggTrade();

    webSocketManager = WebSocketManager(url);
    websocketForFundingTime = WebSocketManager(urlFundingTime);
    websocketForAggTrade = WebSocketManager(urlAggTrade);

    await webSocketManager?.stream.listen((data) {
      final jsonData = json.decode(data);
      // Cập nhật giả định các trường dữ liệu từ jsonData
      symbol = jsonData['s'];
      volume = '\$${jsonData['q']}';
      price = '\$${jsonData['c']}';
      priceChangePercentage = double.tryParse(jsonData['P'].toString()) ?? 0.0;
      lastPrice = '${jsonData['c']}';
      lowPrice = '${jsonData['l']}';
      priceMarket = '${jsonData['c']}';
      // Cập nhật UI
      notifyListeners();
    }, onError: (error) {
      // Xử lý lỗi
      print('WebSocket error: $error');
      // Reconnect WebSocket
      webSocketManager = WebSocketManager(url);
    }, onDone: () {
      // Xử lý khi kết thúc WebSocket
      print('socket close');
    });

    await websocketForFundingTime?.stream.listen((data) {
      final jsonFunding = json.decode(data);

      fundingRates = '${jsonFunding['r']}';
      nextFundingTime = jsonFunding['T'];

      notifyListeners();
    }, onError: (error) {
      // Xử lý lỗi
      print('WebSocket error: $error');
      // Reconnect WebSocket
      websocketForFundingTime = WebSocketManager(urlFundingTime);
    }, onDone: () {
      // Xử lý khi kết thúc WebSocket
      print('socket funding close');
    });

    await websocketForAggTrade?.stream.listen((data) {
      final jsonAggTrade = json.decode(data);

      Future.delayed(const Duration(milliseconds: 2000), () {
        updateLivePrices('${jsonAggTrade['p']}');
        updateAggTrade('${jsonAggTrade['q']}','${jsonAggTrade['p']}');
        notifyListeners();
      });
    }, onError: (error) {
      // Xử lý lỗi
      print('WebSocket error: $error');
      // Reconnect WebSocket
      websocketForAggTrade = WebSocketManager(urlAggTrade);
    }, onDone: () {
      // Xử lý khi kết thúc WebSocket
      print('socket agg trade close');
    });


    //update exchange Information
    String exchangeInfo = await BinanceAPI.getExchangeInfo(symbol);


    final jsonData = json.decode(exchangeInfo);

    if (jsonData.containsKey('symbols')) {
      List<dynamic> symbols = jsonData['symbols'];
      if (symbols.isNotEmpty) {
        Map<dynamic, dynamic> symbolInfo = symbols.firstWhere((symbol) => symbol['symbol'] == this.symbol, orElse: () => {});
        if (symbolInfo.isNotEmpty) {
          List<dynamic> filters = symbolInfo['filters'];
          Map<dynamic, dynamic> priceFilter = filters.firstWhere((filter) => filter['filterType'] == 'PRICE_FILTER', orElse: () => {});
          double doubleMaxPrice = double.parse(priceFilter['maxPrice']);
          double doubleMinPrice = double.parse(priceFilter['minPrice']);
          maxPrice = doubleMaxPrice.toStringAsFixed(1);
          minprice = doubleMinPrice.toStringAsFixed(1);
        } else {
          print('Symbol not found');
        }
      } else {
        print('No symbols found');
      }
    } else {
      print('No symbols key found');
    }

  }
}
