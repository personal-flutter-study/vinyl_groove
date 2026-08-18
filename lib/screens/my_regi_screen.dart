import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_8/screens/regi_screen.dart';

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
      final body = jsonDecode(value.body);

      if (body['success'] ?? false) {
        albums = (body['data'] as List).map((e) => AlbumModel.from(e)).toList();
        if (mounted) setState(() {});
        return body;
      }
      message((body['errors'] as List).firstOrNull['message']);
    }, onError: (e) => message('서버 통신 오류'));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            style: IconButton.styleFrom(),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              style: IconButton.styleFrom(),
              onPressed: () async {
                await context.go(RegiScreen());
                load();
              },
              icon: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ],
          backgroundColor: Colors.transparent,
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
                              color: Colors.white60,
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
                            color: black2,
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(12),
                            ),
                            clipBehavior: .antiAlias,
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
                                      clipBehavior: .antiAlias,
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
                                            overflow: .ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: .bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            e.artist,
                                            overflow: .ellipsis,

                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14,
                                            ),
                                          ),

                                          Row(
                                            spacing: 8,
                                            children: [
                                              Container(
                                                padding: .symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius: .circular(4),
                                                ),
                                                child: Text(
                                                  e.condition,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: .w500,
                                                  ),
                                                ),
                                              ),

                                              Text(
                                                NumberFormat(
                                                  '₩ #,###',
                                                ).format(e.price),
                                                style: TextStyle(
                                                  color: yellow,
                                                  fontWeight: .bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      spacing: 4,
                                      crossAxisAlignment: .end,
                                      children: [
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            minimumSize: .zero,
                                            padding: .zero,
                                          ),
                                          onPressed: () {
                                            message('수정 기능은 준비중입니다.');
                                            load();
                                          },
                                          icon: AppIcon.edit.icon(
                                            color: Colors.white60,
                                            size: 24,
                                          ),
                                        ),
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            minimumSize: .zero,
                                            padding: .zero,
                                          ),
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) => CupertinoAlertDialog(
                                                title: Text(
                                                  '${e.albumName}을(를)\n삭제하시겠습니까?',
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
                                                    onPressed: () {
                                                      context.back();

                                                      delete(
                                                        Uri.parse(
                                                          'http://${baseUrl}/products/${e.id}',
                                                        ),
                                                        headers: baseHeader,
                                                      ).then(
                                                        (value) async {
                                                          final body =
                                                              jsonDecode(
                                                                value.body,
                                                              );

                                                          if (body['success'] ??
                                                              false) {
                                                            message(
                                                              '상품이 삭제되었습니다',
                                                            );
                                                            load();

                                                            return body['data'];
                                                          }
                                                          message(
                                                            (body['errors']
                                                                    as List)
                                                                .firstOrNull['message'],
                                                          );
                                                        },
                                                        onError: (e) =>
                                                            message('서버 통신 오류'),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: AppIcon.delete.icon(
                                            color: Colors.red,
                                            size: 24,
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
