import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewHotelVm extends ChangeNotifier {
  bool _isNextPressed = false;
  File _dp;
  List<File> _photos = [];

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
}
