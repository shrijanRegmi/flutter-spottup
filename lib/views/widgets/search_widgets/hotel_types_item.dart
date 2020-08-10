import 'package:flutter/material.dart';

class HotelTypesItem extends StatefulWidget {
  final String imgPath;
  final String title;
  HotelTypesItem({this.imgPath, this.title});

  @override
  _HotelTypesItemState createState() => _HotelTypesItemState();
}

class _HotelTypesItemState extends State<HotelTypesItem> {
  bool _isTapped = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, top: 10.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(widget.imgPath), fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black12),
                      ],
                    ),
                  ),
                  if (_isTapped)
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
