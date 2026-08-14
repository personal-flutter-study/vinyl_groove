import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_6/app_ctrl.dart';
import 'package:vinyl_groove_poc_6/main.dart';
import 'package:vinyl_groove_poc_6/screens/login_screen.dart';
import 'package:vinyl_groove_poc_6/screens/my_regi_screen.dart';
import 'package:vinyl_groove_poc_6/screens/regi_screen.dart';

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
            spacing: 24,
            children: [
              Material(
                color: black2,
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: yellow.withAlpha(100),
                        child: AppIcon.person.icon(color: yellow, size: 28),
                      ),

                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: .start,
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
                                fontSize: 14,
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
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                    child: InkWell(
                      onTap: () {
                        context.go(RegiScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.add.icon(color: Colors.white60, size: 24),
                            Expanded(
                              child: Text(
                                '상품 등록',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: .w500,
                                ),
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
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
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
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                '내 등록 상품',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: .w500,
                                ),
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
                    color: black,
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
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
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                '판매 내역',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: .w500,
                                ),
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
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                    child: InkWell(
                      onTap: () {
                        message('구매 내역은 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.history.icon(
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                '구매 내역',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: .w500,
                                ),
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
                    color: black,
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                    child: InkWell(
                      onTap: () {
                        message('고객센터는 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.shopping.icon(
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                '고객센터',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: .w500,
                                ),
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
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                    child: InkWell(
                      onTap: () {
                        message('앱 정보는 준비중입니다.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            AppIcon.history.icon(
                              color: Colors.white60,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                '앱 정보',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: .w500,
                                ),
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
                          child: Text('삭제'),
                          onPressed: () {
                            appCtrl.tkn = null;
                            appCtrl.user = null;
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
                      style: TextStyle(fontWeight: .bold, fontSize: 14),
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
