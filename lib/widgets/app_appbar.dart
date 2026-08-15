import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_4/app_ctrl.dart';
import 'package:vinyl_groove_poc_4/screens/alert_screen.dart';

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
    final icon = AppIcon.notification.icon(color: Colors.white, size: 28);

    return ListenableBuilder(
      listenable: appCtrl.ticker,
      builder: (context, child) {
        final count = appCtrl.alerts?['unreadCount'] ?? 0;

        return AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset('assets/logo_vertical.png'),
          ),
          leadingWidth: 120,
          actions: [
            IconButton(
              onPressed: () {
                context.go(AlertScreen());
                //message('알림 기능은 준비중입니다.');
              },
              icon: count == 0
                  ? icon
                  : Badge(
                      backgroundColor: Colors.red,
                      label: Text(count > 9 ? '9+' : count.toString()),
                      child: icon,
                    ),
            ),
          ],
        );
      },
    );
  }
}
