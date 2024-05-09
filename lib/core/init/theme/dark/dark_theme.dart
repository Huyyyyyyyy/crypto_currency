import 'package:flutter/material.dart';
import 'package:crypto_currency/core/constants/color/color_constant.dart';

class ProjectTheme {
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: ProjectColors.haiti,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1F2630), // Đổi màu background này
    appBarTheme: AppBarTheme(
      backgroundColor: ProjectColors.haiti,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: ProjectColors.white,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}
