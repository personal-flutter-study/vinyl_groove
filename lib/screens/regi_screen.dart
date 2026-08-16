import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';

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
  Con2? con = .SS;
  Trade? trd = .DIRECT;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            style: IconButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.transparent,
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
                      image: bytes != null
                          ? DecorationImage(
                              image: MemoryImage(bytes!),
                              fit: .cover,
                            )
                          : null,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: black2,
                    ),
                    alignment: .center,
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white38,
                          size: 52,
                        ),

                        Text(
                          '상품 이미지를 등록하세요',
                          style: TextStyle(
                            fontWeight: .w500,
                            fontSize: 16,
                            color: Colors.white38,
                          ),
                        ),
                        Text(
                          '터치하여 카메라/갤러리 선택',
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
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),

                    TextField(
                      controller: na,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명을 입력하세요',
                        filled: true,
                        fillColor: black1,
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
                      controller: ar,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '아티스트명을 입력하세요',
                        filled: true,
                        fillColor: black1,
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
                              foregroundColor: act
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: act ? yellow : black3,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                if (gen == e) {
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
                        children: Con2.values.map((e) {
                          final act = con == e;

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: act
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: act ? yellow : black3,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                if (con == e) {
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
                      controller: pr,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        prefixIcon: SizedBox(),
                        hintText: '가격을 입력하세요',
                        filled: true,
                        fillColor: black1,
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
                        children: Trade.values.map((e) {
                          final act = trd == e;

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: act
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: act ? yellow : black3,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                if (trd == e) {
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
                      controller: ba,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '바코드 번호 (선택)',
                        filled: true,
                        fillColor: black1,
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
                      controller: de,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '상품에 대한 상세 설명을 입력하세요',
                        filled: true,
                        fillColor: black1,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                      padding: .symmetric(vertical: 16),
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
                          try {
                            final body = jsonDecode(value.body);

                            if (value.statusCode == 201) {
                              message(body['message']);
                              img = body['data']['imageUrl'];
                              return;
                            }

                            message(
                              (body['errors'] as List).firstOrNull['message'],
                            );
                          } catch (e) {
                            print(e);
                          }
                          return null;
                        });
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
                        try {
                          final body = jsonDecode(value.body);

                          if (value.statusCode == 201) {
                            message(body['message']);
                            context.back();
                            return;
                          }

                          message(
                            (body['errors'] as List).firstOrNull['message'],
                          );
                        } catch (e) {
                          print(e);
                        }
                        return null;
                      });
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

enum Con2 {
  SS('SS', '미개봉 새상품'),
  M('M', 'Mint - 완벽한 상태'),
  NM('NM', 'Near Mint - 거의 새것'),
  EX('EX', 'Excellent - 약간의 사용감'),
  VG_P('VG+', 'Very Good+ - 양호'),
  VG('VG', 'Very Good - 사용감 있음'),
  G('G', 'Good - 재생 가능');

  final String v;
  final String l;

  const Con2(this.v, this.l);
}
