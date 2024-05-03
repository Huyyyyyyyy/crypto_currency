class PositionStreams {
  String clientOrderId;
  String orderId;
  final String symbol;
  String positionAmt;
  String entryPrice;
  String breakEvenPrice;
  String markPrice;
  String unRealizedProfit;
  String liquidationPrice;
  String leverage;
  String maxNotionalValue;
  String marginType;
  String isolatedMargin;
  String isAutoAddMargin;
  String positionSide;
  String notional;
  String isolatedWallet;
  int updateTime;
  bool isolated;
  int adlQuantile;
  String marginRatio = '0.0';

  PositionStreams({
    required this.clientOrderId,
    required this.orderId,
    required this.symbol,
    required this.positionAmt,
    required this.entryPrice,
    required this.breakEvenPrice,
    required this.markPrice,
    required this.unRealizedProfit,
    required this.liquidationPrice,
    required this.leverage,
    required this.maxNotionalValue,
    required this.marginType,
    required this.isolatedMargin,
    required this.isAutoAddMargin,
    required this.positionSide,
    required this.notional,
    required this.isolatedWallet,
    required this.updateTime,
    required this.isolated,
    required this.adlQuantile,
    required this.marginRatio
  });

  // Tạo đối tượng Position từ JSON
  factory PositionStreams.fromJson(Map<String, dynamic> json) {
    return PositionStreams(
      clientOrderId: json['clientOrderId'],
      orderId: json['orderId'],
      symbol: json['symbol'],
      positionAmt: json['positionAmt'],
      entryPrice: json['entryPrice'],
      breakEvenPrice: json['breakEvenPrice'],
      markPrice: json['markPrice'],
      unRealizedProfit: json['unRealizedProfit'],
      liquidationPrice: json['liquidationPrice'],
      leverage: json['leverage'],
      maxNotionalValue: json['maxNotionalValue'],
      marginType: json['marginType'],
      isolatedMargin: json['isolatedMargin'],
      isAutoAddMargin: json['isAutoAddMargin'],
      positionSide: json['positionSide'],
      notional: json['notional'],
      isolatedWallet: json['isolatedWallet'],
      updateTime: json['updateTime'],
      isolated: json['isolated'],
      adlQuantile: json['adlQuantile'],
      marginRatio : json['marginRatio'],
    );
  }

  void updateFromJson(Map<String, dynamic> json) {
    clientOrderId = json['clientOrderId'];
    orderId = json['orderId'];
    positionAmt = json['positionAmt'];
    entryPrice = json['entryPrice'];
    breakEvenPrice = json['breakEvenPrice'];
    markPrice = json['markPrice'];
    unRealizedProfit = json['unRealizedProfit'];
    liquidationPrice = json['liquidationPrice'];
    leverage = json['leverage'];
    maxNotionalValue = json['maxNotionalValue'];
    marginType = json['marginType'];
    isolatedMargin = json['isolatedMargin'];
    isAutoAddMargin = json['isAutoAddMargin'];
    notional = json['notional'];
    isolatedWallet = json['isolatedWallet'];
    updateTime = json['updateTime'];
    isolated: json['isolated'];
    adlQuantile: json['adlQuantile'];
    marginRatio : json['marginRatio'];
  }
}