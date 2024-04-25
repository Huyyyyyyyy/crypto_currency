class FilterVariables {
  //filter variables
  double minPrice = 0.0;
  double maxPrice = 0.0;
  double tickSize = 0.0;
  double markPrice = 0.0;

  double multiplierUp = 0.0;
  double multiplierDown = 0.0;

  double minQty = 0.0;
  double maxQty = 0.0;
  double stepSize = 0.0;

  double notional = 0.0;

  int limit = 0;
//filter variables

  FilterVariables(
      double orderMinPrice,
      double orderMaxPrice,
      double orderTickSize,
      double orderMarkPrice,
      double orderMultiplierUp,
      double orderMultiplierDown,
      double orderMinQty,
      double orderMaxQty,
      double orderStepSize,
      double orderNotional,
      int orderLimit
      ){
    minPrice = orderMinPrice;
    maxPrice = orderMaxPrice;
    tickSize = orderTickSize;
    markPrice = orderMarkPrice;
    multiplierUp = orderMultiplierUp;
    multiplierDown = orderMultiplierDown;
    minQty = orderMinQty;
    maxQty = orderMaxQty;
    stepSize = orderStepSize;
    notional = orderNotional;
    limit  = orderLimit;
  }
}