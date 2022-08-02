import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  const WhiteText(
    this.text, {
    Key? key,
    this.fontSize,
  }) : super(key: key);

  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize ?? 12,
      ),
    );
  }
}
