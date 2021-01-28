import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicLinkProvider {
  final String uid;
  DynamicLinkProvider(this.uid);

  final _ref = FirebaseFirestore.instance;

  Future handleDynamicLinks() async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // handle link that has been retrieved
    _handleDeepLink(data);

    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      var isInvite = deepLink.pathSegments.contains('invite');

      if (isInvite) {
        var _userId = deepLink.queryParameters['uid'];
        if (_userId != null && _userId != uid) {
          final _linkRef = _ref
              .collection('users')
              .doc(_userId)
              .collection('dynamic_links')
              .doc(uid);

          try {
            final _linkSnap = await _linkRef.get();
            if (!_linkSnap.exists) {
              final _data = {
                'accepted_by': uid,
                'updated_at': DateTime.now().millisecondsSinceEpoch,
              };

              await _linkRef.set(_data);
              print('Success: Opening dynamic link sent by $_userId');
            }
          } catch (e) {
            print(e);
            print('Error!!!: Opening dynamic link sent by $_userId');
          }
        }
      }
    }
  }

  Future<String> createInviteLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://spottup.net',
      link: Uri.parse("https://spottup.net/user?id='$uid'"),
      androidParameters: AndroidParameters(
        packageName: 'com.spottup.app',
      ),
    );

    final dynamicUrl = await parameters.buildShortLink();

    return dynamicUrl.shortUrl.toString();
  }
}
