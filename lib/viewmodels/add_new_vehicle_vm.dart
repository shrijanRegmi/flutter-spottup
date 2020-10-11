import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/services/firestore/vehicle_provider.dart';
import 'package:motel/services/storage/vehicle_storage_service.dart';

class VehicleVm extends ChangeNotifier {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _modelYearController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  List<File> _photos = [];
  bool _isLoading = false;
  File _dp;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController get nameController => _nameController;
  TextEditingController get modelYearController => _modelYearController;
  TextEditingController get seatsController => _seatsController;
  TextEditingController get priceController => _priceController;
  List<File> get photos => _photos;
  bool get isLoading => _isLoading;
  File get dp => _dp;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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

  // upload vehicle
  Future publishVehicle(final AppUser appUser) async {
    if (_nameController.text.trim() != '' &&
        _modelYearController.text.trim() != '' &&
        _seatsController.text.trim() != '' &&
        _priceController.text.trim() != '') {
      if (_dp != null) {
        _updateLoaderValue(true);

        String _mDp = '';
        List<String> _mPhotos = [];

        _mDp = await VehicleStorage().uploadVehicleDp(_dp);
        _mPhotos = await VehicleStorage().uploadVehiclePhotos(_photos);

        final _vehicle = Vehicle(
          name: _nameController.text.trim(),
          modelYear: int.parse(_modelYearController.text.trim()),
          seats: int.parse(_seatsController.text.trim()),
          price: int.parse(_priceController.text.trim()),
          ownerId: appUser.uid,
          dp: _mDp,
          photos: _mPhotos,
        );

        await VehicleProvider(vehicle: _vehicle).publishVehicle();
        _updateLoaderValue(false);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please upload display picture.'),
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all the input fields.'),
      ));
    }
  }

  // update value of loader
  _updateLoaderValue(final bool _newVal) {
    _isLoading = _newVal;
    notifyListeners();
  }
}
