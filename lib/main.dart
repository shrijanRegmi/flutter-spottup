import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/auth/auth_provider.dart';
import 'package:motel/wrapper.dart';
import 'package:motel/wrapper_builder.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MotelApp());
}

class MotelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snap) {
        // if (snap.hasData) {
        return StreamProvider<AppUser>.value(
          value: AuthProvider().user,
          child: WrapperBuilder(
            builder: (BuildContext context, AppUser appUser) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Spott Up',
                theme: ThemeData(
                  fontFamily: 'Nunito',
                ),
                home: Material(
                  child: Wrapper(appUser),
                ),
              );
            },
          ),
        );
        // }
        // return Container();
      },
    );
  }
}
