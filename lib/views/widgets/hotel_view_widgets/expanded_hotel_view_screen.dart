import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/hotel_view_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_reviews_list.dart';
import 'package:provider/provider.dart';

import 'hotel_photos_list.dart';

class ExpandedHotelViewScreen extends StatefulWidget {
  final PageController pageController;
  final Hotel hotel;
  ExpandedHotelViewScreen({this.pageController, this.hotel});

  @override
  _ExpandedHotelViewScreenState createState() =>
      _ExpandedHotelViewScreenState();
}

class _ExpandedHotelViewScreenState extends State<ExpandedHotelViewScreen> {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibility.onChange.listen((visibility) {
      setState(() {
        _isKeyboardVisible = visibility;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return VmProvider<HotelViewVm>(
      vm: HotelViewVm(),
      onInit: (vm) {
        bool _isFav = _appUser.favourite.contains(widget.hotel.id);
        vm.updateFavourite(_isFav);
      },
      builder: (context, vm, appUser) {
        return Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _topSection(context, vm, appUser),
                  SizedBox(
                    height: 20.0,
                  ),
                  _hotelDetailBuilder(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Divider(),
                  ),
                  _summaryBuilder(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Divider(),
                  ),
                  if (widget.hotel.photos.isNotEmpty) HotelPhotosList(),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (widget.hotel.photos.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Divider(),
                    ),
                  if (widget.hotel.reviews.isNotEmpty) HotelReviewsList(),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: !_isKeyboardVisible
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RoundedBtn(
                    title: 'Book now',
                    padding: 0.0,
                    onPressed: () {},
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _topSection(BuildContext context, HotelViewVm vm, AppUser appUser) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.hotel.dp),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _btnSection(context, vm, appUser),
      ],
    );
  }

  Widget _btnSection(BuildContext context, HotelViewVm vm, AppUser appUser) {
    final _size = 50.0;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: _size,
                height: _size,
                child: FloatingActionButton(
                  onPressed: () {
                    widget.pageController.animateTo(-1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.ease);
                  },
                  child: Center(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  backgroundColor: Colors.black87,
                  heroTag: 'backBtn2',
                ),
              ),
              Container(
                width: _size,
                height: _size,
                child: FloatingActionButton(
                  onPressed: () {
                    vm.updateFavourite(!vm.isFavourite);
                    vm.sendFavourite(widget.hotel.id, appUser);
                  },
                  child: Center(
                    child: Icon(
                      vm.isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: Color(0xff45ad90),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  heroTag: 'favBtn2',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hotelDetailBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.hotel.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  '${widget.hotel.city}, ${widget.hotel.country}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black26,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Color(0xff45ad90),
                              size: 18.0,
                            ),
                            Text(
                              '4 Km from city',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black26,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '\$${widget.hotel.price}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),
              ),
              Text(
                '/per night',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Summary',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.hotel.summary,
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
