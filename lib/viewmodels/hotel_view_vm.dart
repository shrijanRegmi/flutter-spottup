import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/room_model.dart';
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
  gotoBookScreen(final Hotel hotel, final Room room) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookScreen(hotel, room),
    ));
  }

  // open rooms dialog
  showRoomDialog(final Hotel hotel) async {
    // final _ref = Firestore.instance;
    // final _roomRef = await _ref
    //     .collection('hotels')
    //     .document(hotel.id)
    //     .collection('rooms')
    //     .limit(2)
    //     .getDocuments();

    // final _isRoom = _roomRef.documents.length > 1;

    // if (_isRoom) {
    //   return showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       content: HotelRoomsList(
    //         hotel.id,
    //         smallImg: true,
    //         onPressed: (room) {
    //           Navigator.pop(context);
    //           gotoBookScreen(hotel, room);
    //         },
    //       ),
    //     ),
    //   );
    // } else {
      return gotoBookScreen(hotel, null);
    // }
  }
}
