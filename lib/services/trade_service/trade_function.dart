import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:crypto_currency/model/enum/enum_order.dart';
import 'package:crypto_currency/model/order_future/order_model.dart';
import 'package:crypto_currency/services/trade_service/filter_variables.dart';
import 'package:crypto_currency/services/web_socket_configuration/websocket_manager.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class BinanceAPI {
  static const String apiKey = 'c1190246c854f0c5cabc136a6d6477cfd0397bb4d1c8c1564e80d7853d7bd337';
  static const String apiSecret = '485a1c2aeab09ef00b7d4f5371aba2e41c796a72f63204e7338247a819d9a318';
  static const String endpoint = 'https://testnet.binancefuture.com';
  static const String baseUrl = 'https://api.binance.com';
  static const String testNetBaseWebSocket = 'wss://fstream.binancefuture.com';
  static const String testNetEndpoint = 'wss://testnet.binancefuture.com/ws-fapi/v1';


  //area for trading feature (base API)
  static Future<void> getBalance() async{
    try{
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String query = 'recvWindow=9999999&timestamp=$timestamp';

      String signature = generateSignature(query, apiSecret);
      String params = '$query&signature=$signature';

      final response = await http.get(
        Uri.parse('$endpoint/fapi/v2/balance?$params'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to fetch data: ${response.body}');
      }
    }catch (error) {
      print('Error fetching data: $error');
    }
  }

  static Future<String> getExchangeInfo(String symbol) async {
    try {
      String query = 'symbol=$symbol';

      final response = await http.get(
        Uri.parse('$baseUrl/api/v3/exchangeInfo?$query'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  static Future<String> getMarkPrice(String symbol) async {
    try {
      String query = 'symbol=$symbol';
      final response = await http.get(
        Uri.parse('$endpoint/fapi/v1/premiumIndex?$query'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['markPrice'];
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  static Future<FilterVariables> filterTheOrder(String exchangeInfo, String targetSymbol) async {

    FilterVariables filterVariables = FilterVariables(0,0,0,0,0,0,0,0,0,0,0);
    final jsonData = json.decode(exchangeInfo);

    if (jsonData.containsKey('symbols')) {
      List<dynamic> symbols = jsonData['symbols'];
      if (symbols.isNotEmpty) {
        Map<dynamic, dynamic> symbolInfo = symbols.firstWhere((symbol) => symbol['symbol'] == targetSymbol, orElse: () => {});
        if (symbolInfo.isNotEmpty) {
          List<dynamic> filters = symbolInfo['filters'];
          Map<dynamic, dynamic> priceFilter = filters.firstWhere((filter) => filter['filterType'] == 'PRICE_FILTER', orElse: () => {});
          Map<dynamic, dynamic> percentPrice = filters.firstWhere((filter) => filter['filterType'] == 'PERCENT_PRICE_BY_SIDE', orElse: () => {});
          Map<dynamic, dynamic> lotSize = filters.firstWhere((filter) => filter['filterType'] == 'LOT_SIZE', orElse: () => {});
          Map<dynamic, dynamic> minNotional = filters.firstWhere((filter) => filter['filterType'] == 'NOTIONAL', orElse: () => {});
          Map<dynamic, dynamic> maxNumOrders = filters.firstWhere((filter) => filter['filterType'] == 'MAX_NUM_ORDERS', orElse: () => {});

            filterVariables.minPrice = double.parse(priceFilter['minPrice']);
            filterVariables.maxPrice = double.parse(priceFilter['maxPrice']);
            filterVariables.tickSize = double.parse(priceFilter['tickSize']);
            Future<String> getMarkPrices = getMarkPrice(targetSymbol);
            String markPrice = await getMarkPrices;
            filterVariables.markPrice =double.parse(markPrice);

            filterVariables.minQty = double.parse(lotSize['minQty']);
            filterVariables.maxQty = double.parse(lotSize['maxQty']);
            filterVariables.stepSize = double.parse(lotSize['stepSize']);
            //
            filterVariables.limit = maxNumOrders['maxNumOrders'] as int;
            //
            filterVariables.multiplierUp = double.parse(percentPrice['bidMultiplierUp']);
            filterVariables.multiplierDown = double.parse(percentPrice['bidMultiplierDown']);
            //
            filterVariables.notional = double.parse(minNotional['minNotional']);

        } else {
          print('Symbol not found');
        }
      } else {
        print('No symbols found');
      }
    } else {
      print('No symbols key found');
    }

    return filterVariables;
  }

  static Future<void> createNewOrderFuture(OrderModel newOrder) async {
    try {

      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String goodTillDateTimestamp = DateTime.now().add(const Duration(minutes: 15)).millisecondsSinceEpoch.toString();

      String exchangeInfo = await getExchangeInfo(newOrder.symbol);

      FilterVariables filterVariables = await filterTheOrder(exchangeInfo, newOrder.symbol);

      if (newOrder.quantity < filterVariables.minQty || newOrder.quantity > filterVariables.maxQty) {
        print('${newOrder.quantity}, min : ${filterVariables.minQty}, max: ${filterVariables.maxQty}');
        print('[BINACE-LOT-SIZE] Your order is outside the allowed quantity range.');
        return;
      }

      if(double.parse(newOrder.priceLimit) < filterVariables.minPrice || double.parse(newOrder.priceLimit) > filterVariables.maxPrice ) {
        print('${newOrder.priceLimit}, min : ${filterVariables.minPrice}, max: ${filterVariables.maxPrice}');
        print('[BINACE-PRICE-FILTER] Your order price is outside the allowed price range');
        return;
      }

      if (newOrder.side == SideOrder.BUY){
        if(double.parse(newOrder.priceLimit) > filterVariables.markPrice*filterVariables.multiplierUp){
          print(filterVariables.markPrice*filterVariables.multiplierUp);
          print('[BINACE-PERCENT-PRICE] Your order is not divisible by the valid range for a price base on the market price');
          return;
        }
      }

      if (newOrder.side == SideOrder.SELL){
        if(double.parse(newOrder.priceLimit) < filterVariables.markPrice*filterVariables.multiplierDown){
          print('[BINACE-PERCENT-PRICE] Your order is not divisible by the valid range for a price base on the market price');
          return;
        }
      }

      if(newOrder.type == TypeOrder.LIMIT){
        if((newOrder.quantity * double.parse(newOrder.priceLimit)) < filterVariables.notional){
          print('[BINACE-MIN-NOTIONAL] Your order is not divisible by the minimum notional');
          return;
        }
      }

      if (newOrder.type == TypeOrder.MARKET){
        print('quantity: ${newOrder.quantity}, market: ${newOrder.priceMarket}');
        if((newOrder.quantity * double.parse(newOrder.priceMarket)) < filterVariables.notional){
          print('[BINACE-MIN-NOTIONAL] Your order is not divisible by the minimum notional');
          return;
        }
      }

      {
        double tickSize = filterVariables.tickSize;

        // Làm tròn các giá trị cần thiết trước khi tính toán
        newOrder.priceLimit =(await roundQuantity(double.parse(newOrder.priceLimit) , tickSize)).toString();
        double minPrice = filterVariables.minPrice;
        await roundQuantity(newOrder.quantity, filterVariables.stepSize).then((roundedValue) {
          newOrder.quantity = roundedValue;
        });

        print('limit: ${newOrder.priceLimit}, quantity: ${newOrder.quantity} , min: $minPrice, tick: $tickSize, step: ${filterVariables.stepSize}');

        double differenceQuant = (newOrder.quantity - filterVariables.minQty);
        double roundedDifferenceQuant = differenceQuant % filterVariables.stepSize;

        if (roundedDifferenceQuant.floorToDouble() != 0) {
          print(roundedDifferenceQuant);
          print('[BINANCE-LOT-SIZE] Order quantity is not divisible by the step size.');
          return;
        }

        double differencePrice = (double.parse(newOrder.priceLimit) - minPrice);
        print(differencePrice);
        double roundedDifferencePrice = differencePrice % tickSize;
        int lastCondition = roundedDifferencePrice.floor();

        if ( lastCondition != 0) {
          print(lastCondition);
          print('[BINACE-PRICE-FILTER] Your order quantity is not divisible by the tick size.');
          return;
        }

      }

      String query = '';

      if(newOrder.type == TypeOrder.LIMIT){
        query =
            'symbol=${newOrder.symbol}'
            '&side=${newOrder.side}'
            '&positionSide=${newOrder.positionSide}'
            '&type=${newOrder.type}'
            '&quantity=${newOrder.quantity}'
            '&recvWindow=${newOrder.recvWindow}'
            '&timestamp=$timestamp'
            '&price=${newOrder.priceLimit}'
            '&timeInforce=${newOrder.timeInforce}'
            '&goodTillDate=$goodTillDateTimestamp';

      }

      else if (newOrder.type == TypeOrder.MARKET)
      {
        query =
            'symbol=${newOrder.symbol}'
            '&side=${newOrder.side}'
            '&positionSide=${newOrder.positionSide}'
            '&type=${newOrder.type}'
            '&quantity=${newOrder.quantity}'
            '&recvWindow=${newOrder.recvWindow}'
            '&timestamp=$timestamp';
            // '&price=${newOrder.price}'
            // '&timeInforce=${newOrder.timeInforce}'
            // '&goodTillDate=$goodTillDateTimestamp';
      }


      String signature = generateSignature(query, apiSecret);
      String params = '$query&signature=$signature';


      final response = await http.post(
        Uri.parse('$endpoint/fapi/v1/order?$params'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  static Future<String> getListenKey() async {
    try {
      final response = await http.post(
        Uri.parse('$endpoint/fapi/v1/listenKey'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData['listenKey']);
        return jsonData['listenKey'];
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
  //area for trading feature (base API)


  //area for positions (WebSocket API)
  static Future<String> getWsAccountInformation(WebSocketManager? streamOfSocket) async {
    try{
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      const recvWindow = 9999999;

      final requestId = const Uuid().v4();
      const method = 'account.status';
      final params = {
        "apiKey": apiKey,
        "timestamp": timestamp,
        "recvWindow": recvWindow
      };

      // Generate signature
      final signature = generateSignatureV2(params, apiSecret);
      params['signature'] = signature;

      streamOfSocket?.sendRequest(requestId, method, params);
      return requestId;

    }catch(error){
      print('fail error: $error');
    }
    return 'information account : false';
  }

  static Future<String> getWsAccountPositions(WebSocketManager? streamOfSocket) async {
    try{
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      const recvWindow = 9999999;

      final requestId = const Uuid().v4();
      const method = 'account.position';
      final params = {
        "apiKey": apiKey,
        "timestamp": timestamp,
        "recvWindow": recvWindow
      };

      // Generate signature
      final signature = generateSignatureV2(params, apiSecret);
      params['signature'] = signature;


      streamOfSocket?.sendRequest(requestId, method, params);
      return requestId;

    }catch(error){
      print('fail error: $error');
    }
    return 'position account : false';
  }

  static Future<String> getWsAccountBalance(WebSocketManager? streamOfSocket) async {
    try{
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      const recvWindow = 9999999;

      final requestId = const Uuid().v4();
      const method = 'account.balance';
      final params = {
        "apiKey": apiKey,
        "timestamp": timestamp,
        "recvWindow": recvWindow
      };

      // Generate signature
      final signature = generateSignatureV2(params, apiSecret);
      params['signature'] = signature;


      streamOfSocket?.sendRequest(requestId, method, params);
      return requestId;

    }catch(error){
      print('fail error: $error');
    }
    return 'position account : false';
  }

  static Future<String> getWsCurrentPrice(WebSocketManager? streamOfSocket, String symbol) async {
    try{

      final requestId = const Uuid().v4();
      const method = 'ticker.price';
      final params = {
        "symbol" : symbol,
      };

      streamOfSocket?.sendRequest(requestId, method, params);

      return requestId;

    }catch(error){
      print('fail error: $error');
    }
    return 'position account : false';
  }

  //area for positions (WebSocket API)


  //area for account feature
  static Future<String?> getServerTime() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v3/time'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['serverTime']);
        return jsonData['serverTime'].toString();
      } else {
        print('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }

  static Future<void> getAccount() async {
    String? timestamp = await getServerTime();

    print(timestamp);
    int recvWindow = 5000; // Adjust the recvWindow value as needed

    String query = 'recvWindow=$recvWindow&timestamp=$timestamp';
    String signature = generateSignature(query, apiSecret);
    String params = '$query&signature=$signature';

    try {
      final response = await http.get(
        Uri.parse('$endpoint/fapi/v2/account?$params'),
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
  //area for account feature





  // area for function format
  static String generateSignature(String data, String secret) {
    var key = utf8.encode(secret);
    var bytes = utf8.encode(data);

    var hmac = Hmac(sha256, key); // Tạo một đối tượng HMAC sử dụng SHA256
    var digest = hmac.convert(bytes); // Tạo chữ ký

    return digest.toString(); // Trả về chữ ký dạng hex string
  }

  static String generateSignatureV2(Map<String, dynamic> params, String secretKey) {
    // Step 1: Construct the signature payload
    final sortedParams = Map.fromEntries(params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    final signaturePayload = _formatParams(sortedParams);

    // Step 2: Compute the signature
    String signature = generateSignature(signaturePayload, secretKey);

    return signature;
  }

  static String _formatParams(Map<String, dynamic> params) {
    final List<String> formattedParams = [];
    params.forEach((key, value) {
      formattedParams.add('$key=${value.toString()}');
    });
    return formattedParams.join('&');
  }

  static String calculateROI(double currentValue, double previousNetAssetValue) {
    double tNetAssetValue = currentValue / previousNetAssetValue * previousNetAssetValue;
    double roi = (tNetAssetValue - previousNetAssetValue) / previousNetAssetValue * 100;
    return roi.toString();
  }

  static String calculatePositionROI(double unRealizedPnl, double positionAmt, double markPrice, double leverage) {
    double roi = (unRealizedPnl / (absolute(positionAmt) * markPrice * (1/leverage))) * 100;
    return roi.toStringAsFixed(2);
  }

  static String calculateMargin (double leverage , double positionAmt, double markPrice){
    return absolute((1/leverage) * positionAmt * markPrice).toStringAsFixed(2);
  }

  static String calculateSizeOfPosition (double leverage , double positionAmt, double markPrice){
    return absolute(((1/leverage) * positionAmt * markPrice)*leverage).toStringAsFixed(4);
  }

  static String calculateMarginRatio (double totalMaintBalance, double walletBalance){
    return ((totalMaintBalance / walletBalance) * 100).toStringAsFixed(2);
  }

  static double calculateQuantityPerCost (double priceLimit, double cost){
    return cost / priceLimit;
  }

  static double absolute(double number) {
    return number < 0 ? -number : number;
  }

  static Future<double> roundToTickSize(double value, double tickSize) async{
    return (value / tickSize).round() * tickSize;
  }

  static Future<double> roundQuantity(double quantity, double stepSize) async {
    int decimalPlaces = stepSize.toStringAsFixed(8).replaceAll(RegExp(r'^.*\.|0+$'), '').length;
    print(decimalPlaces);
    double roundedQuantity = (quantity * (10.0 * decimalPlaces)).round() / (10.0 * decimalPlaces);
    return roundedQuantity;
  }

  // area for function format
}
