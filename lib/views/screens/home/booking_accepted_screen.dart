import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/payment_model.dart';
import 'package:motel/viewmodels/booking_accepted_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class BookingAcceptedScreen extends StatelessWidget {
  final ConfirmBooking booking;
  final hotel;
  final bool admin;
  BookingAcceptedScreen(this.booking, this.hotel, {this.admin = false});

  @override
  Widget build(BuildContext context) {
    return VmProvider<BookingAcceptedVm>(
      vm: BookingAcceptedVm(context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          body: SafeArea(
            child: vm.isLoading
                ? Center(
                    child: Lottie.asset('assets/lottie/loading.json'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _appbarBuilder(context),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bookingAcceptTextBuilder(),
                              SizedBox(
                                height: 10.0,
                              ),
                              _detailsBuilder(),
                              SizedBox(
                                height: 40.0,
                              ),
                              _paymentDetails(vm.paymentDetails, vm),
                              SizedBox(
                                height: 40.0,
                              ),
                              if (!admin) _photoUploadBuilder(vm),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                        if (booking.screenshots.isEmpty && !admin)
                          RoundedBtn(
                            title: 'Upload',
                            onPressed: () =>
                                vm.uploadPhotosToFirestore(booking.bookingId),
                          ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _bookingAcceptTextBuilder() {
    return Text(
      '${hotel.name} - The booking was accepted !',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _detailsBuilder() {
    return Text(
      'Congratulations, we decided to accept the booking. Here are bank details and easy paisa details that you need to process. Please make 30% advance payment and upload the screenshot of the payment after processing it. Have a great day.',
    );
  }

  Widget _paymentDetails(Payment payment, BookingAcceptedVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Account Number :',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '${payment.bankAcNum}',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            IconButton(
              onPressed: () => vm.copyToClipboard(payment.bankAcNum),
              icon: Icon(Icons.content_copy),
              iconSize: 20.0,
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Easy Paisa Number :',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '${payment.easyPaisaNum}',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            IconButton(
              onPressed: () => vm.copyToClipboard(payment.easyPaisaNum),
              icon: Icon(Icons.content_copy),
              iconSize: 20.0,
            )
          ],
        ),
      ],
    );
  }

  Widget _photoUploadBuilder(BookingAcceptedVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload screenshot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        booking.screenshots.isNotEmpty
            ? Text('Screenshots already submitted')
            : _addPhotoBuilder(vm),
      ],
    );
  }

  Widget _addPhotoBuilder(BookingAcceptedVm vm) {
    final _list = ['', ...vm.photos.reversed];
    return Container(
      height: 120.0,
      child: ListView.builder(
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
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
          return _imgListItemBuilder(_list[index], vm);
        },
      ),
    );
  }

  Widget _imgListItemBuilder(final _img, final BookingAcceptedVm vm) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: GestureDetector(
        onTap: () async {},
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
                  onPressed: () => vm.removePhotos(_img),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
