class AssetStream {
  final String asset;
  final String walletBalance ;
  final String unrealizedProfit ;
  final String marginBalance ;
  final String maintMargin ;
  final String initialMargin ;
  final String positionInitialMargin ;
  final String openOrderInitialMargin ;
  final String crossWalletBalance ;
  final String crossUnPnl ;
  final String availableBalance ;
  final String maxWithdrawAmount ;
  final String marginAvailable ;
  final String updateTime ;


  AssetStream({
    required this.asset,
    required this.walletBalance,
    required this.unrealizedProfit,
    required this.marginBalance,
    required this.maintMargin,
    required this.initialMargin,
    required this.positionInitialMargin,
    required this.openOrderInitialMargin,
    required this.crossWalletBalance,
    required this.crossUnPnl,
    required this.availableBalance,
    required this.maxWithdrawAmount,
    required this.marginAvailable,
    required this.updateTime

  });

  // Tạo đối tượng Position từ JSON
  factory AssetStream.fromJson(Map<String, dynamic> json) {
    return AssetStream(
        asset : json['asset'].toString(),
        walletBalance : json['walletBalance'].toString() ,
        unrealizedProfit : json['unrealizedProfit'].toString(),
        marginBalance : json['marginBalance'].toString(),
        maintMargin : json['maintMargin'].toString(),
        initialMargin : json['initialMargin'].toString(),
        positionInitialMargin : json['positionInitialMargin'].toString(),
        openOrderInitialMargin : json['openOrderInitialMargin'].toString(),
        crossWalletBalance : json['crossWalletBalance'].toString(),
        crossUnPnl : json['crossUnPnl'].toString(),
        availableBalance : json['availableBalance'].toString(),
        maxWithdrawAmount : json['maxWithdrawAmount'].toString(),
        marginAvailable : json['marginAvailable'].toString(),
        updateTime : json['updateTime'].toString()
    );
  }

  void updateFromJson(Map<String, dynamic> json) {
    asset : json['asset'].toString();
    walletBalance : json['walletBalance'].toString() ;
    unrealizedProfit : json['unrealizedProfit'].toString();
    marginBalance : json['marginBalance'].toString();
    maintMargin : json['maintMargin'].toString();
    initialMargin : json['initialMargin'].toString();
    positionInitialMargin : json['positionInitialMargin'].toString();
    openOrderInitialMargin : json['openOrderInitialMargin'].toString();
    crossWalletBalance : json['crossWalletBalance'].toString();
    crossUnPnl : json['crossUnPnl'].toString();
    availableBalance : json['availableBalance'].toString();
    maxWithdrawAmount : json['maxWithdrawAmount'].toString();
    marginAvailable : json['marginAvailable'].toString();
    updateTime : json['updateTime'].toString();
  }
}