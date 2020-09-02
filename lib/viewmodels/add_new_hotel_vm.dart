import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/storage/hotel_storage_service.dart';

class AddNewHotelVm extends ChangeNotifier {
  bool _isNextPressed = false;
  File _dp;
  List<File> _photos = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get cityController => _cityController;
  TextEditingController get countryController => _countryController;
  TextEditingController get priceController => _priceController;
  TextEditingController get summaryController => _summaryController;

  bool get isNextPressed => _isNextPressed;
  File get dp => _dp;
  List<File> get photos => _photos;

  // next btn pressed
  onNextPressed(bool newVal) {
    _isNextPressed = newVal;
    notifyListeners();
  }

  // upload dp on pressing big icon
  uploadDp() async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    _dp = _pickedImg != null ? File(_pickedImg.path) : null;
    notifyListeners();
  }

  // upload photos on pressing small icon
  uploadPhotos() async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final _file = _pickedImg != null ? File(_pickedImg.path) : null;
    if (_file != null) {
      _photos.add(_file);
    }
    notifyListeners();
  }

  // upload new hotel to firestore
  uploadNewHotel(final String appUserId) async {
    if (_nameController.text.trim() != '' &&
        _cityController.text.trim() != '' &&
        _countryController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _summaryController.text.trim() != '' &&
        _dp != null &&
        _photos.isNotEmpty) {
      String _mDp = '';
      List<String> _mPhotos = [];

      var _result;

      _mDp = await HotelStorage().uploadHotelDp(dp);
      _mPhotos = await HotelStorage().uploadHotelPhotos(photos);

      if (_mDp != null && _mPhotos != null) {
        final _hotel = Hotel(
          name: _nameController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          summary: _summaryController.text.trim(),
          dp: _mDp,
          photos: _mPhotos,
          ownerId: appUserId,
        );
        _result = await HotelProvider().uploadNewHotel(_hotel);
      }

      return _result;
    }
  }
}
