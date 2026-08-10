import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/screens/alert_screen.dart';

import 'main.dart';

appBar(BuildContext context) => AppBar(
  backgroundColor: Colors.transparent,
  leading: Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Image.asset('assets/logo_vertical.png'),
  ),
  leadingWidth: 120,
  actions: [AlertWidget()],
);

class AlertWidget extends StatefulWidget {
  const AlertWidget({super.key});

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  Timer? timer;

  Map? alerts;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {});

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      alerts = await appCtrl.loadAlerts();
      if (mounted) setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = alerts?['unreadCount'];

    return IconButton(
      onPressed: () async {
        if (alerts != null) {
          await context.go(AlertScreen());
          alerts = await appCtrl.loadAlerts();
          setState(() {});
        }
        //context.message('알림 기능은 중비중 입니다.');
      },
      icon: count == null || count <= 0
          ? Icon(Icons.notifications_none, color: Colors.white, size: 32)
          : Badge(
              label: Text(
                count >= 10 ? '9+' : count.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 32,
              ),
            ),
    );
  }
}
