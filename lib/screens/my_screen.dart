import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/screens/my_register_screen.dart';
import 'package:vinyl_groove_poc_1/screens/register_screen.dart';

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
            style: TextStyle(fontWeight: .bold, color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 18,
            children: [
              ListTile(
                tileColor: blackAccent,
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                contentPadding: .all(12),
                leading: CircleAvatar(
                  radius: 32,
                  backgroundColor: yellow.withAlpha(100),
                  child: AppIcon.person.icon(color: yellow, width: 32),
                ),
                title: Text(
                  appCtrl.user?['name'] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: .bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  appCtrl.user?['email'] ?? '',
                  style: TextStyle(color: Colors.white60, fontWeight: .bold),
                ),
              ),

              Column(
                spacing: 4,
                children: [
                  ListTile(
                    onTap: () {
                      context.go(RegisterScreen());
                    },
                    contentPadding: .zero,
                    leading: Icon(Icons.add, color: Colors.white60, size: 32),
                    title: Text(
                      '상품 등록',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.go(MyRegisterScreen());
                    },
                    contentPadding: .zero,
                    leading: Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white60,
                      size: 32,
                    ),
                    title: Text(
                      '내 상품 등록',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),
                ],
              ),

              Divider(thickness: .3, color: Colors.white60),

              Column(
                spacing: 4,
                children: [
                  ListTile(
                    onTap: () {
                      context.message('판매 내역은 준비중 입니다.');
                    },
                    contentPadding: .zero,
                    leading: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white60,
                      size: 32,
                    ),
                    title: Text(
                      '판매 내역',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.message('구배 내역은 준비중 입니다.');
                    },
                    contentPadding: .zero,
                    leading: Icon(
                      Icons.history,
                      color: Colors.white60,
                      size: 32,
                    ),
                    title: Text(
                      '구매 내역',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),
                ],
              ),
              Divider(thickness: .3, color: Colors.white60),

              Column(
                spacing: 4,
                children: [
                  ListTile(
                    onTap: () {
                      context.message('고객 센터는 준비중 입니다.');
                    },
                    contentPadding: .zero,
                    leading: Icon(
                      Icons.help_outline,
                      color: Colors.white60,
                      size: 32,
                    ),
                    title: Text(
                      '고객 센터',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),

                  ListTile(
                    onTap: () {
                      context.message('앱 정보는 준비중 입니다.');
                    },
                    contentPadding: .zero,
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.white60,
                      size: 32,
                    ),
                    title: Text(
                      '앱 정보',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                  padding: .symmetric(vertical: 16),
                ),
                onPressed: () async {
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
                            appCtrl.tkn = '';
                            context.back();
                            context.back();
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
                      style: TextStyle(fontSize: 16, fontWeight: .bold),
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
