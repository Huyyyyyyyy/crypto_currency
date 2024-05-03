abstract class ProjectKeys {
  static const appName = 'phong crypto';
  static const globalAverage = 'Global average';
  static const trend = 'Trend';
  static const technicals = 'Technicals';
  static const transaction = 'Transaction';
  static const eur = 'USD';
  static const usd = 'USD';
  static const twentyFourHourHighEuro = '24H High (USD)';
  static const twentyFourHourLowEuro = '24H Low (USD)';
  static const twentyFourVol = '24H Vol';
  static const cap = 'Cap (USD)';
  static String circulation(String coinName) {
    return 'Circulation ($coinName)';
  }

  static const error = 'Error';
  static const notFound = 'Not Found';
}
