import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/room_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/firestore/tour_provider.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/services/firestore/vehicle_provider.dart';
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
    // final _ref = FirebaseFirestore.instance;
    // final _roomRef = await _ref
    //     .collection('hotels')
    //     .doc(hotel.id)
    //     .collection('rooms')
    //     .limit(2)
    //     .get();

    // final _isRoom = _roomRef.docs.length > 1;

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

  // delete hotel
  deleteHotel(final String _hotelId) async {
    final _result = await HotelProvider().deleteHotel(_hotelId);
    if (_result != null) {
      Navigator.pop(context);
    }
    return _result;
  }

  // delete tour
  deleteTour(final String tourId) async {
    final _result = await TourProvider().deleteTour(tourId);
    if (_result != null) {
      Navigator.pop(context);
    }
    return _result;
  }

  // delete vehicle
  deleteVehicle(final String vehicleId) async {
    final _result = await VehicleProvider().deleteVehicle(vehicleId);
    if (_result != null) {
      Navigator.pop(context);
    }
    return _result;
  }
}
