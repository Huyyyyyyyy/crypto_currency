class SideOrder {
  static const String BUY = 'BUY';
  static const String SELL = 'SELL';
}

class PositionSide {
  static const String LONG = 'LONG';
  static const String SHORT = 'SHORT';
}

class TypeOrder{
  static const String LIMIT = 'LIMIT';
  static const String MARKET = 'MARKET';
  static const String STOP_TAKE_PROFIT = 'STOP/TAKE_PROFIT';
  static const String STOP_TAKE_PROFIT_MARKET = 'STOP_MARKET/TAKE_PROFIT_MARKET';
  static const String TRAILING_STOP_MARKET = 'TRAILING_STOP_MARKET';
}

class additionalForLimit {
  static const String TIME_INFORCE = 'GTC';
  static double QUANTITY = 0.0;
  static String PRICE = '0.0';
  static const int recvWindow = 9999999;
}