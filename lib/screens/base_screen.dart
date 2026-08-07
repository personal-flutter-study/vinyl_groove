import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/main.dart';
import 'package:vinyl_groove_poc_1/screens/home_screen.dart';
import 'package:vinyl_groove_poc_1/screens/like_screen.dart';
import 'package:vinyl_groove_poc_1/screens/my_screen.dart';
import 'package:vinyl_groove_poc_1/screens/search_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: appCtrl.page,
        builder: (context, value, child) {
          final pages = [
            HomeScreen(),
            SearchScreen(),
            LikeScreen(),
            MyScreen(),
          ];
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: .lerp(Colors.black, Colors.white, .1),
              selectedItemColor: yellow,
              unselectedItemColor: Colors.white60,
              iconSize: 32,
              onTap: (value) {
                appCtrl.page.value = value;
              },
              type: .fixed,
              currentIndex: value,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: '홈',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  label: '관심상품',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: '마이페이지',
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: pages[value],
          );
        },
      ),
    );
  }
}
