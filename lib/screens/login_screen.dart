import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/screens/base_screen.dart';
import 'package:vinyl_groove_poc_2/screens/signup_screen.dart';

import '../main.dart';

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
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            Container(
              height: 300,
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
                  filter: .blur(sigmaY: 3, sigmaX: 3),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Image.asset('assets/logo_horizontal.png', width: 220),

                      SizedBox(height: 24),

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
                    spacing: 24,
                    children: [
                      Column(
                        spacing: 8,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            '계정으로 로그인하여 다양한 서비스를 이용하세요.',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),

                      TextField(
                        controller: em,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorText: emE,
                          errorMaxLines: 2,
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AppIcon.email.icon(color: Colors.white60),
                          ),
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '이메일을 입력해주세요.',
                          filled: true,
                          fillColor: black1,
                        ),
                      ),
                      TextField(
                        obscureText: hide,
                        obscuringCharacter: '*',
                        controller: pw,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorText: pwE,
                          errorMaxLines: 2,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hide = !hide;
                              });
                            },
                            icon: hide
                                ? AppIcon.visibilityoff.icon(
                                    color: Colors.white60,
                                  )
                                : AppIcon.visibility.icon(
                                    color: Colors.white60,
                                  ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AppIcon.lock.icon(color: Colors.white60),
                          ),
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '비밀번호를 입력해주세요.',
                          filled: true,
                          fillColor: black1,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: .zero,
                              minimumSize: .zero,
                              foregroundColor: Colors.white60,
                            ),
                            onPressed: () {
                              message('비밀번호 찾기는 준비 중입니다.');
                            },
                            child: Text('비밀번호를 잊으셨나요?'),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                          padding: .symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (!RegExp(r'.*@.*\..*').hasMatch(em.text)) {
                            emE =
                                '이메일은 필수 값으로 “@“ 포함 ”.“포함 ”@“ 앞에 ”.“사용 불가의 형식을 따릅니다.';
                            setState(() {});
                            return;
                          }

                          emE = null;
                          setState(() {});
                          if (pw.text.length < 6) {
                            pwE = '비밀번호는 6자 이상이어야 합니다.';
                            setState(() {});
                            return;
                          }

                          if (!RegExp(
                            r'(?=.*[A-Z])(?=.*[a-z])',
                          ).hasMatch(pw.text)) {
                            pwE = '비밀번호는 - 대문자 1자 이상 소문자 1자 이상의 형식을 따릅니다.';
                            setState(() {});
                            return;
                          }

                          pwE = null;
                          setState(() {});

                          post(
                            Uri.parse('http://${baseUrl}/auth/login'),
                            headers: baseHeader,
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

                              return;
                            }
                            message(
                              (body['errors'] as List).firstOrNull?['message'],
                            );
                          });
                        },
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              '로그인',
                              style: TextStyle(fontWeight: .bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1.5,
                              color: Colors.white60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Text(
                              '또는',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1.5,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        spacing: 12,
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            '계정이 없으신가요?',
                            style: TextStyle(color: Colors.white60),
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              padding: .zero,
                              minimumSize: .zero,
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
