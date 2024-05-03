import 'package:flutter/material.dart';
import 'package:crypto_currency/core/constants/color/color_constant.dart';
import 'package:crypto_currency/core/extension/context_extension.dart';
import 'package:crypto_currency/view/_product/tabbar/trading_tabbar_constants.dart';

class TradingviewTabbars extends StatelessWidget {
  const TradingviewTabbars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: ProjectColors.pictonBlue,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: ProjectColors.pictonBlue,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: ProjectColors.manateeLight,
          ),
      labelPadding: context.labelPad,
      indicatorPadding: context.indicatorPad,
      dividerColor: ProjectColors.haitiDark,
      unselectedLabelColor: ProjectColors.manateeLight,
      tabs: TabbarConstants.tabbarItems,
    );
  }
}
