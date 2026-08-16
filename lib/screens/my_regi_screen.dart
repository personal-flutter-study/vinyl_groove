import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_2/screens/regi_screen.dart';

import '../main.dart';
import '../models/album_model.dart';
import 'album_screen.dart';

class MyRegiScreen extends StatefulWidget {
  const MyRegiScreen({super.key});

  @override
  State<MyRegiScreen> createState() => _MyRegiScreenState();
}

class _MyRegiScreenState extends State<MyRegiScreen> {
  List<AlbumModel> albums = [];

  Future<void> load() async {
    await get(
      Uri.parse('http://${baseUrl}/products/me'),
      headers: baseHeader,
    ).then((value) {
      try {
        final body = jsonDecode(value.body);

        if (value.statusCode == 200) {
          albums = (body['data'] as List)
              .map((e) => AlbumModel.from(e))
              .toList();
          if (mounted) setState(() {});
          return body;
        }
      } catch (e) {
        print(e);
      }
      return null;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await load();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            style: IconButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              style: IconButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () async {
                await context.go(RegiScreen());
                load();
              },
              icon: Icon(Icons.add, size: 28),
            ),
          ],
          title: Text(
            '내 등록 상품',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        backgroundColor: black,
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: load,
          child: albums.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => ListView(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight,
                        child: Center(
                          child: Text(
                            '등록된 상품이 없습니다.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: albums
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(12),
                            ),
                            color: black2,
                            child: InkWell(
                              onTap: () {
                                context.go(AlbumScreen(id: e.id));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    ClipRRect(
                                      borderRadius: .circular(12),
                                      child: Image.network(
                                        e.albumImage,
                                        width: 72,
                                        height: 72,
                                        fit: .cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SizedBox(),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        spacing: 4,
                                        children: [
                                          Text(
                                            e.albumName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: .bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            e.artist,
                                            style: TextStyle(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          Row(
                                            spacing: 8,
                                            children: [
                                              Card(
                                                margin: .zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: .circular(2),
                                                ),
                                                color: Colors.black54,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    2.0,
                                                  ),
                                                  child: Text(
                                                    e.condition,
                                                    style: TextStyle(
                                                      fontWeight: .bold,
                                                      color: Colors.white60,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Text(
                                                '₩ ${NumberFormat('#,###').format(e.price)}',
                                                style: TextStyle(
                                                  color: yellow,
                                                  fontSize: 15,
                                                  fontWeight: .bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment: .end,
                                      children: [
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            minimumSize: .zero,
                                            foregroundColor: Colors.white60,
                                          ),
                                          onPressed: () {
                                            message('수정 기능은 준비중입니다.');
                                            load();
                                          },
                                          icon: AppIcon.edit.icon(
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            minimumSize: .zero,
                                            foregroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) => CupertinoAlertDialog(
                                                title: Text(
                                                  '${e.albumName}을(를) 삭제하시겠습니까?',
                                                ),
                                                actions: [
                                                  CupertinoButton(
                                                    child: Text('취소'),
                                                    onPressed: () {
                                                      context.back();
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: Text('삭제'),
                                                    onPressed: () async {
                                                      context.back();
                                                      delete(
                                                        Uri.parse(
                                                          'http://${baseUrl}/products/${e.id}',
                                                        ),
                                                        headers: baseHeader,
                                                      ).then((value) {
                                                        try {
                                                          final body =
                                                              jsonDecode(
                                                                value.body,
                                                              );

                                                          if (value
                                                                  .statusCode ==
                                                              200) {
                                                            message(
                                                              '상품이 삭제되었습니다',
                                                            );

                                                            load();

                                                            return body;
                                                          }
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                        return null;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: AppIcon.delete.icon(
                                            size: 24,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}
