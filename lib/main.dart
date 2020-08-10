import 'package:flutter/material.dart';
import 'package:motel/wrapper.dart';
import 'package:motel/wrapper_builder.dart';

void main() {
  runApp(MotelApp());
}

class MotelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WrapperBuilder(
      builder: (BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Motel',
          theme: ThemeData(
            fontFamily: 'Nunito',
          ),
          home: Material(
            child: Wrapper(),
          ),
        );
      },
    );
  }
}
