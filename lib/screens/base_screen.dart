import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/screens/home_screen.dart';
import 'package:vinyl_groove_poc_2/screens/like_screen.dart';
import 'package:vinyl_groove_poc_2/screens/my_screen.dart';
import 'package:vinyl_groove_poc_2/screens/regi_screen.dart';
import 'package:vinyl_groove_poc_2/screens/search_screen.dart';

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
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: appCtrl.page,
        builder: (context, value, child) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: yellow,
              unselectedItemColor: Colors.white60,
              backgroundColor: black2,
              currentIndex: value,
              onTap: (value) {
                if (value == 2) {
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
                    (AppIcon.search, '검색'),
                    (AppIcon.heart, '관심상품'),
                    (AppIcon.person, '마이페이지'),
                  ].indexed.map((e) {
                    if (e.$1 == 2) {
                      return BottomNavigationBarItem(
                        icon: CircleAvatar(
                          backgroundColor: yellow,
                          radius: 24,
                          child: AppIcon.add.icon(color: Colors.black),
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
          );
        },
      ),
    );
  }
}
