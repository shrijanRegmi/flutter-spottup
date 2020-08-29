import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/screens/home/home_screen.dart';
import 'package:motel/views/screens/home/hotel_owner/home_screen.dart';
import 'package:motel/views/screens/welcome_screen.dart';

class Wrapper extends StatelessWidget {
  final AppUser appUser;
  Wrapper(this.appUser);

  @override
  Widget build(BuildContext context) {
    return appUser == null ? WelcomeScreen() : OwnerHomeScreen();
  }
}
