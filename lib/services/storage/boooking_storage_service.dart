import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class BookingStorageService {
  // upload photos to storage;
  Future uploadHotelPhotos(final List<File> photos) async {
    try {
      List<String> _downloadUrls = [];
      for (final photo in photos) {
        final _uniqueId = Uuid();
        final _path =
            'payments/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}';

        final _ref = FirebaseStorage.instance.ref().child(_path);
        final _uploadTask = _ref.putFile(photo);
        await _uploadTask.whenComplete(() => null);
        print('Upload completed!!!!');
        final _downloadUrl = await _ref.getDownloadURL();
        print('Success: Uploading image to firebase storage');
        _downloadUrls.add(_downloadUrl);
      }
      return _downloadUrls;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading image to firebase storage');
      return null;
    }
  }
}
