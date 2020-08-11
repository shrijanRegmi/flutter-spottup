import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File _imgFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              _userImgBuilder(context),
              SizedBox(
                height: 20.0,
              ),
              _nameBuilder(),
              SizedBox(
                height: 40.0,
              ),
              _editProfileSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Amanda Rowling',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _userImgBuilder(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.50;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            _imgFile != null
                ? Container(
                    width: _width,
                    height: _width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 13.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2.0, 10.0),
                            blurRadius: 20.0,
                            color: Colors.black12)
                      ],
                      image: DecorationImage(
                        image: FileImage(
                          _imgFile,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    width: _width,
                    height: _width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 13.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2.0, 10.0),
                            blurRadius: 20.0,
                            color: Colors.black12)
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svgs/upload_img.svg',
                        width: _width,
                        height: _width,
                      ),
                    ),
                  ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Container(
                width: 50.0,
                height: 50.0,
                child: FloatingActionButton(
                  child: Center(
                    child: Icon(Icons.photo_camera),
                  ),
                  backgroundColor: Color(0xff45ad90),
                  onPressed: () async {
                    final _pickedFile = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    setState(() {
                      if (_pickedFile != null) {
                        _imgFile = File(_pickedFile.path);
                      } else {
                        _imgFile = null;
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editProfileSection(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        _editProfileItem(
          context,
          'Email',
          'ilyyhs9@gmail.com',
          TextInputType.emailAddress,
        ),
        _editProfileItem(
          context,
          'Phone',
          '9082727277',
          TextInputType.phone,
        ),
        _editProfileItem(
          context,
          'Date of birth',
          '20th Aug, 1990',
          TextInputType.datetime,
        ),
        _editProfileItem(
          context,
          'Address',
          'Golfutar, Kathmandu',
          TextInputType.text,
        ),
      ],
    );
  }

  Widget _editProfileItem(BuildContext context, final String title,
      final String value, final TextInputType type) {
    return GestureDetector(
      onTap: () {
        if (title != 'Email') {
          _showEditDialog(context, title, type);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black38,
                          fontSize: 12.0,
                        ),
                      ),
                      if (title != 'Email')
                        SizedBox(
                          width: 5.0,
                        ),
                      if (title != 'Email')
                        Icon(
                          Icons.edit,
                          size: 14.0,
                          color: Colors.black38,
                        ),
                    ],
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future _showEditDialog(BuildContext context, final String title,
      final TextInputType type) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${title.toLowerCase()}'),
        content: TextFormField(
          keyboardType: type,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: title != 'Address'
                ? 'New ${title.toLowerCase()}'
                : 'New Street, City, Country',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff45ad90),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            textColor: Colors.red,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            textColor: Color(0xff45ad90),
            child: Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
