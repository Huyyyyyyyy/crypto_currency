import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_currency/view/home/view-model/cubit/crypto_cubit.dart';
import 'package:crypto_currency/view/home/view-model/mixin/getit_mixin.dart';
import 'package:crypto_currency/view/home/view/home_view.dart';

class HomePageTradingview extends StatelessWidget with GetItMixin {
  const HomePageTradingview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoCubit(cryptoDataSource: dioData())..ranking(),
      child: const HomeView(),
    );
  }
}
