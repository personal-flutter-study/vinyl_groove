import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/main.dart';
import 'package:vinyl_groove_poc_2/screens/alert_screen.dart';

class AppAppbar extends StatefulWidget implements PreferredSizeWidget {
  const AppAppbar({super.key});

  @override
  State<AppAppbar> createState() => _AppAppbarState();

  @override
  Size get preferredSize => .fromHeight(60);
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
      leadingWidth: 120,
      actions: [
        ListenableBuilder(
          listenable: appCtrl.ticker,
          builder: (context, child) {
            final count = appCtrl.alerts?['unreadCount'] ?? 0;
            return IconButton(
              onPressed: () {
                context.go(AlertScreen());
                //message('알림 페이지는 현재 준비중 입니다.');
              },
              icon: count == 0
                  ? AppIcon.notification.icon(color: Colors.white, size: 28)
                  : Badge(
                      label: Text(count > 10 ? '9+' : count.toString()),
                      backgroundColor: Colors.red,
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
