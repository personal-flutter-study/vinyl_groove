import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_10/models/album_model.dart';
import 'package:vinyl_groove_poc_10/widgets/like_button.dart';

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
      ).then((value) async {
        try {
          final body = jsonDecode(value.body);

          if (body['success'] ?? false) {
            album = AlbumModel.from(body['data']);
            info = body['data'];
            if (mounted) setState(() {});
            return body;
          }

          message((body['errors'] as List).firstOrNull['message']);
        } catch (e, s) {
          print(e);
          print(s);
        }
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
                          actions: [LikeButton(albumModel: album, size: 28)],
                          expandedHeight: 300,
                          flexibleSpace: Container(
                            height: 300,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [black, Colors.black12, Colors.black12],
                                begin: .bottomCenter,
                                end: .topCenter,
                              ),
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(album.albumImage),
                                fit: .cover,
                              ),
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
                                      spacing: 8,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            minimumSize: .zero,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.genre.l,
                                            style: TextStyle(
                                              fontWeight: .bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            minimumSize: .zero,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              fontWeight: .bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: black2,
                                            foregroundColor: Colors.white,
                                            minimumSize: .zero,
                                            padding: .symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            album.tradeMethod.l,
                                            style: TextStyle(
                                              fontWeight: .bold,
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: .circular(12),
                                          ),
                                          color: black2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              spacing: 12,
                                              children: [
                                                CircleAvatar(
                                                  radius: 28,
                                                  backgroundColor: yellow
                                                      .withAlpha(82),

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
                                            color: Colors.black87,
                                            borderRadius: .circular(4),
                                          ),
                                          padding: .symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: .w500,
                                              fontSize: 15,
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: .circular(12),
                                  ),
                                  color: black2,
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
                                                overflow: .ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: .w500,
                                                  fontSize: 14,
                                                ),
                                              ),

                                              Text(
                                                NumberFormat(
                                                  '₩ #,###',
                                                ).format(album.price),
                                                overflow: .ellipsis,
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
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontWeight: .w500,
                                                fontSize: 14,
                                              ),
                                            ),

                                            Text(
                                              album.tradeMethod.l,
                                              overflow: .ellipsis,
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
