import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_7/app_ctrl.dart';
import 'package:vinyl_groove_poc_7/screens/home_screen.dart';
import 'package:vinyl_groove_poc_7/screens/like_screen.dart';
import 'package:vinyl_groove_poc_7/screens/my_screen.dart';
import 'package:vinyl_groove_poc_7/screens/regi_screen.dart';
import 'package:vinyl_groove_poc_7/screens/search_screen.dart';

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
              unselectedItemColor: Colors.white60,
              selectedItemColor: yellow,
              onTap: (value) {
                if (value == 2) {
                  context.go(RegiScreen());
                  return;
                }

                appCtrl.page.value = value;
              },
              type: .fixed,
              currentIndex: value,
              items:
                  [
                    (AppIcon.home, '홈'),
                    (AppIcon.search, '탐색'),
                    (AppIcon.search, '탐색'),
                    (AppIcon.heart, '관심상품'),
                    (AppIcon.person, '마이페이지'),
                  ].indexed.map((e) {
                    if (e.$1 == 2) {
                      return BottomNavigationBarItem(
                        icon: CircleAvatar(
                          backgroundColor: yellow,
                          radius: 24,
                          child: AppIcon.add.icon(color: black),
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
            resizeToAvoidBottomInset: false,
            backgroundColor: black,
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
