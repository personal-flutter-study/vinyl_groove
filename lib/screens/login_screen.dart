import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/main.dart';
import 'package:vinyl_groove_poc_1/screens/base_screen.dart';
import 'package:vinyl_groove_poc_1/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final em = TextEditingController(text: 'seller@example.com');
  final pw = TextEditingController(text: 'Seller1234!@');

  String? emE;
  String? pwE;

  bool hide = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: .cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withAlpha(100),
                  alignment: .center,
                  child: BackdropFilter(
                    filterConfig: .blur(sigmaX: 3, sigmaY: 3),
                    child: Column(
                      mainAxisSize: .min,
                      spacing: 24,
                      children: [
                        Image.asset('assets/logo_horizontal.png', width: 200),
                        Text(
                          'Vinyl Record Secondhand Marketplace',
                          style: TextStyle(
                            fontWeight: .bold,
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white60),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 24,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        spacing: 4,
                        children: [
                          Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: .bold,
                            ),
                          ),
                          Text(
                            '계정으로 로그인하여 다양한 서비스를 이용하세요.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                      Column(
                        spacing: 16,
                        children: [
                          TextField(
                            controller: em,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorText: emE,
                              fillColor: .lerp(Colors.black, Colors.white, .05),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: .circular(12),
                              ),
                              errorMaxLines: 2,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white60,
                              ),
                              hintStyle: TextStyle(color: Colors.white60),
                              hintText: '이메일을 입력해주세요.',
                            ),
                          ),

                          TextField(
                            obscureText: hide,
                            obscuringCharacter: '*',
                            controller: pw,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorMaxLines: 2,
                              errorText: pwE,
                              fillColor: .lerp(Colors.black, Colors.white, .05),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: .circular(12),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hide = !hide;
                                  });
                                },
                                icon: Icon(
                                  color: Colors.white60,
                                  hide
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white60,
                              ),
                              hintStyle: TextStyle(color: Colors.white60),
                              hintText: '비밀번호를 입력해주세요.',
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.message('비밀번호 확인은 준비중 입니다.');
                            },
                            child: Text(
                              '비밀번호를 잊으셨나요?',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                          padding: .symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          if (!RegExp(r'.*@.*..*').hasMatch(em.text)) {
                            emE =
                                '올바른 이메일 형식은 “@“ 포함 ”.“포함 ”@“ 앞에 ”.“사용 불가의 조건을 따릅니다.';
                            setState(() {});
                            return;
                          } else {
                            emE = null;
                            setState(() {});
                          }

                          if (pw.text.length < 6) {
                            pwE = '비밀번호 길이는 6자 이상으로 입력해 주세요';
                            setState(() {});
                            return;
                          } else {
                            pwE = null;
                            setState(() {});
                          }
                          if (!RegExp(
                            r'(?=.*[A-Z])(?=.*[a-z])',
                          ).hasMatch(pw.text)) {
                            pwE = '비밀번호는 대문자 1자 이상 소문자 1자 이상으로 입력해 주세요';
                            setState(() {});
                            return;
                          } else {
                            pwE = null;
                            setState(() {});
                          }

                          await post(
                            Uri.parse('http://${baseUrl}/auth/login'),
                            headers: jsonHeader,
                            body: jsonEncode({
                              "email": em.text,
                              "password": pw.text,
                            }),
                          ).then((value) {
                            final body = jsonDecode(value.body);

                            print(body);
                            if (value.statusCode == 200) {
                              appCtrl.tkn = body['data']['token'];
                              appCtrl.user = body['data']['user'];
                              context.go(BaseScreen());
                            }

                            if (body['errors'] != null) {
                              for (var o in body['errors'] as List) {
                                context.message(o['message']);
                              }
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              '로그인',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: .bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white60)),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              '또는',
                              style: TextStyle(
                                fontWeight: .bold,
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                            ),
                          ),

                          Expanded(child: Divider(color: Colors.white60)),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: .center,
                        spacing: 8,
                        children: [
                          Text(
                            '계정이 없으신가요?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              context.go(SignupScreen());
                            },
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                fontWeight: .bold,
                                fontSize: 14,
                                color: yellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
