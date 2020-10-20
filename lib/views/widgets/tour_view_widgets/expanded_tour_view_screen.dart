import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/hotel_view_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_photos_list.dart';
import 'package:provider/provider.dart';

class ExpandedTourViewScreen extends StatefulWidget {
  final PageController pageController;
  final Tour tour;
  ExpandedTourViewScreen({
    this.pageController,
    this.tour,
  });

  @override
  _ExpandedTourViewScreenState createState() => _ExpandedTourViewScreenState();
}

class _ExpandedTourViewScreenState extends State<ExpandedTourViewScreen> {
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
      vm: HotelViewVm(context: context),
      onInit: (vm) {
        bool _isFav = _appUser.favourite.contains(widget.tour.id);
        vm.updateFavourite(_isFav);
      },
      builder: (context, vm, appUser) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(bottom: 50.0),
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
                  _inclusionBuilder(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Divider(),
                  ),
                  _exclusionBuilder(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Divider(),
                  ),
                  _paymentAndCancellationPolicy(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Divider(),
                  ),
                  if (widget.tour.photos.isNotEmpty)
                    HotelPhotosList(widget.tour.photos),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (widget.tour.photos.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Divider(),
                    ),
                  // HotelReviewsList(widget.tour),
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
              image: CachedNetworkImageProvider(widget.tour.dp),
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
                    vm.sendFavourite(widget.tour.id, appUser);
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
                  widget.tour.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  '${widget.tour.days} days, ${widget.tour.nights} nights',
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
                        Text(
                          '${DateHelper().getFormattedDate(widget.tour.start)} - ${DateHelper().getFormattedDate(widget.tour.end)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: Colors.black26,
                          ),
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
                'Rs ${widget.tour.price}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),
              ),
              Text(
                '/per person',
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
            widget.tour.summary,
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inclusionBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Inclusion Policy',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.tour.inclusions,
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _exclusionBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Exclusion Policy',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.tour.exclusions,
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentAndCancellationPolicy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Payment and Cancellation Policy',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.tour.paymentAndCancellationPolicy,
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
