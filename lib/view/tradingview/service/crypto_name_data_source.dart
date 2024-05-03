class CryptoNameDataSource {
  static String binanceSourceEuro(String cryptoName) {
    return 'BINANCE:${cryptoName}USD';
  }

  static String cryptoNameAndSource(String name) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  body, html, .tradingview-widget-container, #tradingview_4418d {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: ;
    overflow: hidden;
  }
</style>
</head>
<body>
<div class="tradingview-widget-container">
<div id="tradingview_4418d">
</div>
<div class="tradingview-widget-copyright">
<a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank">
<span class="blue-text">Track all markets on TradingView
</span>
</a>
</div>
<script type="text/javascript" src="https://s3.tradingview.com/tv.js">
</script>
<script type="text/javascript">
new TradingView.widget({
  "autosize": true,
  "symbol": "$name",
  "interval": "4H",
  "timezone": "Etc/UTC",
  "theme": "dark",
  "style": "1",
  "locale": "en",
  "toolbar_bg": "#121536",
  "enable_publishing": false,
  "save_image": false,
  "container_id": "tradingview_4418d"
  });
</script>
</div>
</body>
</html>''';
  }
}
