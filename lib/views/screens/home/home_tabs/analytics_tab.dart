import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/analytics_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/analytics_widgets/analytics_users_list.dart';
import 'package:motel/views/widgets/analytics_widgets/withdraw_earnings_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:provider/provider.dart';

class AnalyticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return VmProvider<AnalyticsVm>(
      vm: AnalyticsVm(context),
      onInit: (vm) => vm.onInit(_appUser),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          body: SafeArea(
            child: vm.isLoading || vm.dynamicUsers == null
                ? Center(
                    child: Lottie.asset('assets/lottie/loading.json'),
                  )
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          _titleBuilder(context, appUser),
                          SizedBox(
                            height: 20.0,
                          ),
                          vm.dynamicLink == null
                              ? _getStartedBuilder(vm, appUser)
                              : Column(
                                  children: [
                                    _linkBuilder(context, vm),
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    _earningBuilder(appUser),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Divider(),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    if (vm.dynamicUsers.isNotEmpty)
                                      Text(
                                        'Users who installed the app from your link',
                                      ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    AnalyticsUsersList(vm.dynamicUsers)
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _titleBuilder(final BuildContext context, final AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Invite Friends',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22.0,
            ),
          ),
          if (appUser.earnings > 0)
            TextButton(
              child: Text(
                'Withdraw',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WithdrawEarningScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _linkBuilder(BuildContext context, final AnalyticsVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    '${vm.dynamicLink}',
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => vm.copyLinkToClipboard(
                '${vm.dynamicLink}',
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(9.0),
                    topRight: Radius.circular(9.0),
                  ),
                  color: Color(0xff45ad90),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStartedBuilder(final AnalyticsVm vm, final AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Invite friends and your contacts and become 50% life time partner. Whenever your friends book any service, you will always get 50% of that net revenue. Be clear it's 50% of the revenue coming to the company through your shared link, not the percentage of the booking amount.",
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "1. After login, Share the link to all your contacts from the earning screen.",
          ),
          Text(
            "2. You can see who installed the App and who booked the service. We handle the rest.",
          ),
          Text(
            "3. You get earning statistics in earning screen when any of your friend book any service.",
          ),
          Text(
            "4. Withdraw through Easy Paisa or Bank Account.",
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Share more to earn more.",
          ),
          SizedBox(
            height: 10.0,
          ),
          RoundedBtn(
            title: 'Get Started',
            padding: 0.0,
            onPressed: () => vm.onPressedGetStarted(appUser),
          ),
        ],
      ),
    );
  }

  Widget _earningBuilder(final AppUser appUser) {
    return Container(
      child: Column(
        children: [
          Text(
            'Your earnings',
            style: TextStyle(
              color: Colors.black26,
            ),
          ),
          Text(
            'Rs ${appUser.earnings}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.0,
            ),
          )
        ],
      ),
    );
  }
}
