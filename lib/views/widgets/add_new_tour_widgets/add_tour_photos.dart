import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/viewmodels/add_new_tour_vm.dart';

class AddTourPhotos extends StatefulWidget {
  final AddNewTourVm vm;
  final Tour existingTour;
  AddTourPhotos(this.vm, this.existingTour);

  @override
  _AddTourPhotosState createState() => _AddTourPhotosState();
}

class _AddTourPhotosState extends State<AddTourPhotos> {
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
          height: 20.0,
        ),
      ],
    );
  }

  Widget _addPhotosTextBuilder() {
    return Text(
      'Add tour photos',
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
        onTap: () async {
          await widget.vm.uploadDp();
          setState(() {});
        },
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
            image: widget.vm.dp != null && !widget.vm.dp.path.contains('.com')
                ? DecorationImage(
                    image: FileImage(
                      widget.vm.dp,
                    ),
                    fit: BoxFit.cover,
                  )
                : widget.vm.dp != null && widget.vm.dp.path.contains('.com')
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.existingTour.dp,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
          child: widget.vm.dp != null
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 50.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.grey[100],
                        onPressed: () {
                          widget.vm.removeDpCallback();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                )
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
    final _list = ['', ...widget.vm.photos.reversed];
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
                onTap: () async {
                  await widget.vm.uploadPhotos();
                  setState(() {});
                },
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
        onTap: () async {
          await widget.vm.uploadPhotos();
          setState(() {});
        },
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
              image: _img.path.contains('.com')
                  ? CachedNetworkImageProvider(
                      _img.path,
                    )
                  : FileImage(_img),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 40.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 18.0,
                  color: Colors.grey[100],
                  onPressed: () {
                    widget.vm.removeTourPhotos(_img);
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
