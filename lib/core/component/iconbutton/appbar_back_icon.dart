import 'package:flutter/material.dart';
import 'package:crypto_currency/core/constants/color/color_constant.dart';
import 'package:crypto_currency/core/enum/project_icon.dart';

class AppBarBackIconButton extends StatelessWidget {
  const AppBarBackIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        ProjectIcons.back.getIconData,
        color: ProjectColors.dolly,
      ),
    );
  }
}
