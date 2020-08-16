import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/services/storage/user_storage_service.dart';

class ProfileVm extends ChangeNotifier {
  final BuildContext context;
  ProfileVm({@required this.context});

  File _imgFile;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool _isUpdatingData = false;
  DateTime _dob;

  File get imgFile => _imgFile;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get addressController => _addressController;
  bool get isUpdatingData => _isUpdatingData;
  DateTime get dob => _dob;

  // update user profile image
  Future selectImage(final AppUser appUser) async {
    _isUpdatingData = true;
    notifyListeners();

    final _pickedImg = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 500.0,
      maxHeight: 500.0,
      imageQuality: 50,
    );

    _imgFile = _pickedImg != null ? File(_pickedImg.path) : null;
    notifyListeners();

    var _result = await UserStorage().uploadUserImage(imgFile: _imgFile);
    if (_result != null) {
      final _data = {
        'photo_url': _result,
      };
      _result = await UserProvider(uid: appUser.uid).updateUserData(_data);
    }
    _isUpdatingData = false;
    notifyListeners();
    return _result;
  }

  // update user data
  Future updateData(
      final Map<String, dynamic> data, final AppUser appUser) async {
    _isUpdatingData = true;
    notifyListeners();
    _phoneController.clear();
    _addressController.clear();
    final _result = await UserProvider(uid: appUser.uid).updateUserData(data);
    _isUpdatingData = false;
    notifyListeners();
    return _result;
  }

  // open date picker
  Future openDatePicker(final AppUser appUser) async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1800, 1, 1),
      lastDate: DateTime.now(),
    );
    if (_pickedDate != null) {
      _dob = _pickedDate;
      final _data = {
        'dob': _dob.millisecondsSinceEpoch,
      };
      updateData(_data, appUser);
    }
    notifyListeners();
  }
}
