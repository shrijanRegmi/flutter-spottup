import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/viewmodels/hotel_view_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/vehicle_book_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_photos_list.dart';
import 'package:motel/views/widgets/vehicles_tab_widgets/add_new_vehicle.dart';
import 'package:provider/provider.dart';

class ExpandedVehicleViewScreen extends StatefulWidget {
  final PageController pageController;
  final Vehicle vehicle;
  final bool isEditing;
  ExpandedVehicleViewScreen({
    this.pageController,
    this.vehicle,
    this.isEditing = false,
  });

  @override
  _ExpandedVehicleViewScreenState createState() =>
      _ExpandedVehicleViewScreenState();
}

class _ExpandedVehicleViewScreenState extends State<ExpandedVehicleViewScreen> {
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
        bool _isFav = _appUser.favourite.contains(widget.vehicle.id);
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
                  if (widget.vehicle.photos.isNotEmpty)
                    HotelPhotosList(widget.vehicle.photos),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (widget.vehicle.photos.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Divider(),
                    ),
                  ..._whoWillPayBuilder(),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: !_isKeyboardVisible &&
                  appUser.accountType != AccountType.vehiclePartner
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RoundedBtn(
                    title: 'Book now',
                    padding: 0.0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleBookScreen(widget.vehicle),
                        ),
                      );
                    },
                  ),
                )
              : widget.isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddNewVehicle(
                                  vehicle: widget.vehicle,
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: Icon(Icons.edit),
                          ),
                          backgroundColor: Color(0xff45ad90),
                          heroTag: 'edit',
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        FloatingActionButton(
                          onPressed: () => vm.deleteVehicle(widget.vehicle.id),
                          child: Center(
                            child: Icon(Icons.delete),
                          ),
                          backgroundColor: Color(0xff45ad90),
                          heroTag: 'delete',
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                      ],
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
              image: CachedNetworkImageProvider(widget.vehicle.dp),
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
              if (appUser.accountType != AccountType.vehiclePartner)
                Container(
                  width: _size,
                  height: _size,
                  child: FloatingActionButton(
                    onPressed: () {
                      vm.updateFavourite(!vm.isFavourite);
                      vm.sendFavourite(widget.vehicle.id, appUser);
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
                  widget.vehicle.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  'Model Year: ${widget.vehicle.modelYear}',
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
                          '${widget.vehicle.seats} Seats',
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
                'Rs ${widget.vehicle.price}',
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
            widget.vehicle.summary,
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _whoWillPayBuilder() {
    final _whoWillPay = widget.vehicle.whoWillPay ?? [];
    List<Widget> _list = [];
    for (int i = 0; i < _whoWillPay.length; i++) {
      _list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${i + 1}. ${_whoWillPay[i]['title']}',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${_whoWillPay[i]['value']}',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }
    return _list;
  }
}
