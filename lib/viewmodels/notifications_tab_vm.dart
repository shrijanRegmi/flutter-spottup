import 'package:flutter/material.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:provider/provider.dart';

class NotificationTabVm extends ChangeNotifier {
  final BuildContext context;
  NotificationTabVm(this.context);

  List<AppNotification> get notificationsList =>
      Provider.of<List<AppNotification>>(context);

  // read notification
  readNotification(final String uid, final String notifId) async {
    return await UserProvider(uid: uid).readNotification(notifId);
  }
}
