import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_6/models/album_model.dart';
import 'package:vinyl_groove_poc_6/widgets/like_button.dart';

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
        try {
          final body = jsonDecode(value.body);
          if (body['success'] ?? false) {
            album = AlbumModel.from(body['data']);
            info = body['data'];
            setState(() {});
            return body;
          }
          message((body['errors'] as List?)?.first['message']);
        } catch (e) {
          message("서버 통신 에러");
        }
      }, onError: (e) => message("서버 통신 에러"));
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
                          actions: [LikeButton(albumModel: album, size: 24)],
                          leading: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            onPressed: () {
                              context.back();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          expandedHeight: 300,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: Container(
                            height: 600,
                            width: .infinity,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [black, Colors.black26, Colors.black12],
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
                              crossAxisAlignment: .start,
                              spacing: 16,
                              children: [
                                Column(
                                  spacing: 8,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      album.albumName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: .bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      album.artist,
                                      style: TextStyle(
                                        color: Colors.white60,

                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  spacing: 6,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: black2,
                                        foregroundColor: Colors.white,
                                        padding: .symmetric(
                                          vertical: 6,
                                          horizontal: 16,
                                        ),
                                        minimumSize: .zero,
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          Text(
                                            album.genre.l,
                                            style: TextStyle(fontWeight: .bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: black2,
                                        foregroundColor: Colors.white,
                                        padding: .symmetric(
                                          vertical: 6,
                                          horizontal: 16,
                                        ),
                                        minimumSize: .zero,
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          Text(
                                            album.condition,
                                            style: TextStyle(fontWeight: .bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: black2,
                                        foregroundColor: Colors.white,
                                        padding: .symmetric(
                                          vertical: 6,
                                          horizontal: 16,
                                        ),
                                        minimumSize: .zero,
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          Text(
                                            album.tradeMethod.l,
                                            style: TextStyle(fontWeight: .bold),
                                          ),
                                        ],
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          spacing: 12,
                                          children: [
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: yellow.withAlpha(
                                                100,
                                              ),
                                              child: Icon(
                                                Icons.person,
                                                color: yellow,
                                                size: 28,
                                              ),
                                            ),

                                            Expanded(
                                              child: Column(
                                                spacing: 4,
                                                crossAxisAlignment: .start,
                                                children: [
                                                  Text(
                                                    seller['name'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: .bold,
                                                      fontSize: 18,
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
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                Column(
                                  spacing: 8,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Row(
                                      spacing: 12,
                                      children: [
                                        Text(
                                          '상태 등급',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: .bold,
                                          ),
                                        ),

                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: .circular(4),
                                          ),
                                          padding: .symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: .bold,
                                              fontSize: 14,
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
                                  spacing: 8,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Row(
                                      spacing: 12,
                                      children: [
                                        Text(
                                          '상품 설명',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: .bold,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      spacing: 12,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            spacing: 4,
                                            crossAxisAlignment: .start,
                                            children: [
                                              Text(
                                                '가격',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: .w500,
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
                                          spacing: 4,
                                          crossAxisAlignment: .end,
                                          children: [
                                            Text(
                                              '거래 방식',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontWeight: .w500,
                                              ),
                                            ),
                                            Text(
                                              album.tradeMethod.l,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: .bold,
                                                fontSize: 16,
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
                    padding: .all(12),
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
  }
}
