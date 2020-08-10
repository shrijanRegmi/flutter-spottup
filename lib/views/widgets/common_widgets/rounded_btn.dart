import 'package:flutter/material.dart';

class RoundedBtn extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final double fontSize;
  final Function onPressed;
  final double padding;
  final double minWidth;
  final double horizontalTextSpacing;
  final double verticalTextSpacing;
  RoundedBtn({
    this.title,
    this.color = const Color(0xff45ad90),
    this.textColor = Colors.white,
    this.fontSize = 14.0,
    this.onPressed,
    this.padding = 30.0,
    this.minWidth,
    this.horizontalTextSpacing = 0.0,
    this.verticalTextSpacing = 13.0,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: MaterialButton(
        elevation: 3.0,
        minWidth:
            minWidth == null ? MediaQuery.of(context).size.width : minWidth,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: onPressed,
        color: color,
        padding: EdgeInsets.symmetric(vertical: verticalTextSpacing, horizontal: horizontalTextSpacing),
        child: Text(
          '$title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
