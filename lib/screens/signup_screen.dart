import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../main.dart';

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

  bool hide = false;
  bool hide2 = false;

  bool check = false;

  @override
  void initState() {
    ph1.addListener(() {
      if (ph1.text.length >= 3) {
        f2.requestFocus();
      }
    });
    ph2.addListener(() {
      if (ph2.text.length >= 4) {
        f3.nextFocus();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 24,
                        children: [
                          Container(
                            height: 250,
                            alignment: .center,
                            child: Column(
                              mainAxisSize: .min,
                              spacing: 24,
                              children: [
                                Image.asset(
                                  'assets/logo_horizontal.png',
                                  width: 200,
                                ),
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
                          Column(
                            spacing: 8,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                '회원가입',
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '회원 정보를 입력하여 계정을 만들어주세요.',
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 14,
                                  color: Colors.white60,
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
                                    '이메일',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: em,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: .lerp(
                                    Colors.black,
                                    Colors.white,
                                    .05,
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white60,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),

                              TextField(
                                obscuringCharacter: '*',
                                obscureText: hide,
                                controller: pw,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: .lerp(
                                    Colors.black,
                                    Colors.white,
                                    .05,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hide = !hide;
                                      });
                                    },
                                    icon: Icon(
                                      hide
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white60,
                                  ),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: '비밀번호를 입력해주세요.',
                                ),
                              ),

                              Text(
                                '8자 이상, 대소문자, 숫자, 특수문자 포함',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),

                              TextField(
                                obscureText: hide2,
                                obscuringCharacter: '*',
                                controller: pw2,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: .lerp(
                                    Colors.black,
                                    Colors.white,
                                    .05,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hide2 = !hide2;
                                      });
                                    },
                                    icon: Icon(
                                      hide2
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white60,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),

                              TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[가-힣A-Za-z]'),
                                  ),
                                ],
                                controller: na,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: .lerp(
                                    Colors.black,
                                    Colors.white,
                                    .05,
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white60,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textAlign: .center,
                                      controller: ph1,
                                      focusNode: f1,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        fillColor: .lerp(
                                          Colors.black,
                                          Colors.white,
                                          .05,
                                        ),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                        ),
                                        hintText: '010',
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Divider(color: Colors.white60),
                                    ),
                                  ),

                                  Expanded(
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],

                                      textAlign: .center,
                                      controller: ph2,
                                      focusNode: f2,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        fillColor: .lerp(
                                          Colors.black,
                                          Colors.white,
                                          .05,
                                        ),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),

                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                        ),
                                        hintText: '1234',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Divider(color: Colors.white60),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],

                                      focusNode: f3,
                                      textAlign: .center,
                                      controller: ph3,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        fillColor: .lerp(
                                          Colors.black,
                                          Colors.white,
                                          .05,
                                        ),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),

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
                                activeColor: yellow,
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
                              backgroundColor: yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(12),
                              ),
                              padding: .symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              if (!RegExp(r"[^.]*@.*\..*").hasMatch(em.text)) {
                                context.message(
                                  '이메일 형식은 "@" 기호 포함, "." 기호 포함, "@" 앞에 "." 사용 불가 형식을 따름니다.',
                                );
                                return;
                              }
                              if (pw.text.length < 8) {
                                context.message('비밀번호는 최소 8자 이상 입력해 주세요.');
                                return;
                              }

                              if (!RegExp(
                                r'(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])',
                              ).hasMatch(pw.text)) {
                                context.message(
                                  '비밀번호는 대/소문자, 숫자, 특수문자 각 1자 이상 포함해야 합니다.',
                                );
                                return;
                              }

                              if (pw.text != pw2.text) {
                                context.message('비밀번호 확인은 비밀번호와 일치해야 합니다.');
                                return;
                              }

                              if (!check) {
                                context.message('이용약관에 동의해 주세요.');
                                return;
                              }

                              post(
                                Uri.parse('http://${baseUrl}/auth/signup'),
                                headers: jsonHeader,
                                body: jsonEncode({
                                  "email": em.text,
                                  "password": pw.text,
                                  "name": na.text,
                                  "phone":
                                      "${ph1.text}-${ph2.text}-${ph3.text}",
                                }),
                              ).then((value) {
                                final body = jsonDecode(value.body);

                                print(body);

                                if (value.statusCode == 200) {
                                  context.back();
                                }

                                for (var o in body['errors']) {
                                  context.message(o['message']);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  '회원가입',
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
                            mainAxisAlignment: .center,
                            spacing: 8,
                            children: [
                              Text(
                                '이미 계정이 있으신가요?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white60,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  context.back();
                                },
                                child: Text(
                                  '로그인',
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: 14,
                                    color: yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24),
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
