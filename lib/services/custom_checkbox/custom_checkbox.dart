import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
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
        width: 16.0,
        height: 16.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _isChecked ? const Color(0xFFcbd5e1) : const Color(0xFF475569),
            width: _isChecked ? 6.0 : 1.0,
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
