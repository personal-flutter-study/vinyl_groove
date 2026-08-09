import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';
import 'package:vinyl_groove_poc_1/screens/album_screen.dart';
import 'package:vinyl_groove_poc_1/screens/register_screen.dart';

import '../main.dart';

class MyRegisterScreen extends StatefulWidget {
  const MyRegisterScreen({super.key});

  @override
  State<MyRegisterScreen> createState() => _MyRegisterScreenState();
}

class _MyRegisterScreenState extends State<MyRegisterScreen> {
  List albums = [];

  refresh() =>
      get(Uri.parse('http://${baseUrl}/products/me'), headers: authHeader).then(
        (value) async {
          final body = jsonDecode(value.body);
          if (value.statusCode == 200) {
            albums = body['data'];
            setState(() {});
          }
        },
      );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      refresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            '내 등록 상품',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.go(RegisterScreen());
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),

        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: albums.isEmpty
            ? Center(
                child: Text(
                  '등록된 상품이 없습니다.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await refresh();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12,
                      children: albums
                          .map(
                            (e) => GestureDetector(
                              onTap: () async {
                                context.go(
                                  AlbumScreen(
                                    albumModel: AlbumModel.from(
                                      await appCtrl.loadAlbumDetail(e['id']),
                                    ),
                                  ),
                                );
                              },
                              child: Material(
                                color: blackAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                child: Padding(
                                  padding: .all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: .circular(12),
                                        child: SizedBox.square(
                                          dimension: 72,
                                          child: Image.network(
                                            e['albumImage'],
                                            fit: .fill,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          tileColor: blackAccent,

                                          title: Text(
                                            e['albumName'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: .bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              Text(
                                                e['albumName'],
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                ),
                                              ),

                                              Row(
                                                children: [
                                                  Card(
                                                    margin: .all(8),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              .circular(4),
                                                        ),
                                                    color: Colors.black54,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: Text(
                                                        e['condition'],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: .bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Text(
                                                    "\₩${NumberFormat('###,###').format(100)}",
                                                    style: TextStyle(
                                                      fontWeight: .bold,
                                                      color: yellow,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Column(
                                        spacing: 18,
                                        crossAxisAlignment: .end,
                                        children: [
                                          IconButton(
                                            style: IconButton.styleFrom(
                                              minimumSize: .zero,
                                              tapTargetSize: .shrinkWrap,
                                              padding: .zero,
                                            ),
                                            onPressed: () {
                                              context.message('수정은 준비중 입니다.');
                                              refresh();
                                            },
                                            icon: AppIcon.edit.icon(
                                              width: 24,
                                              color: Colors.white60,
                                            ),
                                          ),
                                          IconButton(
                                            style: IconButton.styleFrom(
                                              minimumSize: .zero,
                                              tapTargetSize: .shrinkWrap,
                                              padding: .zero,
                                            ),
                                            onPressed: () {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) => CupertinoAlertDialog(
                                                  title: Text(
                                                    '${e['albumName']}을(를) 삭제하시겠습니까?',
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
                                                        await delete(
                                                          Uri.parse(
                                                            'http://${baseUrl}/products/${e['id']}',
                                                          ),
                                                          headers: authHeader,
                                                        ).then((value) async {
                                                          final body =
                                                              jsonDecode(
                                                                value.body,
                                                              );
                                                          if (value
                                                                  .statusCode ==
                                                              200) {
                                                            context.message(
                                                              '상품이 삭제되었습니다.',
                                                            );
                                                            await refresh();
                                                            return body['data'];
                                                          }

                                                          context.message(
                                                            (body['errors']
                                                                    as List)
                                                                .first['message'],
                                                          );
                                                        });

                                                        context.back();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: AppIcon.delete.icon(
                                              width: 24,
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
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
