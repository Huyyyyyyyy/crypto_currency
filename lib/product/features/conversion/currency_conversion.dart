class CurrencyConversion {
  String convertUsdToEuro(num usdValue) {
    final eurResult = usdValue * 1.00;
    return eurResult.toStringAsFixed(2);
  }
}
