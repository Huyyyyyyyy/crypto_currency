import 'package:crypto_currency/services/custom_dot_line_border/custom_dot_line_border.dart';
import 'package:crypto_currency/view/components/futures_page/futures_components/crypto_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../model/account_stream/account_data.dart';
import '../../../../model/futures_currency_stream/futures_data.dart';

class FuturesWallet extends StatefulWidget {
  const FuturesWallet({super.key});

  @override
  _FuturesWalletState createState() => _FuturesWalletState();
}

class _FuturesWalletState extends State<FuturesWallet> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FuturesData, AccountData>(
      builder: (context, futuresData, accountData, _) {
        String formattedPriceVnd ='₫ ${CryptoTile.getFormattedPriceVND(accountData.totalMarginBalance,23000)}';
        String formattedPercentagePnl = ((double.parse(accountData.totalCrossUnPnl)*100)/double.parse(accountData.totalMarginBalance)).toStringAsFixed(2);
        return Scaffold(
          backgroundColor: const Color(0xFF1F2630),
          appBar: null, // Remove the default app bar
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF29313C),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'USDⓈ-M',
                        style: TextStyle(
                          color: Color(0xFFEAECF0),
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'COIN-M',
                        style: TextStyle(
                            color: Color(0xFF858E9D),
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 35, 5),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Sao chép giao dịch',
                        style: TextStyle(
                            color: Color(0xFF858E9D),
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.transform_sharp),
                        onPressed: () {
                          print('transfer account mode');
                        },
                        color: const Color(0xFFEAECEF),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.work_history_sharp),
                        onPressed: () {
                          print('transfer account mode');
                        },
                        color: const Color(0xFFEAECEF),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,0,10,10),
                child: Row(
                  children: [
                    DottedBorderUnderText(
                      child: const Text(
                        'Số dư margin',
                        style: TextStyle(
                          color: Color(0xFFEAECF0),
                          fontSize: 16
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          print('hide balance');
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Color(0xFF4E5866),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,0,10,0),
                child: Row(
                  children: [
                    Text(
                        (double.parse(accountData.totalMarginBalance) > 0) ?
                        double.parse(accountData.totalMarginBalance).toStringAsFixed(2) : '--',
                      style: const TextStyle(
                        color: Color(0xFFEBECF0),
                        fontSize: 24,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10,0,0,0),
                      child: Text(
                        'USDT',
                        style: TextStyle(
                          color: Color(0xFFEBECF0),
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                          onPressed: (){
                            print("change currency unit");
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 40,
                            color: Color(0xFFEAECEF),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (double.parse(accountData.totalMarginBalance) > 0) ?
                      formattedPriceVnd : '₫0.000000',
                      style: const TextStyle(
                        color: Color(0xFF808A97),
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Lãi lỗ đã ghi nhận hôm nay ',
                      style: TextStyle(
                        color: Color(0xFFEAECF0) ,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                            '${double.parse(accountData.totalCrossUnPnl).toStringAsFixed(2)} '
                            '($formattedPercentagePnl%)',
                        style: TextStyle(
                            color: (double.parse(accountData.totalCrossUnPnl)) >= 0 ? Colors.greenAccent : Colors.redAccent ,
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text(
                        'Số dư ví (USDT)',
                        style: TextStyle(
                          color: Color(0xFF858E9C)
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: DottedBorderUnderText(
                        child: const Text(
                          'PNL chưa được ghi nhận (USDT)',
                          style: TextStyle(
                              color: Color(0xFF858E9C)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        double.parse(accountData.totalMarginBalance) > 0 ? double.parse(accountData.totalMarginBalance).toStringAsFixed(2) : '--',
                        style: const TextStyle(
                            color: Color(0xFFEAECF0),
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        (double.parse(accountData.totalCrossUnPnl) != 0 ? (double.parse(accountData.totalCrossUnPnl) >= 0 ? double.parse(accountData.totalCrossUnPnl).toStringAsFixed(2) : '-${double.parse(accountData.totalCrossUnPnl).toStringAsFixed(2)}') : '--' ),
                        style: const TextStyle(
                            color: Color(0xFFEAECF0),
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        double.parse(accountData.totalMarginBalance) > 0 ?
                        '₫ ${(double.parse(accountData.totalMarginBalance)*23000).toStringAsFixed(2)}'
                          : '₫0.000000',
                        style: const TextStyle(
                            color: Color(0xFF858E9C),
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        (double.parse(accountData.totalCrossUnPnl) != 0 ? (double.parse(accountData.totalCrossUnPnl) >= 0 ? '₫ ${(double.parse(accountData.totalCrossUnPnl)*23000).toStringAsFixed(2)}' : '- ₫ ${(double.parse(accountData.totalCrossUnPnl)*23000).toStringAsFixed(2)}') : '₫0.000000' ),
                        style: const TextStyle(
                            color: Color(0xFF858E9C),
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
