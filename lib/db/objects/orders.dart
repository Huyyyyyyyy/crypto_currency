import 'package:crypto_currency/db/sqlite_configuration/sqlite_config.dart';
import 'package:crypto_currency/db/table/table.dart';
import 'package:crypto_currency/services/global_key_storage/global_setting.dart';
import 'package:crypto_currency/services/trade_service/trade_function.dart';
import 'package:sqflite/sqflite.dart';
class Orders {
   String clientOrderId = '';
   String orderId = '';
   String symbol = '';
   String positionSide = '';
   String status = '';
   String updateTime = '';
   String apiKey = '';

  Orders({
    required this.clientOrderId,
    required this.orderId,
    required this.symbol,
    required this.positionSide,
    required this.status,
    required this.updateTime,
    required this.apiKey
  });

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
      clientOrderId: json["client_order_id"] as String? ?? '',
      orderId: json["order_id"] as String? ?? '',
      symbol: json["symbol"] as String? ?? '',
      positionSide: json["position_side"] as String? ?? '',
      status: json["status"] as String? ?? '',
      updateTime: json["update_time"] as String? ?? '',
      apiKey: json["api_key"] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {
    "client_order_id" : clientOrderId,
    "order_id" : orderId,
    "symbol" : symbol,
    "position_side" :positionSide,
    "status" : status,
    "update_time": updateTime,
    "api_key" : apiKey
  };


  static Future<bool> addPositions(Orders newOrders) async {
    try{
      Database db = await SQLiteConfiguration().openDB();
      if(await checkOrderExistOrNot(db, newOrders) == true){
        await db.insert(Table.ORDERS,  newOrders.toMap());
        print('add position successfully');
        return true;
      }
      else
      {
        await updatePosition(db, newOrders);
        return true;
      }
    }on Exception catch(_){
      print('add position false');
      return false;
    }
  }

  static Future<bool> checkOrderExistOrNot (Database db ,Orders newOrders) async {
    try {
      List<Map<String, dynamic>> existingOrder = await db.query(
        Table.ORDERS,
        where: 'symbol = ? AND position_side = ?',
        whereArgs: [newOrders.symbol, newOrders.positionSide],
      );

      if (existingOrder.isEmpty) {
        print('check exist completely ! insert next');
        return true;
      }
      return false;
    }on Exception catch(_){
      print('add position false');
      return false;
    }
  }

  static Future<bool> updatePosition (Database db, Orders newOrders) async {
    try {
      await db.update(
        Table.ORDERS,
        newOrders.toMap(),
        where: 'symbol = ? AND position_side = ?',
        whereArgs: [newOrders.symbol, newOrders.positionSide],
      );
      print('update position completely');
      return true;
    }on Exception catch(_){
      print('update position false');
      return false;
    }
  }

  static Future<List<Orders>> getPositions (String apiKey) async{
    List<Map<String,Object?>> result ;
    Database db = await SQLiteConfiguration().openDB();
    result = await db.rawQuery("select * from orders where api_key = '$apiKey' and status = 'NEW'");
    print('get positions success');

    return result.map((e) => Orders.fromMap(e)).toList();
  }
}