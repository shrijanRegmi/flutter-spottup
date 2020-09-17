import 'package:flutter/material.dart';
import 'package:motel/viewmodels/notifications_tab_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/notifications_tab_widgets/notifications_list_item.dart';

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VmProvider<NotificationTabVm>(
      vm: NotificationTabVm(context),
      builder: (context, vm, appUser) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.0,
            ),
            _titleBuilder(),
            Expanded(
              child: vm.notificationsList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : vm.notificationsList.isEmpty
                      ? _emptyBuilder()
                      : ListView.separated(
                          itemCount: vm.notificationsList.length,
                          itemBuilder: (context, index) {
                            return NotificationsListItem(
                              vm.notificationsList[index],
                              vm.readNotification,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 0.0,
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _titleBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'My Notifications',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _emptyBuilder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "You don't have any new notifications",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
