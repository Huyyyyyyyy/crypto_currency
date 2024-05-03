class Orders {
   String clientOrderId = '';
   String orderId = '';
   String symbol = '';
   String side = '';
   String type = '';
   String positionSide = '';
   String status = '';
   String timestamp = '';

  Orders({
    required this.clientOrderId,
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.type,
    required this.positionSide,
    required this.status,
    required this.timestamp
  });

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
      clientOrderId: json["clientOrderId"],
      orderId: json["orderId"],
      symbol: json["symbol"],
      side: json["side"],
      type: json["type"],
      positionSide: json["positionSide"],
      status: json["status"],
      timestamp: json["timestamp"]
  );

  Map<String, dynamic>  toMap() => {
    "clientOrderId" : clientOrderId,
    "orderId" : orderId,
    "symbol" : symbol,
    "side" : side,
    "type" : type,
    "positionSide" :positionSide,
    "status" : status,
    "timestamp": timestamp
  };
}