import 'package:crypto_currency/model/enum/enum_order.dart';

class OrderModel {
  String symbol = '';
  String side = SideOrder.BUY;
  String type = TypeOrder.LIMIT;

  //if use LIMIT
  String timeInforce = additionalForLimit.TIME_INFORCE;
  double quantity = additionalForLimit.QUANTITY;
  String priceMarket = additionalForLimit.PRICE;
  String priceLimit = additionalForLimit.PRICE;
  //if use LIMIT

  late int timestamp;
  int recvWindow = 9999999;


  OrderModel(String orderSymbol, String orderSide, String orderType, String timeInforce, double quantity, int orderRecvWindow, String priceLimit, String priceMarket) {
    symbol = orderSymbol;
    side = orderSide;
    type = orderType;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    recvWindow = orderRecvWindow;
    if(type == TypeOrder.LIMIT){
      this.timeInforce = timeInforce;
      this.quantity = quantity;
      this.priceLimit = priceLimit;
    }else if (type == TypeOrder.MARKET){
      this.priceLimit = priceMarket;
      this.quantity = quantity;
      this.priceMarket = priceMarket;
    }
  }
}
