import 'package:crypto_currency/view/home/service/crypto/crypto_data_soure_with_dio.dart';
import 'package:crypto_currency/view/home/service/get-it/get_it_source.dart';

mixin GetItMixin {
  CryptoDataSourceWithDio dioData() {
    return GetItSource.getIt<CryptoDataSourceWithDio>();
  }
}
