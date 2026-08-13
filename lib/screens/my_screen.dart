import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_5/app_ctrl.dart';
import 'package:vinyl_groove_poc_5/screens/login_screen.dart';
import 'package:vinyl_groove_poc_5/screens/my_regi_screen.dart';
import 'package:vinyl_groove_poc_5/screens/regi_screen.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 32,
            children: [
              Material(
                color: black2,
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      CircleAvatar(
                        backgroundColor: yellow.withAlpha(100),
                        radius: 28,
                        child: AppIcon.person.icon(color: yellow, size: 32),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              appCtrl.user?['name'] ?? '',
                              overflow: .ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: .bold,
                                fontSize: 18,
                              ),
                            ),

                            Text(
                              appCtrl.user?['email'] ?? '',
                              overflow: .ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                fontWeight: .w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Column(
                spacing: 4,
                children: [
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        context.go(RegiScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.add.icon(color: Colors.white, size: 24),

                            Expanded(
                              child: Text(
                                '상품 등록',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white60,
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
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.inventory.icon(
                              color: Colors.white,
                              size: 24,
                            ),

                            Expanded(
                              child: Text(
                                '내 등록 상품',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white60,
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
                spacing: 4,
                children: [
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        message('판매 내역은 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.shopping.icon(
                              color: Colors.white,
                              size: 24,
                            ),

                            Expanded(
                              child: Text(
                                '판매 내역',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white60,
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
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.history.icon(color: Colors.white, size: 24),

                            Expanded(
                              child: Text(
                                '구매 내역',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white60,
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
                spacing: 4,
                children: [
                  Material(
                    type: .transparency,
                    child: InkWell(
                      onTap: () {
                        message('고객센터는 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.help.icon(color: Colors.white, size: 24),

                            Expanded(
                              child: Text(
                                '고객센터',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white60,
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
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.info.icon(color: Colors.white, size: 24),

                            Expanded(
                              child: Text(
                                '앱 정보',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: .symmetric(vertical: 14),
                  side: BorderSide(color: Colors.red, width: 2),
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
                          onPressed: () {
                            appCtrl.user = null;
                            appCtrl.tkn = null;
                            context.go(LoginScreen());
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
