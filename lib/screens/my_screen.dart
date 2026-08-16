import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/screens/login_screen.dart';
import 'package:vinyl_groove_poc_2/screens/my_regi_screen.dart';
import 'package:vinyl_groove_poc_2/screens/regi_screen.dart';

import '../main.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            '마이페이지',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        backgroundColor: black,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 16,
            children: [
              ListTile(
                contentPadding: .all(12),
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                tileColor: black2,
                leading: CircleAvatar(
                  radius: 32,
                  backgroundColor: yellow.withAlpha(100),
                  child: AppIcon.person.icon(color: yellow, size: 28),
                ),

                title: Text(
                  appCtrl.user?['name'] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: .bold,
                    fontSize: 18,
                  ),
                ),

                subtitle: Text(
                  appCtrl.user?['email'] ?? '',
                  style: TextStyle(color: Colors.white60),
                ),
              ),

              Column(
                children: [
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        context.go(RegiScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 18,
                          children: [
                            AppIcon.add.icon(size: 24, color: Colors.white60),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '상품 등록',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        context.go(MyRegiScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 18,
                          children: [
                            AppIcon.inventory.icon(
                              size: 24,
                              color: Colors.white60,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '내 등록 상품',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        message('판매 내역은 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 18,
                          children: [
                            AppIcon.shopping.icon(
                              size: 24,
                              color: Colors.white60,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '판매 내역',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        message('구매 내역은 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 18,
                          children: [
                            AppIcon.history.icon(
                              size: 24,
                              color: Colors.white60,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '구매 내역',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        message('고객센터는 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 18,
                          children: [
                            AppIcon.help.icon(size: 24, color: Colors.white60),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '고객센터',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        message('앱 정보는 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 18,
                          children: [
                            AppIcon.info.icon(size: 24, color: Colors.white60),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '앱 정보',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: black,
                  side: BorderSide(color: Colors.red),
                  padding: .symmetric(vertical: 16),
                ),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text('정말 로그아웃 하시겠습니까?'),
                      actions: [
                        CupertinoButton(
                          child: Text('취소'),
                          onPressed: () {
                            context.back();
                          },
                        ),
                        CupertinoButton(
                          child: Text('로그아웃'),
                          onPressed: () async {
                            appCtrl.user = null;
                            appCtrl.tkn = null;
                            context.re(LoginScreen());
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      '로그아웃',
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
