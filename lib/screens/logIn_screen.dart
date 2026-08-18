import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_10/app_ctrl.dart';
import 'package:vinyl_groove_poc_10/main.dart';
import 'package:vinyl_groove_poc_10/screens/base_screen.dart';
import 'package:vinyl_groove_poc_10/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final em = TextEditingController();
  final pw = TextEditingController();

  bool hide = false;

  String? emE;
  String? pwE;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
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
                  color: Colors.black54,
                  alignment: Alignment(0, .4),
                  child: BackdropFilter(
                    filter: .blur(sigmaY: 3, sigmaX: 3),
                    child: Column(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        Image.asset(
                          'assets/logo_horizontal.png',
                          width: 200,
                          fit: .cover,
                        ),

                        Text(
                          'Vinyl Record Secondhand Marketplace',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            fontWeight: .w500,
                          ),
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

                    SizedBox(),

                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: em,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        errorText: emE,
                        filled: true,
                        fillColor: black1,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.email.icon(color: Colors.white60),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '이메일을 입력해주세요.',
                        border: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                      ),
                    ),
                    TextField(
                      obscureText: hide,
                      obscuringCharacter: '*',
                      style: TextStyle(color: Colors.white),
                      controller: pw,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        errorText: pwE,
                        filled: true,
                        fillColor: black1,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.lock.icon(color: Colors.white60),
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
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '비밀번호를 입력해주세요.',
                        border: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
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
                        if (!RegExp(r'^[^.]*@.*\..*$').hasMatch(em.text)) {
                          emE =
                              '이메일은 필수 값으로써 “@“ 포함 ”.“포함 ”@“ 앞에 ”.“사용 불가의 형식을 따릅니다.';
                          setState(() {});
                          return;
                        }

                        emE = null;
                        setState(() {});

                        if (pw.text.length < 6) {
                          pwE = '비밀번호는 필수 값으로써 6자 이상이어야 합니다.';
                          setState(() {});
                          return;
                        }

                        if (!RegExp(
                          r'(?=.*[A-Z])(?=.*[a-z])',
                        ).hasMatch(pw.text)) {
                          pwE = '비밀번호는 대문자 1자 이상 소문자 1자 이상의 형식을 따릅니다.';
                          setState(() {});
                          return;
                        }

                        pwE = null;
                        setState(() {});

                        post(
                          Uri.parse('http://${baseUrl}/auth/login/v2'),
                          headers: baseHeader,
                          body: jsonEncode({
                            "email": em.text,
                            "password": pw.text,
                          }),
                        ).then((value) {
                          final body = jsonDecode(value.body);

                          if (body['success'] ?? false) {
                            appCtrl.user = body['data']['user'];
                            appCtrl.tkn = body['data']['token'];
                            context.go(BaseScreen());
                            return;
                          }

                          message(
                            (body['errors'] as List).firstOrNull['message'],
                          );
                        }, onError: (e) => message('서버 통신 오류'));
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
                          Text(
                            '또는',
                            style: TextStyle(
                              color: Colors.white60,
                              fontWeight: .w500,
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white60)),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          '계정이 없으신가요?',
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: .w500,
                          ),
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
