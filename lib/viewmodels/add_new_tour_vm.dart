import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/tour_provider.dart';
import 'package:motel/services/storage/tour_storage_service.dart';

class TourVm extends ChangeNotifier {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _nightsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _personController = TextEditingController();
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  TextEditingController _inclusionsController = TextEditingController();
  TextEditingController _exclusionsController = TextEditingController();
  List<File> _photos = [];
  bool _isLoading = false;
  File _dp;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController get nameController => _nameController;
  TextEditingController get daysController => _daysController;
  TextEditingController get nightsController => _nightsController;
  TextEditingController get priceController => _priceController;
  TextEditingController get personController => _personController;
  TextEditingController get startController => _startController;
  TextEditingController get endController => _endController;
  TextEditingController get summaryController => _summaryController;
  TextEditingController get inclusionsController => _inclusionsController;
  TextEditingController get exclusionsController => _exclusionsController;
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

  // upload tour
  Future publishTour(final AppUser appUser) async {
    if (_nameController.text.trim() != '' &&
        _daysController.text.trim() != '' &&
        _nightsController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _personController.text.trim() != '' &&
        _startController.text.trim() != '' &&
        _endController.text.trim() != '' &&
        _summaryController.text.trim() != '' &&
        _inclusionsController.text.trim() != '' &&
        _exclusionsController.text.trim() != '') {
      if (_dp != null) {
        _updateLoaderValue(true);

        String _mDp = '';
        List<String> _mPhotos = [];

        _mDp = await TourStorage().uploadTourDp(_dp);
        _mPhotos = await TourStorage().uploadTourPhotos(_photos);

        final _tour = Tour(
          name: _nameController.text.trim(),
          days: int.parse(_daysController.text.trim()),
          nights: int.parse(_nightsController.text.trim()),
          price: int.parse(_priceController.text.trim()),
          person: int.parse(_personController.text.trim()),
          start: int.parse(_startController.text.trim()),
          end: int.parse(_endController.text.trim()),
          summary: _summaryController.text.trim(),
          inclusions: _inclusionsController.text.trim(),
          exclusions: _exclusionsController.text.trim(),
          ownerId: appUser.uid,
          dp: _mDp,
          photos: _mPhotos,
        );

        await TourProvider(tour: _tour).publishTour();
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
