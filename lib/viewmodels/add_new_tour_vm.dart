import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/app/tour_types.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/tour_provider.dart';
import 'package:motel/services/storage/tour_storage_service.dart';

class AddNewTourVm extends ChangeNotifier {
  BuildContext context;
  AddNewTourVm(this.context);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _nightsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _personController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  TextEditingController _inclusionsController = TextEditingController();
  TextEditingController _exclusionsController = TextEditingController();
  TextEditingController _paymentPolicyController = TextEditingController();
  List<File> _photos = [];
  bool _isLoading = false;
  File _dp;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _start;
  DateTime _end;
  DateTime _pickUpDate;
  TimeOfDay _pickUpTime;
  TourType _selectedTourType = TourType.date;
  String _selectedDayOfWeek = 'Sunday';

  TextEditingController get nameController => _nameController;
  TextEditingController get daysController => _daysController;
  TextEditingController get nightsController => _nightsController;
  TextEditingController get priceController => _priceController;
  TextEditingController get personController => _personController;
  TextEditingController get summaryController => _summaryController;
  TextEditingController get inclusionsController => _inclusionsController;
  TextEditingController get exclusionsController => _exclusionsController;
  TextEditingController get paymentPolicyController => _paymentPolicyController;
  List<File> get photos => _photos;
  bool get isLoading => _isLoading;
  File get dp => _dp;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  DateTime get start => _start;
  DateTime get end => _end;
  DateTime get pickUpDate => _pickUpDate;
  TimeOfDay get pickUpTime => _pickUpTime;
  TourType get selectedTourType => _selectedTourType;
  String get selectedDayOfWeek => _selectedDayOfWeek;

  // show start tour dialog
  Future showStartTourDialog() async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _start ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _start = _pickedDate;
      notifyListeners();
    }
  }

  // show end tour dialog
  Future showEndTourDialog() async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _end ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _end = _pickedDate;
      notifyListeners();
    }
  }

  // show pick up date dialog
  Future showPickUpDateDialog() async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _pickUpDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _pickUpDate = _pickedDate;
      notifyListeners();
    }
  }

  // show pick up time dialog
  Future showPickUpTimeDialog() async {
    final _pickedDate = await showTimePicker(
      context: context,
      initialTime: _pickUpTime ?? TimeOfDay.now(),
    );
    if (_pickedDate != null) {
      _pickUpTime = _pickedDate;
      notifyListeners();
    }
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

  // upload tour
  Future publishTour(final AppUser appUser) async {
    if (_nameController.text.trim() != '' &&
        _daysController.text.trim() != '' &&
        _nightsController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _personController.text.trim() != '' &&
        _pickUpTime != null &&
        ((_selectedTourType == TourType.date &&
                _start != null &&
                _end != null &&
                _pickUpDate != null) ||
            _selectedTourType == TourType.weekly) &&
        _summaryController.text.trim() != '' &&
        _inclusionsController.text.trim() != '' &&
        _exclusionsController.text.trim() != '' &&
        _paymentPolicyController.text.trim() != '') {
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
          start: _start?.millisecondsSinceEpoch,
          end: _end?.millisecondsSinceEpoch,
          summary: _summaryController.text.trim(),
          inclusions: _inclusionsController.text.trim(),
          exclusions: _exclusionsController.text.trim(),
          ownerId: appUser.uid,
          dp: _mDp,
          photos: _mPhotos,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          paymentAndCancellationPolicy: _paymentPolicyController.text.trim(),
          pickUpDate: _pickUpDate?.millisecondsSinceEpoch,
          pickUpTime: _pickUpTime?.format(context),
          type: _selectedTourType,
          day: _selectedDayOfWeek,
        );

        final _result = await TourProvider(tour: _tour).publishTour();

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
        content: Text(
            'Please fill up all the input fields and select all the date/time.'),
      ));
    }
  }

  // update tour
  updateTour(final AppUser appUser, final String existingTourId) async {
    if (_nameController.text.trim() != '' &&
        _daysController.text.trim() != '' &&
        _nightsController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _personController.text.trim() != '' &&
        _pickUpTime != null &&
        ((_selectedTourType == TourType.date &&
                _start != null &&
                _end != null &&
                _pickUpDate != null) ||
            _selectedTourType == TourType.weekly) &&
        _summaryController.text.trim() != '' &&
        _inclusionsController.text.trim() != '' &&
        _exclusionsController.text.trim() != '' &&
        _paymentPolicyController.text.trim() != '') {
      if (_dp != null) {
        _updateLoaderValue(true);

        String _mDp = '';
        List<String> _mPhotos = [];
        List<File> _newFilePhotos = [];
        List<String> _newStringPhotos = [];

        _mDp = _dp.path.contains('.com')
            ? _dp.path
            : await TourStorage().uploadTourDp(_dp);

        _photos.forEach((photo) {
          if (!photo.path.contains('.com')) {
            _newFilePhotos.add(photo);
          } else {
            _newStringPhotos.add(photo.path);
          }
        });

        if (_newFilePhotos.isNotEmpty) {
          _mPhotos = await TourStorage().uploadTourPhotos(_newFilePhotos);
        }

        final _tour = Tour(
          name: _nameController.text.trim(),
          days: int.parse(_daysController.text.trim()),
          nights: int.parse(_nightsController.text.trim()),
          price: int.parse(_priceController.text.replaceAll(',', '').trim()),
          person: int.parse(_personController.text.trim()),
          start: _start?.millisecondsSinceEpoch,
          end: _end?.millisecondsSinceEpoch,
          summary: _summaryController.text.trim(),
          inclusions: _inclusionsController.text.trim(),
          exclusions: _exclusionsController.text.trim(),
          ownerId: appUser.uid,
          dp: _mDp,
          photos: [..._newStringPhotos, ..._mPhotos],
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          paymentAndCancellationPolicy: _paymentPolicyController.text.trim(),
          pickUpDate: _pickUpDate?.millisecondsSinceEpoch,
          pickUpTime: _pickUpTime?.format(context),
          id: existingTourId,
          type: _selectedTourType,
          day: _selectedDayOfWeek,
        );

        final _result = await TourProvider(tour: _tour).updateTour();

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
        content: Text(
            'Please fill up all the input fields and select all the date/time.'),
      ));
    }
  }

  // update value of loader
  _updateLoaderValue(final bool _newVal) {
    _isLoading = _newVal;
    notifyListeners();
  }

  // initialize tour values
  initializeTourValues(final Tour tour) {
    _nameController.text = tour.name;
    _daysController.text = tour.days.toString();
    _nightsController.text = tour.nights.toString();
    _personController.text = tour.person.toString();
    _priceController.text = tour.price.toString();
    _summaryController.text = tour.summary;
    _inclusionsController.text = tour.inclusions;
    _exclusionsController.text = tour.exclusions;
    _paymentPolicyController.text = tour.paymentAndCancellationPolicy;
    _selectedTourType = tour.type;
    _dp = File(tour.dp);

    List<File> _filePhotos = [];
    tour.photos.forEach((element) {
      final File _filePhoto = File(element);
      _filePhotos.add(_filePhoto);
    });
    _photos = _filePhotos;

    if (tour.type == TourType.date) {
      _start = DateTime.fromMillisecondsSinceEpoch(tour.start);
      _end = DateTime.fromMillisecondsSinceEpoch(tour.end);
      _pickUpDate = DateTime.fromMillisecondsSinceEpoch(tour.pickUpDate);
    } else {
      _selectedDayOfWeek = tour.day;
    }

    final _newTime =
        tour.pickUpTime.toLowerCase().replaceAll('pm', '').replaceAll('am', '');

    _pickUpTime = TimeOfDay(
        hour: tour.pickUpTime.toLowerCase().contains('pm')
            ? (12 + int.parse(_newTime.split(":")[0]))
            : int.parse(_newTime.split(":")[0]),
        minute: int.parse(_newTime.split(":")[1]));
  }

  // remove dp
  removeDpCallback() {
    _dp = null;
    notifyListeners();
  }

  // remove photos
  removeTourPhotos(final File tourPhoto) {
    _photos.remove(tourPhoto);
    notifyListeners();
  }

  // update value of selected tour type
  updateSelectedTourType(final TourType newVal) {
    _selectedTourType = newVal;
    notifyListeners();
  }

  // update value of selected day of week
  updateSelectedDayOfWeek(final String newVal) {
    _selectedDayOfWeek = newVal;
    notifyListeners();
  }
}
