import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_6/main.dart';

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
    final ma = FocusManager().primaryFocus;

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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                ),
              ),
              height: 300,
              width: .infinity,
              child: Container(
                color: Colors.black54,
                child: BackdropFilter(
                  filter: .blur(sigmaY: 3, sigmaX: 3),
                  child: SizedBox(),
                ),
              ),
            ),

            Column(
              spacing: 12,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(42.0),
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: .center,
                            children: [
                              Image.asset(
                                'assets/logo_horizontal.png',
                                width: 160,
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
                                    '회원가입',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                  Text(
                                    '회원 정보를 입력하여 계정을 만들어주세요.',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '이메일',
                                        style: TextStyle(
                                          color: Colors.white,

                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: em,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: black1,
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: AppIcon.email.icon(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      hintText: '이메일을 입력해주세요.',
                                      border: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(color: yellow),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '비밀번호',
                                        style: TextStyle(
                                          color: Colors.white,

                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: pw,
                                    obscureText: hide,
                                    obscuringCharacter: '*',
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: black1,
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: AppIcon.lock.icon(
                                          color: Colors.white60,
                                        ),
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
                                      hintText: '비밀번호를 입력해주세요.',
                                      border: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(color: yellow),
                                      ),
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
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '비밀번호 확인',
                                        style: TextStyle(
                                          color: Colors.white,

                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: pw2,
                                    obscureText: hide2,
                                    obscuringCharacter: '*',
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: black1,
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: AppIcon.lock.icon(
                                          color: Colors.white60,
                                        ),
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
                                      hintText: '비밀번호를 다시 입력해주세요.',
                                      border: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(color: yellow),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '이름',
                                        style: TextStyle(
                                          color: Colors.white,

                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: na,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Za-z가-힣]'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: black1,
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: AppIcon.person.icon(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      hintText: '이름을 입력해주세요.',
                                      border: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: .circular(12),
                                        borderSide: BorderSide(color: yellow),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '휴대폰 번호',
                                        style: TextStyle(
                                          color: Colors.white,

                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: .center,
                                          maxLength: 3,
                                          style: TextStyle(color: Colors.white),
                                          controller: ph1,
                                          focusNode: f1,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            counterText: '',
                                            filled: true,
                                            fillColor: black1,
                                            hintStyle: TextStyle(
                                              color: Colors.white60,
                                            ),
                                            hintText: '010',
                                            border: OutlineInputBorder(
                                              borderRadius: .circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: .circular(12),
                                              borderSide: BorderSide(
                                                color: yellow,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 28,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Divider(color: Colors.white60),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: .center,
                                          maxLength: 4,
                                          style: TextStyle(color: Colors.white),
                                          controller: ph2,
                                          focusNode: f2,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            counterText: '',
                                            filled: true,
                                            fillColor: black1,
                                            hintStyle: TextStyle(
                                              color: Colors.white60,
                                            ),
                                            hintText: '1234',
                                            border: OutlineInputBorder(
                                              borderRadius: .circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: .circular(12),
                                              borderSide: BorderSide(
                                                color: yellow,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 28,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Divider(color: Colors.white60),
                                        ),
                                      ),

                                      Expanded(
                                        child: TextField(
                                          textAlign: .center,
                                          maxLength: 4,
                                          style: TextStyle(color: Colors.white),
                                          controller: ph3,
                                          focusNode: f3,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            counterText: '',
                                            filled: true,
                                            fillColor: black1,
                                            hintStyle: TextStyle(
                                              color: Colors.white60,
                                            ),
                                            hintText: '5678',
                                            border: OutlineInputBorder(
                                              borderRadius: .circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: .circular(12),
                                              borderSide: BorderSide(
                                                color: yellow,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      activeColor: yellow,
                                      value: check,
                                      onChanged: (value) {
                                        setState(() {
                                          check = !check;
                                        });
                                      },
                                    ),
                                    Text(
                                      '이용약관 및 개인정보처리방침에 동의합니다.',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: .w500,
                                      ),
                                    ),
                                  ],
                                ),
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

                                    if (body['success'] ?? false) {
                                      message('회원가입이 완료되었습니다.');

                                      context.back();
                                      return;
                                    }
                                    message(
                                      (body['errors'] as List?)
                                          ?.first['message'],
                                    );
                                  }, onError: (e) => message("서버 통신 에러"));
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
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    '이미 계정이 있으신가요?',
                                    style: TextStyle(color: Colors.white60),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      context.back();
                                    },
                                    child: Text(
                                      '로그인',
                                      style: TextStyle(
                                        color: yellow,
                                        fontWeight: .w500,
                                      ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
