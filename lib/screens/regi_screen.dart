import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove_poc_10/app_ctrl.dart';

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
        backgroundColor: black,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                PopupMenuButton(
                  color: black2,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        image = await ImagePicker().pickImage(source: .camera);
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
                        image = await ImagePicker().pickImage(source: .gallery);
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
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white38,
                          size: 52,
                        ),

                        Text(
                          '상품 이미지를 등록하세요',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontWeight: .w500,
                          ),
                        ),
                        Text(
                          '터치하여 카메라/갤러리 선택',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
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
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),

                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: na,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: black1,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명을 입력하세요',
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
                  ],
                ),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '아티스트 *',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),

                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: ar,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: black1,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '아티스트명을 입력하세요',
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
                  ],
                ),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '장르 *',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
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
                              padding: .symmetric(vertical: 8, horizontal: 16),
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
                              style: TextStyle(fontWeight: .bold, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '음반 상태 *',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
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
                              padding: .symmetric(vertical: 8, horizontal: 16),
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
                              style: TextStyle(fontWeight: .bold, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    Text(con?.l ?? '', style: TextStyle(color: Colors.white60)),
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '가격 *',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),

                    TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(color: Colors.white),
                      controller: pr,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: SizedBox(),
                        fillColor: black1,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '가격을 입력하세요',
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
                  ],
                ),

                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      '거래 방식 *',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
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
                              padding: .symmetric(vertical: 8, horizontal: 16),
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
                              style: TextStyle(fontWeight: .bold, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
                        filled: true,
                        fillColor: black1,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '바코드 번호 (선택)',
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
                        filled: true,
                        fillColor: black1,
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '상품에 대한 설명을 입럭해세요',
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
                        ).then((value) async {
                          try {
                            final body = jsonDecode(value.body);

                            if (body['success'] ?? false) {
                              message(body['message']);
                              img = body['data']['imageUrl'];
                              return;
                            }

                            message(
                              (body['errors'] as List).firstOrNull['message'],
                            );
                          } catch (e, s) {
                            print(e);
                            print(s);
                          }
                        }, onError: (e) => message('서버 통신 오류'));
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
                      ).then((value) async {
                        try {
                          final body = jsonDecode(value.body);

                          if (body['success'] ?? false) {
                            message(body['message']);
                            context.back();
                            return;
                          }

                          message(
                            (body['errors'] as List).firstOrNull['message'],
                          );
                        } catch (e, s) {
                          print(e);
                          print(s);
                        }
                      }, onError: (e) => message('서버 통신 오류'));
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
