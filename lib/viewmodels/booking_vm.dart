import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/app/room_price_model.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:provider/provider.dart';

class BookVm extends ChangeNotifier {
  final BuildContext context;
  BookVm({@required this.context});

  DateTime _checkInDate;
  DateTime _checkOutDate;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isBookingAvailable = false;
  bool _isEmailPhoneConfirmed = false;
  ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<SelectedRoom> _selectedRooms = [];
  TextEditingController _adultController = TextEditingController();
  TextEditingController _kidController = TextEditingController();
  TextEditingController _roomController = TextEditingController();
  bool _isRoomSelected = false;

  DateTime get checkInDate => _checkInDate;
  DateTime get checkOutDate => _checkOutDate;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  bool get isBookingAvailable => _isBookingAvailable;
  bool get isEmailPhoneConfirmed => _isEmailPhoneConfirmed;
  ScrollController get scrollController => _scrollController;
  bool get isProcessing => _isProcessing;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  List<SelectedRoom> get selectedRoom => _selectedRooms;
  bool get isRoomSelected => _isRoomSelected;

  // show checkin dialog
  Future showCheckInDialog() async {
    _isBookingAvailable = false;
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _checkInDate = _pickedDate;
      notifyListeners();
    }
  }

  // show checkin dialog
  Future showCheckOutDialog() async {
    _isBookingAvailable = false;
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _checkOutDate = _pickedDate;
      notifyListeners();
    }
  }

  // check availability of booking
  checkAvailability(final Hotel hotel) {
    if (hotel.availableCheckIn != null && hotel.availableCheckOut != null) {
      if (_checkInDate.isAfter(
              DateTime.fromMillisecondsSinceEpoch(hotel.availableCheckIn)) &&
          _checkOutDate.isBefore(
              DateTime.fromMillisecondsSinceEpoch(hotel.availableCheckOut))) {
        _isBookingAvailable = true;
      } else {
        final _checkIn =
            DateHelper().getFormattedDate(hotel.availableCheckIn) ?? '';
        final _checkOut =
            DateHelper().getFormattedDate(hotel.availableCheckOut) ?? '';
        _noBookingDialog(_checkIn, _checkOut);
      }
    } else if (hotel.availableCheckIn == null &&
        hotel.availableCheckOut == null) {
      _isBookingAvailable = true;
    } else if (hotel.availableCheckIn != null &&
        _checkInDate.isAfter(
            DateTime.fromMillisecondsSinceEpoch(hotel.availableCheckIn))) {
      _isBookingAvailable = true;
    } else if (hotel.availableCheckOut != null &&
        _checkOutDate.isBefore(
            DateTime.fromMillisecondsSinceEpoch(hotel.availableCheckOut))) {
      _isBookingAvailable = true;
    } else {
      final _checkIn = hotel.availableCheckIn != null
          ? DateHelper().getFormattedDate(hotel.availableCheckIn)
          : DateHelper()
              .getFormattedDate(DateTime.now().millisecondsSinceEpoch);
      final _checkOut = hotel.availableCheckOut != null
          ? DateHelper().getFormattedDate(hotel.availableCheckOut)
          : '';
      _noBookingDialog(_checkIn, _checkOut);
    }

    if (_isBookingAvailable) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }

  // check email phone
  checkEmailPhone() {
    FocusScope.of(context).unfocus();
    if (!_isEmailPhoneConfirmed) {
      final _appUser = Provider.of<AppUser>(context, listen: false);
      final _fullName = '${_appUser.firstName} ${_appUser.lastName}';

      if (_emailController.text.trim() == _fullName &&
          _phoneController.text.trim() == _appUser.phone.toString()) {
        _isEmailPhoneConfirmed = true;
      } else if (_emailController.text.trim() != _fullName &&
          _phoneController.text.trim() != _appUser.phone.toString()) {
        confirmationDialog(
          "Your name and phone doesn't match your profile",
          "Your name '${_appUser.firstName} ${_appUser.lastName}' from your profile does not match '${_emailController.text.trim()}'.\n\nYour phone '${_appUser.phone}' from your profile does not match '${_phoneController.text.trim()}'.",
        );
      } else if (_emailController.text.trim() != _fullName) {
        confirmationDialog(
          "Your name doesn't match your profile",
          "Your name '${_appUser.firstName} ${_appUser.lastName}' from your profile does not match '${_emailController.text.trim()}'.",
        );
      } else if (_phoneController.text.trim() != _appUser.phone.toString()) {
        confirmationDialog(
          "Your phone doesn't match your profile",
          "Your phone '${_appUser.phone}' from your profile does not match '${_phoneController.text.trim()}'.",
        );
      }
    }

    if (_isBookingAvailable) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height + 200,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }

  // update name phone confirmation
  updateConfirmation() {
    _isEmailPhoneConfirmed = false;
    notifyListeners();
  }

  // confirm booking
  confirmBooking(
      final ConfirmHotelBooking booking, final AppUser appUser) async {
    _isProcessing = true;
    notifyListeners();
    try {
      // final _result = await FlutterEmailSender.send(_email);
      await UserProvider(uid: appUser.uid).confirmHotelBooking(booking);
      _isProcessing = false;
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      print('Success: Sending email');
      bookingDoneDialog();
    } catch (e) {
      print(e);
      print('Error!!!: Sending email');
      _isProcessing = false;
      notifyListeners();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Unexpected error occured ! Please try booking again !',
        ),
      ));
      return null;
    }
  }

  // confirmation failed dialog
  confirmationDialog(final String title, final String content) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('$content'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Cancle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                _isEmailPhoneConfirmed = true;
                if (_isBookingAvailable) {
                  _scrollController.animateTo(
                    MediaQuery.of(context).size.height + 200.0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.ease,
                  );
                }
                notifyListeners();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Confirm Anyway',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // dialog when booking is not available
  _noBookingDialog(String checkIn, String checkOut) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          'Booking not available !',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          checkOut != ''
              ? 'The booking of this hotel is only available from $checkIn - $checkOut'
              : 'The booking of this hotel is only available from $checkIn',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // select number of people dialog
  selectRoomDialog(final Hotel room) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          room.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select number of adults, kids and rooms'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Adults',
              ),
              controller: _adultController,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Kids',
              ),
              controller: _kidController,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Rooms',
              ),
              controller: _roomController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Cancle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                if (_adultController.text != '' ||
                    _kidController.text != '' ||
                    _roomController.text.trim() != '') {
                  if (_selectedRooms
                      .where((element) => element.roomName == room.name)
                      .toList()
                      .isEmpty) {
                    _selectedRooms.add(
                      SelectedRoom(
                        roomName: room.name,
                        adult: _adultController.text != ''
                            ? int.parse(_adultController.text.trim())
                            : 0,
                        kid: _kidController.text != ''
                            ? int.parse(_kidController.text.trim())
                            : 0,
                        rooms: _roomController.text.trim() != ''
                            ? int.parse(_roomController.text.trim())
                            : 1,
                        price: room.price,
                        roomPrices: room.roomPrices,
                      ),
                    );
                  }
                  notifyListeners();
                  _adultController.clear();
                  _kidController.clear();
                  _roomController.clear();
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // remove selected room
  removeSelectedRoom(final SelectedRoom room) {
    _isRoomSelected = false;
    _selectedRooms.remove(room);
    notifyListeners();
  }

  // update room selected value
  updateRoomSelectedValue(final bool newVal,
      {final bool requiresScroll = true}) {
    _isRoomSelected = newVal;
    if (_isRoomSelected && requiresScroll) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }

  // dialog when booking is done
  bookingDoneDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Thank You for booking hotel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              Icons.check,
              color: Color(0xff45ad90),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'You will receive confirmation of booking in the app notification tab shortly. Please check the notification tab in an hour.'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedRoom {
  final String roomName;
  final int adult;
  final int kid;
  int price;
  final int rooms;
  final List<RoomPrice> roomPrices;
  SelectedRoom({
    this.roomName,
    this.adult,
    this.kid,
    this.price,
    this.rooms,
    this.roomPrices,
  });
}
