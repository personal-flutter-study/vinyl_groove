import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/main.dart';
import 'package:vinyl_groove_poc_3/screens/base_screen.dart';
import 'package:vinyl_groove_poc_3/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final em = TextEditingController(text: 'test@example.com');
  final pw = TextEditingController(text: 'Test1234!');

  bool hide = true;

  String? emE;
  String? pwE;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              height: 280,
              width: .infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: .cover,
                ),
              ),
              child: ColoredBox(
                color: Colors.black54,
                child: BackdropFilter(
                  filter: .blur(sigmaX: 2, sigmaY: 2),
                  child: Column(
                    mainAxisAlignment: .center,
                    spacing: 12,
                    children: [
                      Image.asset('assets/logo_horizontal.png', width: 200),

                      Text(
                        'Vinyl Record Secondhand Marketplace',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: .bold,
                            ),
                          ),
                          Text(
                            '계정으로 로그인하여 다양한 서비스를 이용하세요.',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),

                      SizedBox(),
                      TextField(
                        controller: em,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorText: emE,
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          filled: true,
                          fillColor: black1,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: AppIcon.email.icon(color: Colors.white60),
                          ),
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '이메일을 입력해주세요.',
                        ),
                      ),

                      TextField(
                        controller: pw,
                        obscureText: hide,
                        obscuringCharacter: '*',
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorText: pwE,
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hide = !hide;
                              });
                            },
                            icon:
                                (hide
                                        ? AppIcon.visibilityoff
                                        : AppIcon.visibility)
                                    .icon(color: Colors.white60),
                          ),
                          filled: true,
                          fillColor: black1,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AppIcon.lock.icon(color: Colors.white60),
                          ),
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '비밀번호를 입력해주세요.',
                        ),
                      ),

                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white60,
                            ),
                            onPressed: () {
                              message('비밀번호 찾기는 준비 중입니다.');
                            },
                            child: Text('비밀번호를 잊으셨나요?', style: TextStyle()),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: yellow,
                            padding: .symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!RegExp(r'.*@.*\..*').hasMatch(em.text)) {
                                emE = '올바른 이메일 형식을 입력해주세요.';
                                return;
                              }

                              emE = null;

                              if (pw.text.length < 6) {
                                pwE = '비밀번호는 6자 이상이어야 합니다.';
                                return;
                              }

                              if (!RegExp(
                                r'(?=.*[A-Z])(?=.*[a-z])',
                              ).hasMatch(pw.text)) {
                                pwE = '올바른 비밀번호 형식을 입력해주세요.';
                                return;
                              }

                              pwE = null;
                            });

                            post(
                              Uri.parse('http://${baseUrl}/auth/login'),
                              headers: baseHeader,
                              body: jsonEncode({
                                "email": em.text,
                                "password": pw.text,
                              }),
                            ).then((value) {
                              final body = jsonDecode(value.body);

                              if (value.statusCode == 200) {
                                appCtrl.tkn = body['data']['token'];
                                appCtrl.user = body['data']['user'];
                                context.go(BaseScreen());

                                return;
                              }
                              message(
                                (body['errors'] as List).first['message'],
                              );
                            });
                          },
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              Text(
                                '로그인',
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white60,
                              thickness: 1.8,
                            ),
                          ),
                          Text('또는', style: TextStyle(color: Colors.white60)),
                          Expanded(
                            child: Divider(
                              color: Colors.white60,
                              thickness: 1.8,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            '계정이 없으신가요?',
                            style: TextStyle(color: Colors.white60),
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: yellow,
                            ),
                            onPressed: () {
                              context.go(SignupScreen());
                            },
                            child: Text(
                              '회원가입',
                              style: TextStyle(fontWeight: .bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
