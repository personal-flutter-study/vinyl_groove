import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_14/app_ctrl.dart';
import 'package:vinyl_groove_poc_14/main.dart';
import 'package:vinyl_groove_poc_14/screens/home_screen.dart';
import 'package:vinyl_groove_poc_14/screens/like_screen.dart';
import 'package:vinyl_groove_poc_14/screens/my_screen.dart';
import 'package:vinyl_groove_poc_14/screens/search_screen.dart';

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
              onTap: (value) {
                appCtrl.page.value = value;
              },
              currentIndex: value,
              type: .fixed,
              unselectedItemColor: Colors.white60,
              selectedItemColor: yellow,
              items:
                  [
                        (AppIcon.home, '홈'),
                        (AppIcon.search, '탐색'),
                        (AppIcon.heart, '관심상품'),
                        (AppIcon.mypage, '마이페이지'),
                      ].indexed
                      .map(
                        (e) => BottomNavigationBarItem(
                          icon: e.$2.$1.icon(
                            color: e.$1 == value ? yellow : Colors.white60,
                          ),
                          label: e.$2.$2,
                        ),
                      )
                      .toList(),
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: Builder(
              builder: (context) {
                final pages = [
                  HomeScreen(),
                  SearchScreen(),
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
