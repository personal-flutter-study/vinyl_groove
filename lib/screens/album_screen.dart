import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_8/models/album_model.dart';
import 'package:vinyl_groove_poc_8/widgets/like_button.dart';

import '../main.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.id});

  final int id;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  AlbumModel? album;
  late Map info;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      get(
        Uri.parse('http://${baseUrl}/products/${widget.id}'),
        headers: baseHeader,
      ).then((value) {
        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          album = AlbumModel.from(body['data']);
          info = body['data'];
          setState(() {});
          return body;
        }
        message((body['errors'] as List).firstOrNull['message']);
      }, onError: (e) => message('서버 통신 오류'));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final album = this.album;

    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        resizeToAvoidBottomInset: false,
        body: album == null
            ? Center(child: CircularProgressIndicator(color: yellow))
            : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          actions: [LikeButton(albumModel: album, size: 28)],
                          backgroundColor: Colors.transparent,
                          expandedHeight: 300,
                          leading: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            onPressed: () {
                              context.back();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          flexibleSpace: Container(
                            height: 500,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [black, Colors.black12, Colors.black12],
                                begin: .bottomCenter,
                                end: .topCenter,
                              ),
                            ),
                            child: Image.network(album.albumImage, fit: .cover),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              spacing: 24,
                              crossAxisAlignment: .start,
                              children: [
                                Column(
                                  crossAxisAlignment: .start,
                                  spacing: 16,
                                  children: [
                                    Column(
                                      crossAxisAlignment: .start,
                                      spacing: 8,
                                      children: [
                                        Text(
                                          album.albumName,
                                          overflow: .ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: .bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                        Text(
                                          album.artist,
                                          overflow: .ellipsis,
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      spacing: 8,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                            minimumSize: .zero,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.genre.l,
                                            style: TextStyle(
                                              fontWeight: .w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                            minimumSize: .zero,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              fontWeight: .w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                            minimumSize: .zero,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.tradeMethod.l,
                                            style: TextStyle(
                                              fontWeight: .w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final seller = info['seller'];

                                        return Material(
                                          color: black2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: .circular(12),
                                          ),
                                          clipBehavior: .antiAlias,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              spacing: 12,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: yellow
                                                      .withAlpha(80),
                                                  radius: 28,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: yellow,
                                                    size: 28,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: .start,
                                                    spacing: 4,
                                                    children: [
                                                      Text(
                                                        seller['name'],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: .bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        seller['email'],
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight: .w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white60,
                                                    size: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: .start,
                                  spacing: 8,
                                  children: [
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          '상태 등급',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: .bold,
                                            fontSize: 18,
                                          ),
                                        ),

                                        Container(
                                          padding: .symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: .circular(8),
                                          ),
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              fontWeight: .w500,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      info['conditionDescription'],
                                      style: TextStyle(color: Colors.white60),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: .start,
                                  spacing: 8,
                                  children: [
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          '상품 설명',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: .bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      info['description'],
                                      style: TextStyle(color: Colors.white60),
                                    ),
                                  ],
                                ),

                                Material(
                                  color: black2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  clipBehavior: .antiAlias,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      spacing: 12,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            spacing: 4,
                                            children: [
                                              Text(
                                                '가격',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: .w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                NumberFormat(
                                                  '₩ #,###',
                                                ).format(album.price),
                                                style: TextStyle(
                                                  color: yellow,
                                                  fontWeight: .bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: .end,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              '거래 방식',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontWeight: .w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              album.tradeMethod.l,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: .w500,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: black2,
                    padding: .all(16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: Colors.black,
                        padding: .symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(12),
                        ),
                      ),
                      onPressed: () {
                        message('구매 기능은 준비중입니다.');
                      },
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            '구매하기',
                            style: TextStyle(fontWeight: .bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
    ;
  }
}
