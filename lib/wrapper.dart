import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/screens/home/home_screen.dart';
import 'package:motel/views/screens/home/hotel_owner/home_screen.dart';
import 'package:motel/views/screens/home/tour_partner/home_screen.dart';
import 'package:motel/views/screens/home/vehicle_partner/home_screen.dart';
import 'package:motel/views/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  final AppUser appUser;
  Wrapper(this.appUser);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return _appUser == null && appUser == null
        ? WelcomeScreen()
        : _getScreen(_appUser?.accountType, appUser);
  }

  Widget _getScreen(AccountType accountType, AppUser appUser) {
    print('The account type is :::: $accountType');
    switch (accountType) {
      case AccountType.hotelPartner:
        return OwnerHomeScreen(appUser.uid);
        break;
      case AccountType.tourPartner:
        return TourPartnerHomeScreen(appUser.uid);
        break;
      case AccountType.vehiclePartner:
        return VehiclePartnerHomeScreen(appUser.uid);
        break;
      default:
        return HomeScreen(appUser.uid);
        break;
    }
  }
}
