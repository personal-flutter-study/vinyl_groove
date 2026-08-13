import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../app_ctrl.dart';
import '../main.dart';

class RegiScreen extends StatefulWidget {
  const RegiScreen({super.key});

  @override
  State<RegiScreen> createState() => _RegiScreenState();
}

class _RegiScreenState extends State<RegiScreen> {
  XFile? image;

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
    ImageProvider? provider;

    if (image != null) {
      final file = File(image!.path);
      provider = file.existsSync() ? FileImage(file) : AssetImage(file.path);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            '상품 등록',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        backgroundColor: black,
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
                      borderRadius: .circular(12),
                      image: provider != null
                          ? DecorationImage(image: provider)
                          : null,
                    ),
                    color: black2,
                    alignment: .center,
                    child: Column(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        Icon(
                          size: 54,
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white54,
                        ),

                        Text(
                          '상품 이미지를 등록하세요',
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: .w500,
                          ),
                        ),
                        Text(
                          '터치하여 카메라/겔러리 선택',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
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
                      '엘범명 *',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),

                    TextField(
                      controller: na,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: black1,

                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '엘범명을 입력하세요',
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
                        filled: true,
                        fillColor: black1,

                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '엘범명을 입력하세요',
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
                        spacing: 8,
                        runSpacing: 8,
                        children: Genre.values.map((e) {
                          final act = gen == e;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: act ? yellow : black3,
                              foregroundColor: act
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 12, horizontal: 18),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                if (gen == e) {
                                  gen = null;
                                  return;
                                }

                                gen = e;
                              });
                            },
                            child: Text(
                              e.l,
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
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
                        runSpacing: 8,
                        spacing: 8,
                        children: Con.values.map((e) {
                          final act = con == e;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: act ? yellow : black3,
                              foregroundColor: act
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 12, horizontal: 18),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                if (con == e) {
                                  con = null;
                                  return;
                                }
                                con = e;
                              });
                            },
                            child: Text(
                              e.v,
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    Text(
                      con?.l ?? '',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
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
                        filled: true,
                        fillColor: black1,

                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        prefixIcon: SizedBox(),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '가격을 입력하세요',
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
                        spacing: 8,
                        children: Trade.values.map((e) {
                          final act = trd == e;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: act ? yellow : black3,
                              foregroundColor: act
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 12, horizontal: 18),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                if (trd == e) {
                                  trd = null;
                                  return;
                                }

                                trd = e;
                              });
                            },
                            child: Text(
                              e == .BOTH ? '둘 다 가능' : e.l,
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
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
                        filled: true,
                        fillColor: black1,

                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
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
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),

                    TextField(
                      controller: de,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: black1,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '상품에 대한 상세 설명을 입력하세요',
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                        print(image!.mimeType);

                        img =
                            await post(
                              Uri.parse('http://${baseUrl}/upload/image'),
                              headers: baseHeader,
                              body: jsonEncode({
                                "image":
                                    "data:${image!.mimeType ?? 'image/png'};base64,${base64Encode(await image!.readAsBytes())}",
                                "type": "ALBUM",
                              }),
                            ).then((value) {
                              try {
                                final body = jsonDecode(value.body);

                                print(body);

                                if (value.statusCode == 201) {
                                  message(body['message']);

                                  return body['data']['imageUrl'];
                                }
                                message(
                                  (body['errors'] as List).first['message'],
                                );
                              } catch (e) {
                                print(e);
                              }
                              return null;
                            });
                      }

                      print(img);

                      await post(
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
                          "albumImage": img?.toString(),
                        }),
                      ).then((value) {
                        try {
                          final body = jsonDecode(value.body);

                          print(body);

                          if (value.statusCode == 201) {
                            message(body['message']);

                            context.back();

                            return body['data'];
                          }
                          message((body['errors'] as List).first['message']);
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
