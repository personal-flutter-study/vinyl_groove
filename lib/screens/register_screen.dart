import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? image;

  final na = TextEditingController();
  final ar = TextEditingController();
  final pr = TextEditingController();
  final ba = TextEditingController();
  final de = TextEditingController();

  Genre? genre;
  (String, String)? con;
  (String, String)? trade;

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    final file = File(image?.path ?? '');
    if (file.existsSync()) {
      provider = FileImage(file);
    } else {
      provider = AssetImage(file.path);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            '상품 등록',
            style: TextStyle(fontWeight: .bold, color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('카메라로 촬영'),
                      onTap: () async {
                        image = await ImagePicker().pickImage(source: .camera);
                        setState(() {});
                      },
                    ),
                    PopupMenuItem(
                      child: Text('갤러리에서 선택'),
                      onTap: () async {
                        image = await ImagePicker().pickImage(source: .gallery);
                        setState(() {});
                      },
                    ),
                  ],
                  child: Container(
                    width: .infinity,
                    height: 250,
                    clipBehavior: .antiAlias,
                    foregroundDecoration: BoxDecoration(
                      image: provider == null
                          ? null
                          : DecorationImage(image: provider),
                    ),
                    decoration: BoxDecoration(
                      color: blackAccent,
                      borderRadius: .circular(12),
                    ),
                    alignment: .center,
                    child: Column(
                      spacing: 6,
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          size: 48,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white38,
                        ),

                        Text(
                          '상품 이미지를 등록하세요',
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: .bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '터치하여 카메라/겔러리 선택',
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '앨범명 *',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    TextField(
                      controller: na,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: .lerp(Colors.black, Colors.white, .05),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명을 입력해주세요.',
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '아티스트 *',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    TextField(
                      controller: ar,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: .lerp(Colors.black, Colors.white, .05),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '아티스트명을 입력해주세요.',
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '장르 *',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children: Genre.values
                                .where((element) => element != Genre.WH)
                                .map(
                                  (e) => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: .zero,
                                      padding: .symmetric(
                                        vertical: 10,
                                        horizontal: 16,
                                      ),
                                      backgroundColor: genre == e
                                          ? yellow
                                          : blackAccent,
                                      foregroundColor: genre == e
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        genre = e;
                                      });
                                    },
                                    child: Text(
                                      e.l,
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '음반 상태 *',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children:
                                [
                                      ('SS', '미개봉 새상품'),
                                      ('M', 'Mint - 완벽한 상태'),
                                      ('NM', 'Near Mint - 거의 새것'),
                                      ('EX', 'Excellent - 약간의 사용감'),
                                      ('VG+', 'Very Good+ - 양호'),
                                      ('VG', 'Very Good - 사용감 있음'),
                                      ('G', 'Good - 재생 가능'),
                                    ]
                                    .map(
                                      (e) => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: .zero,
                                          padding: .symmetric(
                                            vertical: 10,
                                            horizontal: 16,
                                          ),
                                          backgroundColor: con == e
                                              ? yellow
                                              : blackAccent,
                                          foregroundColor: con == e
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            con = e;
                                          });
                                        },
                                        child: Text(
                                          e.$1,
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      con?.$2 ?? '',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '가격 *',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    TextField(
                      controller: pr,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: .symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        fillColor: .lerp(Colors.black, Colors.white, .05),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '가격을 입력해주세요.',
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '거래 방식 *',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children:
                                [
                                      ('DIRECT', '직거래'),
                                      ('DELIVERY', '택배'),
                                      ('BOTH', '둘 다'),
                                    ]
                                    .map(
                                      (e) => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: .zero,
                                          padding: .symmetric(
                                            vertical: 10,
                                            horizontal: 16,
                                          ),
                                          backgroundColor: trade == e
                                              ? yellow
                                              : blackAccent,
                                          foregroundColor: trade == e
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            trade = e;
                                          });
                                        },
                                        child: Text(
                                          e.$2,
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '바코드 번호',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    TextField(
                      controller: ba,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: .lerp(Colors.black, Colors.white, .05),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '바코드 번호 (선택)',
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '상품 설명',
                      style: TextStyle(fontWeight: .bold, color: Colors.white),
                    ),

                    TextField(
                      controller: de,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: .lerp(Colors.black, Colors.white, .05),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '상품에 대한 상세 설명을 입력하세요',
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                    padding: .symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if (image == null) {
                      context.message('상품 이미지는 필수 입니다..');
                      return;
                    }
                    if (na.text.isEmpty) {
                      context.message('엘멍명 입력은 필수 입니다..');
                      return;
                    }
                    if (ar.text.isEmpty) {
                      context.message('아티스트명 입력은 필수 입니다..');
                      return;
                    }
                    if (genre == null) {
                      context.message('장르 선택은 필수 입니다..');
                      return;
                    }
                    if (con == null) {
                      context.message('음방 상태 선택은 필수 입니다..');
                      return;
                    }
                    if (pr.text.isEmpty) {
                      context.message('가격 입력은 필수 입니다..');
                      return;
                    }

                    final price = int.tryParse(pr.text) ?? 0;

                    if (price < 1000) {
                      context.message('가격은 숫자 입력으로 1000원을 넘겨야 합니다.');
                      return;
                    }
                    if (trade == null) {
                      context.message('거래 방식 선택은 필수 입니다.');
                      return;
                    }

                    post(
                      Uri.parse('http://${baseUrl}/products'),
                      headers: {...authHeader, ...jsonHeader},
                      body: jsonEncode({
                        "albumName": na.text,
                        "artist": ar.text,
                        "genre": genre?.v,
                        "condition": con?.$1,
                        "price": price,
                        "tradeMethod": trade?.$1,
                        "barcode": ba.text,
                        "description": de.text,
                        "albumImage": image?.path,
                      }),
                    ).then((value) async {
                      final body = jsonDecode(value.body);
                      if (value.statusCode == 201) {
                        context.message('"${na.text}" 상품 등록이 완료 되었습니다.');
                        context.back();
                        return body['data'];
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
                        '등록하기',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
