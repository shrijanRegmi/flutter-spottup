import 'package:flutter/material.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) builder;
  WrapperBuilder({@required this.builder});
  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
