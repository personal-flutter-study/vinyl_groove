import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_8/app_ctrl.dart';
import 'package:vinyl_groove_poc_8/screens/home_screen.dart';
import 'package:vinyl_groove_poc_8/screens/like_screen.dart';
import 'package:vinyl_groove_poc_8/screens/my_screen.dart';
import 'package:vinyl_groove_poc_8/screens/regi_screen.dart';
import 'package:vinyl_groove_poc_8/screens/search_screen.dart';

import '../main.dart';

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
      await appCtrl.loadAlerts();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      appCtrl.loadAlerts();
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
              unselectedItemColor: Colors.white60,
              selectedItemColor: yellow,
              currentIndex: value,
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
                          child: Icon(Icons.add, color: black),
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
            backgroundColor: black,
            resizeToAvoidBottomInset: false,
            body: ListenableBuilder(
              listenable: appCtrl.ticker,
              builder: (context, child) {
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
