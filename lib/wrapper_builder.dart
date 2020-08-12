import 'package:flutter/material.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/models/firebase/top_three_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:provider/provider.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AppUser appUser) builder;
  WrapperBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    if (_appUser != null) {
      return MultiProvider(
        providers: [
          StreamProvider<AppUser>.value(
            value: UserProvider(uid: _appUser.uid).appUser,
          ),
          StreamProvider<List<Hotel>>.value(
            value: HotelProvider().hotelsList,
          ),
          StreamProvider<List<TopThree>>.value(
            value: HotelProvider().topThree,
          ),
          StreamProvider<List<PopularDestination>>.value(
            value: HotelProvider().popularDestinations,
          ),
        ],
        child: builder(context, _appUser),
      );
    }
    return builder(context, _appUser);
  }
}
