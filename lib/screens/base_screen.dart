import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_10/app_ctrl.dart';
import 'package:vinyl_groove_poc_10/main.dart';
import 'package:vinyl_groove_poc_10/screens/home_screen.dart';
import 'package:vinyl_groove_poc_10/screens/like_screen.dart';
import 'package:vinyl_groove_poc_10/screens/my_screen.dart';
import 'package:vinyl_groove_poc_10/screens/regi_screen.dart';
import 'package:vinyl_groove_poc_10/screens/search_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      appCtrl.loadAlerts();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await appCtrl.loadAlerts();
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
    return ValueListenableBuilder(
      valueListenable: appCtrl.page,
      builder: (context, value, child) {
        return SafeArea(
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: black2,
              onTap: (value) {
                if (value == 2) {
                  if (appCtrl.page.value == 3) {
                    context.re(BaseScreen());
                  }
                  context.go(RegiScreen());
                  return;
                }

                appCtrl.page.value = value;
              },
              currentIndex: value,
              unselectedItemColor: Colors.white60,
              selectedItemColor: yellow,
              type: .fixed,
              items:
                  [
                    (AppIcon.home, '홈'),
                    (AppIcon.search, '탐색'),
                    (AppIcon.search, '탐색'),
                    (AppIcon.heart, '관심상품'),
                    (AppIcon.mypage, '마이페이지'),
                  ].indexed.map((e) {
                    if (e.$1 == 2) {
                      return BottomNavigationBarItem(
                        icon: CircleAvatar(
                          backgroundColor: yellow,
                          radius: 24,
                          child: Icon(Icons.add, color: Colors.black),
                        ),
                        label: '',
                      );
                    }

                    return BottomNavigationBarItem(
                      icon: e.$2.$1.icon(
                        color: e.$1 == value ? yellow : Colors.white60,
                      ),
                      label: e.$2.$2,
                    );
                  }).toList(),
            ),
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: ValueListenableBuilder(
              valueListenable: appCtrl.ticker,
              builder: (context, _, child) {
                final pages = [
                  HomeScreen(),
                  SearchScreen(),
                  SizedBox(),
                  LikeScreen(),
                  MyScreen(),
                ];

                return pages[value];
              },
            ),
          ),
        );
      },
    );
  }
}
