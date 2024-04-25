import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FundingComponent extends StatelessWidget {
  final String fundingRates;
  final int nextFundingTime;

  const FundingComponent({
    Key? key,
    required this.fundingRates,
    required this.nextFundingTime
  }) : super(key: key); // Sửa lại phần khai báo key


  // Hàm để định dạng đối tượng Duration thành chuỗi có thể hiển thị
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitDays = duration.inDays.toString();

    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  String formatFundingRates(String originalRate) {
    // Tìm vị trí của dấu chấm thập phân
    int decimalIndex = originalRate.indexOf('.');

    if (decimalIndex != -1) {
      // Lấy 5 ký tự sau dấu chấm thập phân (bao gồm cả dấu chấm)
      String lastFiveDigits = originalRate.substring(decimalIndex - 1, decimalIndex + 6);
      return lastFiveDigits;
    } else {
      // Trong trường hợp không tìm thấy dấu chấm thập phân, trả về chuỗi gốc
      return originalRate;
    }
  }

  @override
  Widget build(BuildContext context) {
    //format the next funding time
    DateTime nextFundingTimeFormatted = DateTime.fromMillisecondsSinceEpoch(nextFundingTime);
    // Tính toán khoảng thời gian còn lại từ thời gian hiện tại đến nextFundingTime
    DateTime now = DateTime.now();
    Duration remainingTime = nextFundingTimeFormatted.difference(now);
    // Định dạng đối tượng Duration thành chuỗi có thể hiển thị
    String formattedRemainingTime = formatDuration(remainingTime);
    //format the next funding time

    //format funding rates
    String fundingRatesFormatted = formatFundingRates(fundingRates);
    //format funding rates
    return Container(
        padding: const EdgeInsets.fromLTRB(13.0, 0, 0,5),
        decoration: const BoxDecoration(
        color: Color(0xFF1F2630), // Adjust the color to match your design
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Funding / Đếm ngược',
                style: TextStyle(
                    color: Color(0xFF64748b),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$fundingRatesFormatted%/$formattedRemainingTime',
                style: const TextStyle(
                      color: Color(0xFFe2e8f0),
                      fontWeight: FontWeight.w500
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
