import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_5/app_ctrl.dart';
import 'package:vinyl_groove_poc_5/main.dart';
import 'package:vinyl_groove_poc_5/screens/base_screen.dart';
import 'package:vinyl_groove_poc_5/screens/signup_screen.dart';

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
                alignment: .center,
                child: ColoredBox(
                  color: Colors.black54,
                  child: BackdropFilter(
                    filter: .blur(sigmaX: 3, sigmaY: 3),
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 4,
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
              Padding(
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
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: .w500,
                          ),
                        ),
                      ],
                    ),

                    TextField(
                      controller: em,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        filled: true,
                        errorText: emE,
                        fillColor: black1,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.email.icon(color: Colors.white60),
                        ),
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '이메일을 입력해주세요.',
                      ),
                    ),

                    TextField(
                      controller: pw,
                      obscuringCharacter: '*',
                      obscureText: hide,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        errorText: pwE,
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
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.lock.icon(color: Colors.white60),
                        ),
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '비밀번호를 입력해주세요.',
                      ),
                    ),

                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        TextButton(
                          onPressed: () {
                            message('비밀번호 찾기 기능은 준비중입니다.');
                          },
                          child: Text(
                            '비밀번호를 잊으셨나요?',
                            style: TextStyle(
                              color: Colors.white60,
                              fontWeight: .w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: Colors.black,
                        padding: .symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (!RegExp(r'.*@.*\..*').hasMatch(em.text)) {
                          setState(() {
                            emE = '올바른 이메일 형식을 입력해주세요.';
                          });

                          return;
                        }
                        setState(() {
                          emE = null;
                        });

                        if (pw.text.length < 6) {
                          setState(() {
                            pwE = '비밀번호는 6자 이상이어야 합니다.';
                          });
                        }

                        if (!RegExp(
                          r'(?=.*[A-Z])(?=.*[a-z])',
                        ).hasMatch(pw.text)) {
                          setState(() {
                            pwE = '비밀번호는 필수 값으로 대문자 1자 이상 소문자 1자 이상 입력해야 합니다.';
                          });
                          return;
                        }

                        setState(() {
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

                          message((body['errors'] as List).first['message']);
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

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        spacing: 12,
                        children: [
                          Expanded(child: Divider(color: Colors.white60)),
                          Text('또는', style: TextStyle(color: Colors.white60)),
                          Expanded(child: Divider(color: Colors.white60)),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          '계정이 없으신가요?',
                          style: TextStyle(color: Colors.white60),
                        ),

                        TextButton(
                          onPressed: () {
                            context.go(SignupScreen());
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(color: yellow, fontWeight: .w500),
                          ),
                        ),
                      ],
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
