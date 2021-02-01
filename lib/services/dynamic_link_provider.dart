import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/enums/analytics_status.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';

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

      var isInvite = deepLink.pathSegments.contains('user');

      if (isInvite) {
        var _userId = deepLink.queryParameters['id'];
        if (_userId != null) {
          await registerUserAsDynamicUser(_userId);
        }
      }
    }
  }

  Future<String> createInviteLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://spottup.net',
      link: Uri.parse("https://spottup.net/user?id=$uid"),
      androidParameters: AndroidParameters(
        packageName: 'com.spottup.app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Spott Up',
        description: 'Best deals for your next holiday.',
        imageUrl: Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/spott-up.appspot.com/o/welcome_img.jpg?alt=media&token=0e88f8e1-b8ff-4d10-a1e8-39635881d222'),
      ),
    );

    final dynamicUrl = await parameters.buildShortLink();

    return dynamicUrl.shortUrl.toString();
  }

  // register user as dynamic user
  Future registerUserAsDynamicUser(final String userId) async {
    try {
      final _dynamicUserRef = _ref
          .collection('users')
          .doc(userId)
          .collection('dynamic_users')
          .doc(uid);

      final _dynamicUserSnap = await _dynamicUserRef.get();

      if (!_dynamicUserSnap.exists) {
        final _appUserRef = _ref.collection('users').doc(uid);
        final _appUserSnap = await _appUserRef.get();
        AppUser _appUser;

        if (_appUserSnap.exists) {
          final _appUserData = _appUserSnap.data();
          if (_appUserData != null) {
            _appUser = AppUser.fromJson(_appUserData);
          }
        }

        if (_appUser != null) {
          final _data = {
            'uid': uid,
            'first_name': _appUser.firstName,
            'last_name': _appUser.lastName,
            'email': _appUser.email,
            'photo_url': _appUser.photoUrl ?? '',
            'analytic_status': AnalyticStatus.notBooked.index,
            'updated_at': DateTime.now().millisecondsSinceEpoch,
          };

          await _dynamicUserRef.set(_data);

          await UserProvider(uid: uid).updateUserData({
            'invitation_from': {
              'uid': userId,
            }
          });

          print('Success: registering user $uid as dynamic user to $userId');
        }
      }
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: registering user $uid as dynamic user to $userId');
      return null;
    }
  }
}
