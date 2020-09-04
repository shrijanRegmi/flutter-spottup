import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/screens/home/home_screen.dart';
import 'package:motel/views/screens/home/hotel_owner/home_screen.dart';
import 'package:motel/views/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  final AppUser appUser;
  Wrapper(this.appUser);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    return _user == null && appUser == null
        ? WelcomeScreen()
        : _user?.accountType == AccountType.hotelOwner
            ? OwnerHomeScreen()
            : HomeScreen();
  }
}
