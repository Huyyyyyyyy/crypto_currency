import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static const String _urlKey = 'currentUrl';
  static const String _urlFundingTime = 'urlFunding';
  static const String _urlAggTrade = 'urlAggTrade';
  static const String _defaultUrl = 'wss://fstream.binance.com/ws/btcusdt@ticker';
  static const String _apiKey = 'apiKey';
  static const String _secretKey = 'secretKey';

  static Future<String> getUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_urlKey) ?? _defaultUrl;
  }

  static Future<void> updateUrl(String newUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Xóa URL cũ
    await prefs.remove(_urlKey);
    // Cập nhật URL mới
    await prefs.setString(_urlKey, newUrl);
  }

  static Future<String> getUrlFundingTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_urlFundingTime) ?? _defaultUrl;
    return result.replaceAll('@ticker', '@markPrice');
  }

  static Future<void> updateUrlFundingTime(String newUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_urlFundingTime);
    await prefs.setString(_urlFundingTime, newUrl.replaceAll('@ticker', '@markPrice'));
  }

  static Future<String> getUrlAggTrade() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_urlAggTrade) ?? _defaultUrl;
    return result.replaceAll('@ticker', '@aggTrade');
  }

  static Future<void> updateUrlAggTrade(String newUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_urlAggTrade);
    await prefs.setString(_urlAggTrade, newUrl.replaceAll('@ticker', '@aggTrade'));
  }

  static Future<String> getApiKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_apiKey) ?? '';
    return result;
  }

  static Future<void> updateApiKey(String newApiKey) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKey);
    await prefs.setString(_apiKey, newApiKey);
  }

  static Future<String> getSecretKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(_secretKey) ?? '';
    return result;
  }

  static Future<void> updateSecretKey(String newSecret) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_secretKey);
    await prefs.setString(_secretKey, newSecret);
  }

}
