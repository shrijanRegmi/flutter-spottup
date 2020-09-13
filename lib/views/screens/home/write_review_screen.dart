import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/viewmodels/review_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class WriteReviewScreen extends StatelessWidget {
  final String hotelId;
  WriteReviewScreen(this.hotelId);

  @override
  Widget build(BuildContext context) {
    return VmProvider<ReviewVm>(
      vm: ReviewVm(context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: vm.isLoading
                  ? Center(
                      child: Lottie.asset('assets/lottie/loading.json'),
                    )
                  : Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _appbarBuilder(context),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _reviewTextBuilder(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      SmoothStarRating(
                                        size: 50.0,
                                        allowHalfRating: false,
                                        color: Color(0xff45ad90),
                                        borderColor: Color(0xff45ad90),
                                        onRated: vm.updateStars,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  AuthField(
                                    hintText: 'Your review',
                                    isExpanded: true,
                                    controller: vm.reviewController,
                                  ),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                ],
                              ),
                            ),
                            RoundedBtn(
                              title: 'Submit',
                              onPressed: () =>
                                  vm.submitReview(appUser, hotelId),
                            )
                          ],
                        ),
                      ),
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

  Widget _reviewTextBuilder() {
    return Text(
      'Write Review',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }
}
