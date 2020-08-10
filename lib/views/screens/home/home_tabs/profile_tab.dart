import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
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
              _editProfileSection(),
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
            Container(
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
                  image: AssetImage(
                    'assets/images/welcome_img.jpg',
                  ),
                  fit: BoxFit.cover,
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
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editProfileSection() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        _editProfileItem('Email', 'ilyyhs9@gmail.com'),
        _editProfileItem('Phone', '9082727277'),
        _editProfileItem('Date of birth', '20th Aug, 1990'),
        _editProfileItem('Address', 'Golfutar, Kathmandu'),
      ],
    );
  }

  Widget _editProfileItem(final String title, final String value) {
    return Padding(
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
    );
  }
}
