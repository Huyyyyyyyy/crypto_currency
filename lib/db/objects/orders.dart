import 'package:crypto_currency/db/sqlite_configuration/sqlite_config.dart';
import 'package:crypto_currency/db/table/table.dart';
import 'package:sqflite/sqflite.dart';
class Orders {
   String clientOrderId = '';
   String orderId = '';
   String symbol = '';
   String side = '';
   String type = '';
   String positionSide = '';
   String status = '';
   String updateTime = '';

  Orders({
    required this.clientOrderId,
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.type,
    required this.positionSide,
    required this.status,
    required this.updateTime
  });

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
      clientOrderId: json["clientOrderId"].toString(),
      orderId: json["orderId"].toString(),
      symbol: json["symbol"].toString(),
      side: json["side"].toString(),
      type: json["type"].toString(),
      positionSide: json["positionSide"].toString(),
      status: json["status"].toString(),
      updateTime: json["updateTime"].toString()
  );

  Map<String, dynamic>  toMap() => {
    "client_order_id" : clientOrderId,
    "order_id" : orderId,
    "symbol" : symbol,
    "side" : side,
    "type" : type,
    "position_side" :positionSide,
    "status" : status,
    "update_time": updateTime
  };


  static Future<bool> addPositions(Orders newOrders) async {
    try{
      Database db = await SQLiteConfiguration().openDB();
      await db.insert(Table.ORDERS,  newOrders.toMap());
      print('add position successfully');
      return true;
    }on Exception catch(_){
      print('add position false');
      return false;
    }
  }
}