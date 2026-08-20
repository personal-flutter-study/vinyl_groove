import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_13/app_ctrl.dart';
import 'package:vinyl_groove_poc_13/screeens/login_screen.dart';
import 'package:vinyl_groove_poc_13/screeens/regi_screen.dart';

import '../main.dart';
import 'my_regi_screen.dart';

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
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            '마이페이지',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 16,
            children: [
              Material(
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                color: black2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: yellow.withAlpha(60),
                        child: AppIcon.person.icon(color: yellow, size: 28),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 4,
                          children: [
                            Text(
                              appCtrl.user?['name'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: .bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              appCtrl.user?['email'] ?? '',
                              style: TextStyle(
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
                children: [
                  Material(
                    color: black,
                    child: InkWell(
                      onTap: () {
                        context.go(RegiScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 16,
                          children: [
                            AppIcon.add.icon(color: Colors.white60, size: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '상품 등록',
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                      fontSize: 16,
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
                    color: black,
                    child: InkWell(
                      onTap: () {
                        context.go(MyRegiScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 16,
                          children: [
                            AppIcon.inventory.icon(
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '내 등록 상품',
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                      fontSize: 16,
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

              Divider(color: black2, height: 1),

              Column(
                children: [
                  Material(
                    color: black,
                    child: InkWell(
                      onTap: () {
                        message('판매 내역', g: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 16,
                          children: [
                            AppIcon.shopping.icon(
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '판매 내역',
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                      fontSize: 16,
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
                    color: black,
                    child: InkWell(
                      onTap: () {
                        message('구매 내역', g: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 16,
                          children: [
                            AppIcon.history.icon(
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '구매 내역',
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                      fontSize: 16,
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

              Divider(color: black2, height: 1),
              Column(
                children: [
                  Material(
                    color: black,
                    child: InkWell(
                      onTap: () {
                        message('고객센터', g: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 16,
                          children: [
                            AppIcon.help.icon(color: Colors.white60, size: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '고객센터',
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                      fontSize: 16,
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
                    color: black,
                    child: InkWell(
                      onTap: () {
                        message('앱 정보', g: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 16,
                          children: [
                            AppIcon.info.icon(color: Colors.white60, size: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  Text(
                                    '앱 정보',
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                      fontSize: 16,
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
                  backgroundColor: black,
                  foregroundColor: Colors.red,
                  padding: .symmetric(vertical: 14),
                  side: BorderSide(color: Colors.red),
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
