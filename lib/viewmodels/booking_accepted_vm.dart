import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/storage/boooking_storage_service.dart';

class BookingAcceptedVm extends ChangeNotifier {
  BuildContext context;
  BookingAcceptedVm(this.context);

  List<File> _photos = [];
  bool _isLoading = false;

  List<File> get photos => _photos;
  bool get isLoading => _isLoading;

  // upload payment photos
  uploadPhotos() async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final _file = _pickedImg != null ? File(_pickedImg.path) : null;
    if (_file != null) {
      _photos.add(_file);
    }
    notifyListeners();
  }

  // remove payment photos
  removePhotos(File file) {
    _photos.remove(file);
    notifyListeners();
  }

  // upload photos
  uploadPhotosToFirestore(final String bookingId) async {
    if (_photos.isNotEmpty) {
      _updateIsLoading(true);

      var _result = await BookingStorageService().uploadHotelPhotos(_photos);
      if (_result != null) {
        final _data = {
          'screenshots': _result,
        };
        _result = await HotelProvider().updateBookingData(_data, bookingId);
      }

      if (_result != null) {
        Navigator.pop(context);
        _showSuccessDialog();
      } else {
        _updateIsLoading(false);
      }
    }
  }

  // succes dialog
  _showSuccessDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              'Thank You',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              Icons.check,
              color: Color(0xff45ad90),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'We have received your screenshots with Motel app. Our customer service representative will contact you soon.',
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
