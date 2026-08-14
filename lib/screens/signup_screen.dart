import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_3/main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final em = TextEditingController();
  final pw = TextEditingController();
  final pw2 = TextEditingController();
  final na = TextEditingController();
  final ph1 = TextEditingController();
  final ph2 = TextEditingController();
  final ph3 = TextEditingController();

  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();

  bool hide = true;
  bool hide2 = true;
  bool check = false;

  @override
  void initState() {
    ph1.addListener(() {
      if (ph1.text.length == 3) {
        f1.nextFocus();
      }
    });
    ph2.addListener(() {
      if (ph2.text.length == 4) {
        f2.nextFocus();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
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
                  filter: .blur(sigmaX: 2, sigmaY: 2),
                  child: SizedBox(),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: .start,
              children: [
                IconButton(
                  onPressed: () {
                    context.back();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 24,
                        children: [
                          Row(
                            mainAxisAlignment: .center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(38.0),
                                child: Column(
                                  mainAxisAlignment: .center,
                                  spacing: 12,
                                  children: [
                                    Image.asset(
                                      'assets/logo_horizontal.png',
                                      width: 150,
                                    ),

                                    Text(
                                      'Vinyl Record Secondhand Marketplace',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: .start,
                            spacing: 8,
                            children: [
                              Text(
                                '회원가입',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: .bold,
                                ),
                              ),
                              Text(
                                '회원 정보를 입력하여 계정을 만들어주세요.',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: .start,
                            spacing: 8,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '이메일',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: em,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  filled: true,
                                  fillColor: black1,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: AppIcon.email.icon(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: '이메일을 입력해주세요.',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            spacing: 8,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '비밀번호',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: pw,
                                obscureText: hide,
                                obscuringCharacter: '*',
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
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
                                    child: AppIcon.lock.icon(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: '비밀번호를 입력해주세요.',
                                ),
                              ),

                              Text(
                                '* 8자 이상, 대소문자, 숫자, 특수문자 포함',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: .start,
                            spacing: 8,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '비밀번호 확인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: pw2,
                                obscureText: hide2,
                                obscuringCharacter: '*',
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hide2 = !hide2;
                                      });
                                    },
                                    icon:
                                        (hide2
                                                ? AppIcon.visibilityoff
                                                : AppIcon.visibility)
                                            .icon(color: Colors.white60),
                                  ),
                                  filled: true,
                                  fillColor: black1,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: AppIcon.lock.icon(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: '비밀번호를 다시 입력해주세요.',
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: .start,
                            spacing: 8,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '이름',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: na,
                                style: TextStyle(color: Colors.white),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[가-힣A-Za-z]'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  filled: true,
                                  fillColor: black1,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: AppIcon.person.icon(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: '이름을 입력해주세요.',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            spacing: 8,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '휴대폰 번호',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      textAlign: .center,
                                      controller: ph1,
                                      focusNode: f1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),
                                        filled: true,
                                        fillColor: black1,
                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                        ),
                                        hintText: '010',
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 24,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Divider(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      textAlign: .center,
                                      controller: ph2,
                                      focusNode: f2,

                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),
                                        filled: true,
                                        fillColor: black1,
                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                        ),
                                        hintText: '1234',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Divider(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      textAlign: .center,
                                      controller: ph3,
                                      focusNode: f3,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),
                                        filled: true,
                                        fillColor: black1,
                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                        ),
                                        hintText: '5678',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: check,
                                onChanged: (value) {
                                  setState(() {
                                    check = !check;
                                  });
                                },
                                side: BorderSide(color: Colors.white, width: 2),
                              ),

                              Text(
                                '이용약관 및 개인정보처리방침에 동의합니다.',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ],
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: yellow,
                              padding: .symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (pw.text.length < 8) {
                                message('비밀번호는 8자 이상이어야 합니다.');
                                return;
                              }
                              if (pw.text != pw2.text) {
                                message('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
                                return;
                              }

                              if (!check) {
                                message('이용약관에 동의해 주세요.');
                                return;
                              }

                              post(
                                Uri.parse('http://${baseUrl}/auth/signup'),
                                headers: baseHeader,
                                body: jsonEncode({
                                  "email": em.text,
                                  "password": pw.text,
                                  "name": na.text,
                                  "phone":
                                      "${ph1.text}-${ph2.text}-${ph3.text}",
                                }),
                              ).then((value) {
                                final body = jsonDecode(value.body);

                                if (value.statusCode == 200) {
                                  message('회원가입이 완료되었습니다.');
                                  context.back();

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
                                  '회원가입',
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            spacing: 12,
                            mainAxisAlignment: .center,
                            children: [
                              Text(
                                '이미 계정이 있으신가요?',
                                style: TextStyle(color: Colors.white60),
                              ),

                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: .zero,
                                  padding: .zero,
                                  tapTargetSize: .shrinkWrap,
                                  foregroundColor: yellow,
                                ),
                                onPressed: () {
                                  context.back();
                                },
                                child: Text(
                                  '로그인',
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
          ],
        ),
      ),
    );
  }
}
