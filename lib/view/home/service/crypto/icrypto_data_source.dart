import 'package:crypto_currency/view/home/model/crypto.dart';

abstract class ICryptoDataSource {
  const ICryptoDataSource();
  Future<List<Crypto>> fetchData();
}
