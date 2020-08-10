import 'package:flutter/material.dart';

class LeftRightText extends StatelessWidget {
  final String leftText;
  final String rightText;
  final bool requiredIcon;
  final Function onPressIcon;

  LeftRightText({
    @required this.leftText,
    this.rightText = 'View all',
    this.requiredIcon = true,
    this.onPressIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leftText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Text(
                  rightText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Color(0xff45ad90),
                  ),
                ),
                if (requiredIcon)
                  SizedBox(
                    width: 5.0,
                  ),
                if (requiredIcon)
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xff45ad90),
                    size: 18.0,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
