import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_5/models/album_model.dart';
import 'package:vinyl_groove_poc_5/screens/album_screen.dart';

import '../main.dart';

class MyRegiScreen extends StatefulWidget {
  const MyRegiScreen({super.key});

  @override
  State<MyRegiScreen> createState() => _MyRegiScreenState();
}

class _MyRegiScreenState extends State<MyRegiScreen> {
  List<AlbumModel> albums = [];

  Future<Null> load() =>
      get(Uri.parse('http://${baseUrl}/products/me'), headers: baseHeader).then(
        (value) {
          try {
            final body = jsonDecode(value.body);
            if (value.statusCode == 200) {
              albums = (body['data'] as List)
                  .map((e) => AlbumModel.from(e))
                  .toList();
              if (mounted) setState(() {});
              return;
            }
            message((body['errors'] as List).first['message']);
          } catch (e) {
            print(e);
          }
          return null;
        },
      );

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
          leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            '내 등록 상품',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.back();
              },
              icon: AppIcon.add.icon(color: Colors.white, size: 28),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await load();
            },
            child: albums.isEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: Center(
                              child: Text(
                                '등록된 상품이 없습니다.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : ListView(
                    children: albums
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Material(
                              color: black,
                              borderRadius: .circular(12),
                              child: InkWell(
                                onTap: () {
                                  context.go(AlbumScreen(id: e.id));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      ClipRRect(
                                        borderRadius: .circular(12),
                                        child: Image.network(
                                          e.albumImage,
                                          fit: .cover,
                                          width: 82,
                                          height: 82,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    color: Colors.white,
                                                  ),
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: .circular(4),
                                                  ),
                                                  padding: .symmetric(
                                                    vertical: 4,
                                                    horizontal: 6,
                                                  ),
                                                  child: Text(
                                                    e.condition,
                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 12,
                                                      fontWeight: .bold,
                                                    ),
                                                  ),
                                                ),

                                                Text(
                                                  NumberFormat(
                                                    '₩ #,###',
                                                  ).format(e.price),
                                                  overflow: .ellipsis,
                                                  style: TextStyle(
                                                    color: yellow,
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
                                        crossAxisAlignment: .end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              message('수정 기능은 준비중입니다.');
                                              load();
                                            },
                                            icon: AppIcon.edit.icon(
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              get(
                                                Uri.parse(
                                                  'http://${baseUrl}/products/${e.id}',
                                                ),
                                                headers: baseHeader,
                                              ).then((value) async {
                                                try {
                                                  final body = jsonDecode(
                                                    value.body,
                                                  );

                                                  if (value.statusCode == 200) {
                                                    message('상품이 삭제되었습니다');

                                                    await load();

                                                    setState(() {});
                                                    return;
                                                  }
                                                  message(
                                                    (body['errors'] as List)
                                                        .first['message'],
                                                  );
                                                } catch (e) {
                                                  print(e);
                                                }
                                                return null;
                                              });
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
