import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileVm extends ChangeNotifier {
  File _imgFile;

  File get imgFile => _imgFile;

  // update user profile image
  Future selectImage() async {
    final _pickedImg = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 500.0,
      maxHeight: 500.0,
      imageQuality: 50,
    );

    _imgFile = _pickedImg != null ? File(_pickedImg.path) : null;

    notifyListeners();
  }
}
