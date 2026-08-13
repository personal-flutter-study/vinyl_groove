import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_5/app_ctrl.dart';
import 'package:vinyl_groove_poc_5/screens/alert_screen.dart';

import '../main.dart';

class AppAppbar extends StatefulWidget implements PreferredSizeWidget {
  const AppAppbar({super.key});

  @override
  State<AppAppbar> createState() => _AppAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => .fromHeight(64);
}

class _AppAppbarState extends State<AppAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Image.asset('assets/logo_vertical.png'),
      ),
      leadingWidth: 132,
      actions: [
        ListenableBuilder(
          listenable: appCtrl.ticker,
          builder: (context, child) {
            final count = appCtrl.alerts?['unreadCount'] ?? 0;

            return IconButton(
              onPressed: () {
                context.go(AlertScreen());
                //message('알림은 준비중입니다.');
              },
              icon: count == 0
                  ? AppIcon.notification.icon(color: Colors.white, size: 28)
                  : Badge(
                      backgroundColor: Colors.red,
                      label: Text(
                        count > 9 ? '9+' : count.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      child: AppIcon.notification.icon(
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}
