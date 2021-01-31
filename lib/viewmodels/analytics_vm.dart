import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/dynamic_link_provider.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:provider/provider.dart';

class AnalyticsVm extends ChangeNotifier {
  final BuildContext context;
  AnalyticsVm(this.context);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _dynamicLink = '';
  bool _isLoading = false;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  String get dynamicLink => _dynamicLink;
  bool get isLoading => _isLoading;

  List<AppUser> get dynamicUsers => Provider.of<List<AppUser>>(context);

  // init function
  onInit(final AppUser appUser) {
    updateDynamicLink(appUser.dynamicLink);
  }

  // on pressed get started btn
  onPressedGetStarted(final AppUser appUser) async {
    updateIsLoading(true);

    final _link = await DynamicLinkProvider(appUser.uid).createInviteLink();
    await UserProvider(uid: appUser.uid)
        .updateUserData({'dynamic_link': _link});
    updateDynamicLink(_link);

    updateIsLoading(false);
  }

  // copy to clipboard
  copyLinkToClipboard(final String linkToCopy) async {
    await Clipboard.setData(ClipboardData(text: linkToCopy));

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          'Link copied to clipboard !',
        ),
      ),
    );
  }

  // update value of link
  updateDynamicLink(final String newVal) {
    _dynamicLink = newVal;
    notifyListeners();
  }

  // update value of loader
  updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
