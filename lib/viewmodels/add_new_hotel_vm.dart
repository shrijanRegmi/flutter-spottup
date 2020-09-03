import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/storage/hotel_storage_service.dart';

class AddNewHotelVm extends ChangeNotifier {
  bool _isNextPressed = false;
  File _dp;
  File _roomDp;
  List<File> _photos = [];
  List<File> _roomPhotos = [];
  TextEditingController _roomNameController = TextEditingController();
  TextEditingController _roomAdultController = TextEditingController();
  TextEditingController _roomKidController = TextEditingController();
  TextEditingController _roomPriceController = TextEditingController();
  TextEditingController _roomSummaryController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  List<Hotel> _rooms = [];
  bool _isLoading = false;
  String _progressText = '';

  TextEditingController get nameController => _nameController;
  TextEditingController get cityController => _cityController;
  TextEditingController get countryController => _countryController;
  TextEditingController get priceController => _priceController;
  TextEditingController get summaryController => _summaryController;
  TextEditingController get roomNameController => _roomNameController;
  TextEditingController get roomAdultController => _roomAdultController;
  TextEditingController get roomKidController => _roomKidController;
  TextEditingController get roomPriceController => _roomPriceController;
  TextEditingController get roomSummaryController => _roomSummaryController;
  List<Hotel> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String get progressText => _progressText;

  bool get isNextPressed => _isNextPressed;
  File get dp => _dp;
  File get roomDp => _roomDp;
  List<File> get photos => _photos;
  List<File> get roomPhotos => _roomPhotos;

  // next btn pressed
  onNextPressed(bool newVal) {
    _isNextPressed = newVal;
    notifyListeners();
  }

  // upload dp on pressing big icon
  uploadDp(final bool isRoom) async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (isRoom) {
      _roomDp = _pickedImg != null ? File(_pickedImg.path) : null;
    } else {
      _dp = _pickedImg != null ? File(_pickedImg.path) : null;
    }
    notifyListeners();
  }

  // upload photos on pressing small icon
  uploadPhotos(final bool isRoom) async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final _file = _pickedImg != null ? File(_pickedImg.path) : null;
    if (_file != null) {
      if (isRoom) {
        _roomPhotos.add(_file);
      } else {
        _photos.add(_file);
      }
    }
    notifyListeners();
  }

  // upload new hotel to firestore
  uploadNewHotel(final BuildContext context, final String appUserId) async {
    if (_nameController.text.trim() != '' &&
        _cityController.text.trim() != '' &&
        _countryController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _summaryController.text.trim() != '' &&
        _dp != null) {
      _updateLoaderValue(true);
      _updateProgressVal('Publishing Hotel Started');
      String _mDp = '';
      List<String> _mPhotos = [];

      var _result;

      _updateProgressVal('Uploading Hotel Display Picture');
      _mDp = await HotelStorage().uploadHotelDp(dp);
      _updateProgressVal('Uploading Hotel Photos');
      _mPhotos = await HotelStorage().uploadHotelPhotos(photos);

      if (_mDp != null) {
        final _hotel = Hotel(
          name: _nameController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          summary: _summaryController.text.trim(),
          dp: _mDp,
          photos: _mPhotos ?? [],
          ownerId: appUserId,
        );
        _updateProgressVal('Uploading Hotel Data');
        _result = await HotelProvider().uploadNewHotel(_hotel);

        if (_rooms.isNotEmpty) {
          _updateProgressVal('Publishing Room Started');
          _result = await _uploadRooms(_result);
        }
      }

      if (_result == null) {
        _updateLoaderValue(false);
      } else {
        Navigator.pop(context);
      }
      return _result;
    }
  }

  // update value of loader
  _updateLoaderValue(final bool _newVal) {
    _isLoading = _newVal;
    notifyListeners();
  }

  // update value of progress text
  _updateProgressVal(final String _newVal) {
    _progressText = _newVal;
    notifyListeners();
  }

  // upload rooms
  _uploadRooms(final DocumentReference _hotelRef) async {
    List<dynamic> _results;
    for (final _room in _rooms) {
      String _mRoomDp = '';
      List<String> _mRoomPhotos = [];

      _updateProgressVal('Uploading Room Display Picture');
      _mRoomDp = await HotelStorage().uploadHotelDp(File(_room.dp));
      _updateProgressVal('Uploading Room Photos');
      _mRoomPhotos = await HotelStorage().uploadHotelPhotos(_room.photos);

      final _resultedRoom = Hotel(
        adults: _room.adults,
        city: _room.city,
        country: _room.country,
        dp: _mRoomDp,
        photos: _mRoomPhotos,
        kids: _room.kids,
        name: _room.name,
        price: _room.price,
        summary: _room.summary,
      );
      _updateProgressVal('Uploading Room Data');
      final _result =
          await HotelProvider().uploadNewRoom(_hotelRef, _resultedRoom);
      _results = [];
      _results.add(_result);
    }
    return _results;
  }

  // update rooms list
  addRoomList(final BuildContext context, final String appUserId) {
    if (_roomNameController.text.trim() != '' &&
        roomPriceController.text.trim() != '' &&
        _roomSummaryController.text.trim() != '' &&
        _roomDp != null) {
      final _room = Hotel(
        name: _roomNameController.text.trim(),
        price: int.parse(_roomPriceController.text.trim()),
        summary: _roomSummaryController.text.trim(),
        dp: _roomDp.path,
        photos: _roomPhotos,
        ownerId: appUserId,
        kids: int.parse(_roomKidController.text.trim()),
        adults: int.parse(_roomAdultController.text.trim()),
      );

      _rooms.add(_room);
      Navigator.pop(context);
    }
    notifyListeners();
  }

  // clear controllers
  clearControllers() {
    _roomNameController.clear();
    _roomPriceController.clear();
    _roomAdultController.clear();
    _roomKidController.clear();
    _roomSummaryController.clear();
    _roomDp = null;
    _roomPhotos.clear();
    notifyListeners();
  }
}
