import 'dart:ui';

import 'package:flutter/material.dart';

class CustomCheckboxRect extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  const CustomCheckboxRect({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  _CustomCheckboxRectState createState() => _CustomCheckboxRectState();
}

class _CustomCheckboxRectState extends State<CustomCheckboxRect> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
          widget.onChanged?.call(_isChecked);
        });
      },
      child: Container(
        width: 18.0,
        height: 18.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: _isChecked ? const Color(0xFFcbd5e1) : const Color(0xFF475569),
            width: _isChecked ? 1: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
          color: _isChecked ? const Color(0xFFcbd5e1) : Colors.transparent,
        ),
        child: _isChecked ? const Icon(
            Icons.check_sharp,
            size: 14,
            color: Color(0xFF475569),
            weight: 4000,
        ): null,
      ),
    );
  }
}
