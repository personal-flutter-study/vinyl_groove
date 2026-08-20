import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_13/app_ctrl.dart';
import 'package:vinyl_groove_poc_13/main.dart';
import 'package:vinyl_groove_poc_13/screeens/alert_screen.dart';

class AppAppbar extends StatefulWidget implements PreferredSizeWidget {
  const AppAppbar({super.key});

  @override
  State<AppAppbar> createState() => _AppAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => .fromHeight(68);
}

class _AppAppbarState extends State<AppAppbar> {
  @override
  Widget build(BuildContext context) {
    final icon = AppIcon.notification.icon(color: Colors.white, size: 28);
    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker2,
      builder: (context, _, child) {
        final count = appCtrl.alerts?['unreadCount'] ?? 0;

        return AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset('assets/logo_vertical.png'),
          ),
          leadingWidth: 132,
          actions: [
            IconButton(
              style: IconButton.styleFrom(),
              onPressed: () {
                context.go(AlertScreen());
                //message('알림', g: true);
              },
              icon: count == 0
                  ? icon
                  : Badge(
                      backgroundColor: Colors.red,
                      label: Text(
                        count > 9 ? '9+' : count.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      child: icon,
                    ),
            ),
          ],
        );
      },
    );
  }
}
