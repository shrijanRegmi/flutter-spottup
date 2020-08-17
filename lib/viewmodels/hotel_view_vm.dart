import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/book_screen.dart';

class HotelViewVm extends ChangeNotifier {
  final BuildContext context;
  HotelViewVm({@required this.context});

  bool _isFavourite = false;
  bool get isFavourite => _isFavourite;

  // update favourie
  updateFavourite(final bool _isFav) {
    _isFavourite = _isFav;
    notifyListeners();
  }

  // send favourite
  Future sendFavourite(final String hotelId, final AppUser appUser) async {
    Map<String, dynamic> _data;
    if (_isFavourite) {
      _data = {
        'favourite': [...appUser.favourite, hotelId],
      };
    } else {
      _data = {
        'favourite': appUser.favourite
            .where((favourite) => favourite != hotelId)
            .toList(),
      };
    }
    return await UserProvider(uid: appUser.uid).updateUserData(_data);
  }

  // goto booking screen
  gotoBookScreen(final Hotel hotel) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookScreen(hotel),
    ));
  }
}
