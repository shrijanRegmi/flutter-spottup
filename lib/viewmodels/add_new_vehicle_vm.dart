import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/services/firestore/vehicle_provider.dart';
import 'package:motel/services/storage/vehicle_storage_service.dart';

class AddNewVehicleVm extends ChangeNotifier {
  BuildContext context;
  AddNewVehicleVm(this.context);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _modelYearController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  List<File> _photos = [];
  bool _isLoading = false;
  File _dp;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> _result1 = {};
  Map<String, dynamic> _result2 = {};
  Map<String, dynamic> _result3 = {};
  Map<String, dynamic> _result4 = {};
  Map<String, dynamic> _result5 = {};
  Map<String, dynamic> _result6 = {};

  TextEditingController get nameController => _nameController;
  TextEditingController get modelYearController => _modelYearController;
  TextEditingController get seatsController => _seatsController;
  TextEditingController get priceController => _priceController;
  List<File> get photos => _photos;
  bool get isLoading => _isLoading;
  File get dp => _dp;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  TextEditingController get summaryController => _summaryController;

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
        _priceController.text.trim() != '' &&
        _summaryController.text.trim() != '') {
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
          summary: _summaryController.text.trim(),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          whoWillPay: [
            _result1,
            _result2,
            _result3,
            _result4,
            _result5,
            _result6
          ],
        );

        final _result =
            await VehicleProvider(vehicle: _vehicle).publishVehicle();

        if (_result == null) {
          _updateLoaderValue(false);
        } else {
          Navigator.pop(context);
        }
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

  // update vehicle
  Future updateVehicle(final AppUser appUser, final String existingId) async {
    if (_nameController.text.trim() != '' &&
        _modelYearController.text.trim() != '' &&
        _seatsController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _summaryController.text.trim() != '') {
      if (_dp != null) {
        _updateLoaderValue(true);

        String _mDp = '';
        List<String> _mPhotos = [];
        List<File> _newFilePhotos = [];
        List<String> _newStringPhotos = [];

        _mDp = _dp.path.contains('.com')
            ? _dp.path
            : await VehicleStorage().uploadVehicleDp(_dp);

        _photos.forEach((photo) {
          if (!photo.path.contains('.com')) {
            _newFilePhotos.add(photo);
          } else {
            _newStringPhotos.add(photo.path);
          }
        });

        if (_newFilePhotos.isNotEmpty) {
          _mPhotos = await VehicleStorage().uploadVehiclePhotos(_newFilePhotos);
        }

        final _vehicle = Vehicle(
          name: _nameController.text.trim(),
          modelYear: int.parse(_modelYearController.text.trim()),
          seats: int.parse(_seatsController.text.trim()),
          price: int.parse(_priceController.text.trim()),
          ownerId: appUser.uid,
          dp: _mDp,
          photos: [..._newStringPhotos, ..._mPhotos],
          summary: _summaryController.text.trim(),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          whoWillPay: [
            _result1,
            _result2,
            _result3,
            _result4,
            _result5,
            _result6
          ],
          id: existingId,
        );

        final _result =
            await VehicleProvider(vehicle: _vehicle).updateVehicle();

        if (_result == null) {
          _updateLoaderValue(false);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
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

  // update value of result
  updateResult1(final Map<String, dynamic> _result) {
    _result1 = _result;
    notifyListeners();
  }

  // update value of result
  updateResult2(final Map<String, dynamic> _result) {
    _result2 = _result;
    notifyListeners();
  }

  // update value of result
  updateResult3(final Map<String, dynamic> _result) {
    _result3 = _result;
    notifyListeners();
  }

  // update value of result
  updateResult4(final Map<String, dynamic> _result) {
    _result4 = _result;
    notifyListeners();
  }

  // update value of result
  updateResult5(final Map<String, dynamic> _result) {
    _result5 = _result;
    notifyListeners();
  }

  // update value of result
  updateResult6(final Map<String, dynamic> _result) {
    _result6 = _result;
    notifyListeners();
  }

  // update value of loader
  _updateLoaderValue(final bool _newVal) {
    _isLoading = _newVal;
    notifyListeners();
  }

  // initialize vehicles value
  initializeVehicleValues(final Vehicle vehicle) {
    _nameController.text = vehicle.name;
    _modelYearController.text = vehicle.modelYear.toString();
    _seatsController.text = vehicle.seats.toString();
    _priceController.text = vehicle.price.toString();
    _summaryController.text = vehicle.summary;
    _dp = File(vehicle.dp);

    List<File> _filePhotos = [];
    vehicle.photos.forEach((element) {
      final File _filePhoto = File(element);
      _filePhotos.add(_filePhoto);
    });
    _photos = _filePhotos;

    _result1 = vehicle.whoWillPay[0];
    _result2 = vehicle.whoWillPay[1];
    _result3 = vehicle.whoWillPay[2];
    _result4 = vehicle.whoWillPay[3];
    _result5 = vehicle.whoWillPay[4];
    _result6 = vehicle.whoWillPay[5];
  }

  // remove dp
  removeDpCallback() {
    _dp = null;
    notifyListeners();
  }

  // remove photos
  removeVehiclePhotos(final File vehiclePhoto) {
    _photos.remove(vehiclePhoto);
    notifyListeners();
  }
}
