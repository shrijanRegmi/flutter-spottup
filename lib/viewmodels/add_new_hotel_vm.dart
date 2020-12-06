import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/storage/hotel_storage_service.dart';
import 'package:motel/models/app/hotel_features.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/add_new_room.dart';

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
  GlobalKey<ScaffoldState> _hotelScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> _roomScaffoldKey = GlobalKey<ScaffoldState>();
  List<HotelFeatures> _selectedFeatures = [];
  bool _isEditing = false;
  ScrollController _scrollController = ScrollController();

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
  GlobalKey<ScaffoldState> get hotelScaffoldKey => _hotelScaffoldKey;
  GlobalKey<ScaffoldState> get roomScaffoldKey => _roomScaffoldKey;
  List<HotelFeatures> get selectedFeatures => _selectedFeatures;
  bool get isEditing => _isEditing;
  ScrollController get scrollController => _scrollController;

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
        _summaryController.text.trim() != '') {
      if (_dp != null) {
        _updateLoaderValue(true);
        _updateProgressVal('Publishing Hotel Started');
        String _mDp = '';
        List<String> _mPhotos = [];
        int _adults = 0;
        int _kids = 0;

        for (final _room in _rooms) {
          _adults = _adults < _room.adults ? _room.adults : _adults;
          _kids = _kids < _room.kids ? _room.kids : _kids;
        }

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
            price: int.parse(_priceController.text.replaceAll(',', '').trim()),
            summary: _summaryController.text.trim(),
            dp: _mDp,
            photos: _mPhotos ?? [],
            ownerId: appUserId,
            rooms: _rooms.length,
            adults: _adults,
            kids: _kids,
            features: _selectedFeatures,
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
      } else {
        _hotelScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please upload display picture.'),
        ));
      }
    } else {
      _hotelScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all the input fields.'),
      ));
    }
  }

  // update hotel
  updateExistingHotel(
    final BuildContext context,
    final String appUserId,
    final Hotel hotel,
  ) async {
    if (_nameController.text.trim() != '' &&
        _cityController.text.trim() != '' &&
        _countryController.text.trim() != '' &&
        _priceController.text.trim() != '' &&
        _summaryController.text.trim() != '') {
      if (_dp != null) {
        _updateLoaderValue(true);
        String _mDp = hotel.dp;
        List<dynamic> _mPhotos = [];
        List<File> _newFilePhotos = [];
        List<String> _newStringPhotos = [];
        List<HotelFeatures> _existingFeatures = [];

        featuresList.forEach((element) {
          if (element.isSelected) {
            _existingFeatures.add(element);
          }
        });

        if (!_dp.path.contains('.com') && hotel.dp != _dp.path) {
          _mDp = await HotelStorage().uploadHotelDp(_dp);
        }

        _photos.forEach((photo) {
          if (!photo.path.contains('.com')) {
            _newFilePhotos.add(photo);
          } else {
            _newStringPhotos.add(photo.path);
          }
        });

        if (_newFilePhotos.isNotEmpty) {
          _mPhotos = await HotelStorage().uploadHotelPhotos(_newFilePhotos);
        }

        final _updatedHotel = Hotel(
          id: hotel.id,
          dp: _mDp,
          photos: [..._newStringPhotos, ..._mPhotos],
          ownerId: hotel.ownerId,
          kids: hotel.kids,
          adults: hotel.adults,
          rooms: hotel.rooms,
          features: _existingFeatures,
          searchKey: hotel.searchKey,
          name: _nameController.text.trim(),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          summary: _summaryController.text.trim(),
        );

        final _data = _updatedHotel.toJson();

        _data.removeWhere((key, value) =>
            value == hotel.searchKey ||
            value == hotel.id ||
            value == hotel.dp ||
            value == hotel.photos ||
            value == hotel.ownerId ||
            value == hotel.kids ||
            value == hotel.adults ||
            value == hotel.rooms ||
            value == hotel.photos ||
            value == hotel.features ||
            value == hotel.name ||
            value == hotel.city ||
            value == hotel.country ||
            value == hotel.price ||
            value == hotel.summary);

        var _result =
            await HotelProvider(hotelId: hotel.id).updateHotelData(_data);

        if (_rooms.isNotEmpty) {
          _result = await _updateRooms(_result);
        }

        if (_result == null) {
          _updateLoaderValue(false);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        _hotelScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please upload display picture.'),
        ));
      }
    } else {
      _hotelScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all the input fields.'),
      ));
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

  // update rooms
  _updateRooms(final DocumentReference _hotelRef) async {
    List<dynamic> _results;
    for (final _room in _rooms) {
      String _mRoomDp = _room.dp;
      List<String> _mRoomPhotos = [];
      List<String> _mStringRoomPhotos = [];
      List<File> _mFileRoomPhotos = [];

      if (!_room.dp.contains('.com')) {
        _mRoomDp = await HotelStorage().uploadHotelDp(File(_room.dp));
      }

      _roomPhotos.forEach((roomPhoto) {
        if (!roomPhoto.path.contains('.com')) {
          _mFileRoomPhotos.add(roomPhoto);
        } else {
          _mStringRoomPhotos.add(roomPhoto.path);
        }
      });

      if (_mFileRoomPhotos.isNotEmpty) {
        _mRoomPhotos = await HotelStorage().uploadHotelPhotos(_mFileRoomPhotos);
      }

      final _resultedRoom = Hotel(
        id: _room.id,
        adults: _room.adults,
        city: _room.city,
        country: _room.country,
        dp: _mRoomDp,
        photos: [..._mStringRoomPhotos, ..._mRoomPhotos],
        kids: _room.kids,
        name: _room.name,
        price: _room.price,
        summary: _room.summary,
        features: [],
      );

      final _data = _resultedRoom.toJson();

      final _result =
          await HotelProvider().updateRoomData(_hotelRef, _data, _room.id);

      _results = [];
      _results.add(_result);
    }
    return _results;
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
        features: [],
      );
      _updateProgressVal('Uploading Room Data');
      final _result =
          await HotelProvider().uploadNewRoom(_hotelRef, _resultedRoom);
      _results = [];
      _results.add(_result);
    }
    return _results;
  }

  // add rooms list
  addRoomList(final BuildContext context, final String appUserId,
      final AddNewHotelVm vm) async {
    if (_roomNameController.text.trim() != '' &&
        _roomAdultController.text.trim() != '' &&
        _roomKidController.text.trim() != '' &&
        _roomPriceController.text.trim() != '' &&
        _roomSummaryController.text.trim() != '') {
      if (_roomDp != null) {
        final _room = Hotel(
          name: _roomNameController.text.trim(),
          price: int.parse(_roomPriceController.text.trim()),
          summary: _roomSummaryController.text.trim(),
          dp: _roomDp.path,
          photos: _roomPhotos,
          ownerId: appUserId,
          kids: int.parse(_roomKidController.text.trim()),
          adults: int.parse(_roomAdultController.text.trim()),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
        );

        _rooms.add(_room);
        Navigator.pop(context);
        vm.clearControllers();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddNewRoom(vm, null, 0),
          ),
        );
        _scrollController.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      } else {
        _roomScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please upload display picture.'),
        ));
      }
    } else {
      _roomScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all the input fields.'),
      ));
    }
    notifyListeners();
  }

  // update rooms list
  updateRoomsList(
      final BuildContext context, final int _pos, final Hotel room) {
    if (_roomNameController.text.trim() != '' &&
        _roomAdultController.text.trim() != '' &&
        _roomKidController.text.trim() != '' &&
        _roomPriceController.text.trim() != '' &&
        _roomSummaryController.text.trim() != '') {
      if (_roomDp != null) {
        final _room = Hotel(
          id: room.id,
          name: _roomNameController.text.trim(),
          price: int.parse(_roomPriceController.text.trim()),
          summary: _roomSummaryController.text.trim(),
          dp: _roomDp.path,
          photos: _getStringFromFile(_roomPhotos),
          ownerId: room.ownerId,
          kids: int.parse(_roomKidController.text.trim()),
          adults: int.parse(_roomAdultController.text.trim()),
          city: _cityController.text.trim(),
          country: _countryController.text.trim(),
        );

        _rooms.insert(_pos, _room);
        _rooms.remove(room);
        Navigator.pop(context);
      } else {
        _roomScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please upload display picture.'),
        ));
      }
    } else {
      _roomScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill up all the input fields.'),
      ));
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

  // remove hotel dp
  removeHotelDp() {
    _dp = null;
    notifyListeners();
  }

  // remove hotel dp
  removeRoomDp() {
    _roomDp = null;
    notifyListeners();
  }

  // remove hotel photo
  removeHotelPhoto(final File hotelPhoto) {
    _photos.remove(hotelPhoto);
    notifyListeners();
  }

  // remove room photo
  removeRoomPhoto(final File roomPhoto) {
    _roomPhotos.remove(roomPhoto);
    notifyListeners();
  }

  // remove room
  removeRoom(final Hotel room) {
    _rooms.remove(room);
    notifyListeners();
  }

  // add features
  addFeature(final HotelFeatures feature) {
    _selectedFeatures.add(feature);
    notifyListeners();
  }

  // remove feature
  removeFeature(final HotelFeatures feature) {
    _selectedFeatures.remove(feature);
    notifyListeners();
  }

  // initialize all the hotel values
  initializeHotelValues(final Hotel hotel) async {
    _isEditing = true;

    // general details
    _nameController.text = hotel.name;
    _cityController.text = hotel.city;
    _countryController.text = hotel.country;
    _priceController.text = hotel.price.toString();
    _summaryController.text = hotel.summary;

    // hotel features
    List<String> _featuresListTitle = [];
    List<String> _hotelFeaturesTitle = [];
    List<int> _position = [];
    featuresList.forEach((element) {
      _featuresListTitle.add(element.title);
    });
    hotel.features.forEach((element) {
      _hotelFeaturesTitle.add(element.title);
    });
    _featuresListTitle.forEach((element) {
      if (_hotelFeaturesTitle.contains(element)) {
        _position.add(_featuresListTitle.indexOf(element));
      }
    });
    _position.forEach((element) {
      featuresList[element].isSelected = true;
    });

    // rooms
    final _ref = Firestore.instance;
    final _roomsRef =
        _ref.collection('hotels').document(hotel.id).collection('rooms');

    final _roomsSnap = await _roomsRef.getDocuments();
    if (_roomsSnap.documents.isNotEmpty) {
      for (var _roomSnap in _roomsSnap.documents) {
        final _room = Hotel.fromJson(_roomSnap.data);
        _rooms.add(_room);
      }
    }

    // images
    _dp = File(hotel.dp);
    _photos = _getFileFromString(List<String>.from(hotel.photos));

    notifyListeners();
  }

  // initialize all the room values
  initializeRoomValues(final Hotel room) async {
    _isEditing = true;

    // general details
    _roomNameController.text = room.name;
    _roomAdultController.text = room.adults.toString();
    _roomKidController.text = room.kids.toString();
    _roomPriceController.text = room.price.toString();
    _roomSummaryController.text = room.summary;

    // images
    _roomDp = File(room.dp);
    _roomPhotos = _getFileFromString(List<String>.from(room.photos));

    notifyListeners();
  }

  _getFileFromString(final List<String> hotelPhotos) {
    List<File> _list = [];
    hotelPhotos.forEach((element) {
      _list.add(File(element));
    });
    return _list;
  }

  _getStringFromFile(final List<File> hotelPhotos) {
    List<String> _list = [];
    hotelPhotos.forEach((element) {
      _list.add(element.path);
    });
    return _list;
  }
}
