import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/main.dart';
import 'package:vinyl_groove_poc_3/screens/alert_screen.dart';

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
    final count = appCtrl.alerts?['unreadCount'] ?? 0;

    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Image.asset('assets/logo_vertical.png'),
      ),
      leadingWidth: 120,
      actions: [
        IconButton(
          onPressed: () {
            context.go(AlertScreen());

            //message('알림은 준비 중입니다.');
          },
          icon: count == 0
              ? AppIcon.notification.icon(color: Colors.white, size: 32)
              : Badge(
                  label: Text(
                    count > 9 ? '9+' : count.toString(),
                    style: TextStyle(color: Colors.white, fontWeight: .bold),
                  ),
                  child: AppIcon.notification.icon(
                    color: Colors.white,
                    size: 32,
                  ),
                ),
        ),
      ],
    );
  }
}
