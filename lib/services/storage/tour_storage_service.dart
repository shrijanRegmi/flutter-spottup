import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class TourStorage {
  // upload user image to storage;
  Future uploadTourDp(final File dp) async {
    try {
      final _uniqueId = Uuid();
      final _path =
          'tour/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}';

      StorageReference _ref = FirebaseStorage.instance.ref().child(_path);
      StorageUploadTask _uploadTask = _ref.putFile(dp);
      await _uploadTask.onComplete;
      print('Upload completed!!!!');
      final _downloadUrl = await _ref.getDownloadURL();
      print('Success: Uploading image to firebase storage');
      return _downloadUrl;
    } catch (e) {
      print(e);
      print('Error!!!: Uploading image to firebase storage');
      return null;
    }
  }

  // upload photos image to storage;
  Future uploadTourPhotos(final List<File> photos) async {
    try {
      List<String> _downloadUrls = [];
      for (final photo in photos) {
        final _uniqueId = Uuid();
        final _path =
            'tour/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}';

        StorageReference _ref = FirebaseStorage.instance.ref().child(_path);
        StorageUploadTask _uploadTask = _ref.putFile(photo);
        await _uploadTask.onComplete;
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