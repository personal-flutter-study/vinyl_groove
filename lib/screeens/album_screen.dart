import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_13/models/album_model.dart';
import 'package:vinyl_groove_poc_13/widgets/like_button.dart';

import '../main.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.id});

  final int id;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  AlbumModel? albumModel;
  late Map info;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      get(
        Uri.parse('http://${baseUrl}/products/${widget.id}'),
        headers: baseHeader,
      ).then((value) {
        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          albumModel = AlbumModel.from(body['data']);
          info = body['data'];
          setState(() {});
          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final album = albumModel;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
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
                          flexibleSpace: Container(
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [black, Colors.black26, Colors.black12],
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
                          pinned: true,
                        ),

                        SliverFillRemaining(
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
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
                                        crossAxisAlignment: .start,
                                        spacing: 8,
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
                                              fontWeight: .w500,
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
                                                fontSize: 12,
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
                                                fontSize: 12,
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
                                            shape: RoundedRectangleBorder(
                                              borderRadius: .circular(12),
                                            ),
                                            color: black2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Row(
                                                spacing: 12,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 28,
                                                    backgroundColor: yellow
                                                        .withAlpha(60),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: yellow,
                                                      size: 30,
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          .start,
                                                      spacing: 4,
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
                                                            color:
                                                                Colors.white60,
                                                            fontWeight: .w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
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
                                            decoration: BoxDecoration(
                                              color: Colors.black.withAlpha(
                                                180,
                                              ),
                                              borderRadius: .circular(8),
                                            ),
                                            padding: .symmetric(
                                              horizontal: 6,
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
                        message('앨범 구매', g: true);
                        message('앨범 구매', g: true);
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
