import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove_poc_13/app_ctrl.dart';

import '../main.dart';

class RegiScreen extends StatefulWidget {
  const RegiScreen({super.key});

  @override
  State<RegiScreen> createState() => _RegiScreenState();
}

class _RegiScreenState extends State<RegiScreen> {
  XFile? image;
  Uint8List? bytes;

  final na = TextEditingController();
  final ar = TextEditingController();
  final pr = TextEditingController();
  final ba = TextEditingController();
  final de = TextEditingController();

  Genre? gen = .ROCK;
  Con? con = .SS;
  Trade? trd = .DIRECT;

  String? imE;
  String? genE;
  String? conE;
  String? trdE;
  String? naE;
  String? arE;
  String? prE;

  error(e) {
    imE = null;
    genE = null;
    conE = null;
    trdE = null;
    naE = null;
    arE = null;
    prE = null;

    switch (e['field']) {
      case 'albumImage':
        imE = e['message'];
      case 'albumName':
        naE = e['message'];
      case 'artist':
        arE = e['message'];
      case 'genre':
        genE = e['message'];
      case 'condition':
        conE = e['message'];
      case 'price':
        prE = e['message'];
      case 'tradeMethod':
        trdE = e['message'];
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            style: IconButton.styleFrom(),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            '상품 등록',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                sec(
                  imE,
                  PopupMenuButton(
                    color: black2,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          image = await ImagePicker().pickImage(
                            source: .camera,
                          );
                          bytes = await image?.readAsBytes();
                          setState(() {});
                        },
                        child: Text(
                          '카메라로 촬영',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          image = await ImagePicker().pickImage(
                            source: .gallery,
                          );
                          bytes = await image?.readAsBytes();
                          setState(() {});
                        },
                        child: Text(
                          '갤러리에서 선택',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ],
                    child: Container(
                      height: 200,
                      foregroundDecoration: BoxDecoration(
                        image: bytes == null
                            ? null
                            : DecorationImage(
                                image: MemoryImage(bytes!),
                                fit: .cover,
                              ),
                      ),
                      decoration: BoxDecoration(
                        color: black2,
                        borderRadius: .circular(12),
                      ),
                      alignment: .center,
                      child: Column(
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 52,
                            color: Colors.white24,
                          ),

                          Text(
                            '상품 이미지를 등록하세요',
                            style: TextStyle(
                              color: Colors.white24,
                              fontWeight: .bold,
                            ),
                          ),
                          Text(
                            '터치하여 카메라/갤러리 선택',
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                sec(
                  naE,
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(
                        '앨범명 *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: na,
                        decoration: InputDecoration(
                          fillColor: black1,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '앨범명을 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: .circular(12),
                            borderSide: BorderSide(color: yellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sec(
                  arE,
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(
                        '아티스트 *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: ar,
                        decoration: InputDecoration(
                          fillColor: black1,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '아티스트명을 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: .circular(12),
                            borderSide: BorderSide(color: yellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sec(
                  genE,
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(
                        '장르 *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),

                      SizedBox(
                        width: .infinity,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: Genre.values.map((e) {
                            final act = gen == e;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black3,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (act) {
                                    gen = null;
                                  } else {
                                    gen = e;
                                  }
                                });
                              },
                              child: Text(
                                e.l,
                                style: TextStyle(fontWeight: .bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                sec(
                  conE,
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(
                        '음반 상태 *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),

                      SizedBox(
                        width: .infinity,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: Con.values.map((e) {
                            final act = con == e;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black3,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (act) {
                                    con = null;
                                  } else {
                                    con = e;
                                  }
                                });
                              },
                              child: Text(
                                e.v,
                                style: TextStyle(fontWeight: .bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      if (con != null)
                        Text(
                          con?.l ?? '',
                          style: TextStyle(color: Colors.white60),
                        ),
                    ],
                  ),
                ),
                sec(
                  prE,
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(
                        '가격 *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: pr,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          fillColor: black1,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '가격을 입력하세요',
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          prefixIcon: SizedBox(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: .circular(12),
                            borderSide: BorderSide(color: yellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                sec(
                  trdE,
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(
                        '거래 방식 *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),

                      SizedBox(
                        width: .infinity,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: Trade.values.map((e) {
                            final act = trd == e;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black3,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (act) {
                                    trd = null;
                                  } else {
                                    trd = e;
                                  }
                                });
                              },
                              child: Text(
                                e.l,
                                style: TextStyle(fontWeight: .bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '바코드 번호',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: ba,
                      decoration: InputDecoration(
                        fillColor: black1,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '바코드 번호 (선택)',
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
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
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),
                    TextField(
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      controller: de,
                      decoration: InputDecoration(
                        fillColor: black1,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '상품에 해당 상세 설명을 입력해주세요',
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      foregroundColor: Colors.black,
                      padding: .symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                    ),
                    onPressed: () async {
                      String? img;
                      if (image != null) {
                        await post(
                          Uri.parse('http://${baseUrl}/upload/image'),
                          headers: baseHeader,
                          body: jsonEncode({
                            "image":
                                "data:${image?.mimeType ?? 'image/png'};base64,${base64Encode(bytes!)}",
                            "type": "ALBUM",
                          }),
                        ).then((value) {
                          final body = jsonDecode(value.body);

                          if (body['success'] ?? false) {
                            message(body['message']);
                            img = body['data']['imageUrl'];
                            return body;
                          }

                          message(
                            (body['errors'] as List?)?.firstOrNull['message'],
                          );
                        }, onError: (e) => message('서버 통신 에러'));
                      }

                      post(
                        Uri.parse('http://${baseUrl}/products'),
                        headers: baseHeader,
                        body: jsonEncode({
                          "albumName": na.text,
                          "artist": ar.text,
                          "genre": gen?.v,
                          "condition": con?.v,
                          "price": int.tryParse(pr.text) ?? 0,
                          "tradeMethod": trd?.v,
                          "barcode": ba.text,
                          "description": de.text,
                          "albumImage": img,
                        }),
                      ).then((value) {
                        final body = jsonDecode(value.body);

                        if (body['success'] ?? false) {
                          message(body['message']);
                          context.back();
                          return body;
                        }
                        message(
                          (body['errors'] as List?)?.firstOrNull['message'],
                        );
                        error((body['errors'] as List?)?.firstOrNull);
                      }, onError: (e) => message('서버 통신 에러'));
                    },
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          '등록하기',
                          style: TextStyle(fontWeight: .bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sec(String? e, w) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      w,

      if (e != null)
        Text(
          e,
          style: TextStyle(color: Colors.red, fontWeight: .w500),
        ),
    ],
  );
}

enum Con {
  SS('SS', '미개봉 새상품'),
  M('M', 'Mint - 완벽한 상태'),
  NM('NM', 'Near Mint - 거의 새것'),
  EX('EX', 'Excellent - 약간의 사용감'),
  VG_P('VG+', 'Very Good+ - 양호'),
  VG('VG', 'Very Good - 사용감 있음'),
  G('G', 'Good - 재생 가능');

  final String v;
  final String l;

  const Con(this.v, this.l);
}
