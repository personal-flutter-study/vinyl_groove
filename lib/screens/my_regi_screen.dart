import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_3/screens/album_screen.dart';
import 'package:vinyl_groove_poc_3/screens/regi_screen.dart';

import '../main.dart';
import '../models/album_model.dart';

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

      if (value.statusCode == 200) {
        albums = (body['data'] as List).map((e) => AlbumModel.from(e)).toList();
        if (mounted) setState(() {});
        return body;
      }
      message((body['errors'] as List).first['message']);

      return null;
    });
    ;
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
          actions: [
            IconButton(
              onPressed: () async {
                await context.go(RegiScreen());
                setState(() {});
              },
              icon: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            '내 등록 상품',
            style: TextStyle(fontWeight: .bold, color: Colors.white),
          ),
        ),
        backgroundColor: black,
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
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: albums
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Material(
                              color: black2,
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(12),
                              ),
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
                                          width: 82,
                                          height: 82,
                                          fit: .cover,
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          spacing: 4,
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              e.albumName,
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: .bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              e.artist,
                                              overflow: .ellipsis,
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
                                                    borderRadius: .circular(4),
                                                  ),
                                                  color: Colors.black54,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6.0,
                                                          vertical: 4,
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
                                                  NumberFormat(
                                                    '₩ #,###',
                                                  ).format(e.price),
                                                  style: TextStyle(
                                                    color: yellow,
                                                    fontSize: 16,
                                                    fontWeight: .bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        spacing: 4,
                                        children: [
                                          IconButton(
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
                                            onPressed: () {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) => CupertinoAlertDialog(
                                                  title: Text(
                                                    '${e.albumName}을(를) 삭제하시겠습니까',
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

                                                        get(
                                                          Uri.parse(
                                                            'http://${baseUrl}/products/${e.id}',
                                                          ),
                                                          headers: baseHeader,
                                                        ).then((value) {
                                                          final body =
                                                              jsonDecode(
                                                                value.body,
                                                              );

                                                          if (value
                                                                  .statusCode ==
                                                              200) {
                                                            message(
                                                              '상품이 삭제되었습니다.',
                                                            );
                                                            load();
                                                            return;
                                                          }
                                                          message(
                                                            (body['errors']
                                                                    as List)
                                                                .first['message'],
                                                          );

                                                          return null;
                                                        });
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
      ),
    );
  }
}
