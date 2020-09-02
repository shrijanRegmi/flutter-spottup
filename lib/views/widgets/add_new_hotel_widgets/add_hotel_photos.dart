import 'package:flutter/material.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';

class AddHotelPhotos extends StatelessWidget {
  final AddNewHotelVm vm;
  final bool isRoom;
  AddHotelPhotos(this.vm, {this.isRoom = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _addPhotosTextBuilder(),
        ),
        _addDpBuilder(context),
        _addPhotoBuilder(),
        SizedBox(
          height: isRoom ? 60.0 : 20.0,
        ),
      ],
    );
  }

  Widget _addPhotosTextBuilder() {
    return Text(
      isRoom ? 'Add room photos' : 'Add hotel photos',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _addDpBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: vm.uploadDp,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Color(0xff45ad90),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
            image: vm.dp != null
                ? DecorationImage(
                    image: FileImage(vm.dp),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: vm.dp != null
              ? Container()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: Color(0xff45ad90),
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _addPhotoBuilder() {
    final _list = ['', ...vm.photos.reversed];
    return Container(
      height: 120.0,
      child: ListView.builder(
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: GestureDetector(
                onTap: vm.uploadPhotos,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Color(0xff45ad90),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Color(0xff45ad90),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return _imgListItemBuilder(_list[index]);
        },
      ),
    );
  }

  Widget _imgListItemBuilder(final _img) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: GestureDetector(
        onTap: vm.uploadPhotos,
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Color(0xff45ad90),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: FileImage(_img),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
