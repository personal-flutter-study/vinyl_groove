import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      get(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: authHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);
        if (value.statusCode == 200) {
          alerts = body['data'];
          setState(() {});
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      get(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: authHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);
        if (value.statusCode == 200) {
          alerts = body['data'];
          setState(() {});
        }
      });
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
    return IconButton(
      onPressed: () {
        if (alerts != null) {
          context.go(AlertScreen(alerts: alerts?['notifications'] ?? []));
        }
        //context.message('알림 기능은 중비중 입니다.');
      },
      icon: alerts?['unreadCount'] == null
          ? Icon(Icons.notifications_none, color: Colors.white, size: 32)
          : Badge.count(
              count: alerts!['unreadCount'],
              child: Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 32,
              ),
            ),
    );
  }
}
