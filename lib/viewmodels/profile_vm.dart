import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCopied = false;

  File get imgFile => _imgFile;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get addressController => _addressController;
  bool get isUpdatingData => _isUpdatingData;
  DateTime get dob => _dob;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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
  Future update(
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
      update(_data, appUser);
    }
    notifyListeners();
  }

  // open invite friends dialog
  showInviteDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (contexth, setState) => AlertDialog(
          title: Text('Invite friends'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Copy the given link and share with your friends. If they install the app and do their first booking then you will get commission !',
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'djfksa kfdkajf kdj fkdjfk jadfj kdsa',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        _isCopied
                            ? Icon(
                                Icons.check,
                                color: Color(0xff45ad90),
                                size: 18.0,
                              )
                            : IconButton(
                                onPressed: () => _copyToClipboard(
                                  'My name is Shrijan Regmi',
                                  setState,
                                ),
                                icon: Icon(Icons.content_copy),
                                iconSize: 15.0,
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'OK, Got it',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff45ad90),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // copy to clipboard
  _copyToClipboard(final String text, final setState) async {
    setState(() {
      _isCopied = true;
    });
    await Clipboard.setData(ClipboardData(text: text));
  }
}
