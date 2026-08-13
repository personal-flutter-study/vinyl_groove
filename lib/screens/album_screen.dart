import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_5/widgets/like_button.dart';

import '../main.dart';
import '../models/album_model.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      get(
        Uri.parse('http://${baseUrl}/products/${widget.id}'),
        headers: baseHeader,
      ).then((value) {
        final body = jsonDecode(value.body);

        if (value.statusCode == 200) {
          album = AlbumModel.from(body['data']);
          info = body['data'];
          setState(() {});
          return body;
        }
        message((body['errors'] as List).first['message']);
        return null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final album = this.album;

    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: album == null
            ? Center(child: CircularProgressIndicator(color: yellow))
            : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          actions: [LikeButton(albumModel: album, size: 24)],
                          expandedHeight: 300,
                          backgroundColor: Colors.transparent,
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
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [black, Colors.black26, Colors.black12],
                                begin: .bottomCenter,
                                end: .topCenter,
                              ),
                            ),
                            child: Image.network(
                              album.albumImage,
                              fit: .fitHeight,
                              height: 500,
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 24,
                              children: [
                                Column(
                                  spacing: 16,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: .start,
                                      spacing: 8,
                                      children: [
                                        Text(
                                          overflow: .ellipsis,
                                          album.albumName,
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
                                              horizontal: 12,
                                            ),
                                            minimumSize: .zero,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.genre.l,
                                            style: TextStyle(
                                              fontWeight: .bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 12,
                                            ),
                                            minimumSize: .zero,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              fontWeight: .bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 12,
                                            ),
                                            minimumSize: .zero,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.tradeMethod.l,
                                            style: TextStyle(
                                              fontWeight: .bold,
                                              fontSize: 12,
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
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Row(
                                              spacing: 12,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: yellow
                                                      .withAlpha(100),
                                                  radius: 24,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: yellow,
                                                    size: 24,
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: .start,
                                                    children: [
                                                      Text(
                                                        seller['name'],
                                                        overflow: .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: .bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),

                                                      Text(
                                                        seller['email'],
                                                        overflow: .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white60,
                                                          fontWeight: .w500,
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
                                                    size: 16,
                                                    color: Colors.white60,
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
                                      spacing: 12,
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
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: .circular(4),
                                          ),
                                          padding: .symmetric(
                                            vertical: 4,
                                            horizontal: 6,
                                          ),
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: .bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      info['conditionDescription'],
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: .w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: .start,
                                  spacing: 8,
                                  children: [
                                    Row(
                                      spacing: 12,
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
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: .w500,
                                      ),
                                    ),
                                  ],
                                ),

                                Material(
                                  color: black2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      spacing: 12,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              Text(
                                                '가격',
                                                overflow: .ellipsis,
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
                                          crossAxisAlignment: .end,
                                          children: [
                                            Text(
                                              '거래 방식',
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontWeight: .w500,
                                              ),
                                            ),

                                            Text(
                                              album.tradeMethod.l,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: .w500,
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
                        message('구매 기능은 현재 준비중입니다.');
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
