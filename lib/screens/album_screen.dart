import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/main.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';

import '../widgets/like_button.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.albumModel});

  final AlbumModel albumModel;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Map? detail;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      detail = appCtrl.loadAlbumDetail(widget.albumModel.id);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.albumModel;

    final detail = this.detail;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    leading: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        context.back();
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    actions: [LikeButton(albumModel: widget.albumModel)],
                    expandedHeight: 300,
                    flexibleSpace: Image.network(
                      album.albumImage,
                      fit: .cover,
                      height: 400,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        if (detail == null) {
                          return Center(child: Text('no results'));
                        }

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: .start,
                            spacing: 16,
                            children: [
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    album.albumName,
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),

                                  Text(
                                    album.artist,
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                spacing: 8,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: .zero,
                                      padding: .symmetric(
                                        vertical: 6,
                                        horizontal: 12,
                                      ),
                                      backgroundColor: .lerp(
                                        Colors.black,
                                        Colors.white,
                                        .1,
                                      ),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      album.genre,
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: .zero,
                                      padding: .symmetric(
                                        vertical: 6,
                                        horizontal: 12,
                                      ),
                                      backgroundColor: .lerp(
                                        Colors.black,
                                        Colors.white,
                                        .1,
                                      ),
                                      foregroundColor: Colors.white,
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
                                      minimumSize: .zero,
                                      padding: .symmetric(
                                        vertical: 6,
                                        horizontal: 12,
                                      ),
                                      backgroundColor: .lerp(
                                        Colors.black,
                                        Colors.white,
                                        .1,
                                      ),
                                      foregroundColor: Colors.white,
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
                                  final seller = detail['seller'];

                                  if (seller == null) {
                                    return Center(
                                      child: Text(
                                        'no results',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }

                                  /*"seller": {
                                  "id": 10,
                                  "name": "Analog Shop",
                                  "email": "analog@example.com",
                                  "profileImage": "https://api.vinylgroove.com/images/profile/seller010.jpg"
                                  },*/

                                  return ListTile(
                                    contentPadding: .all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: .circular(12),
                                    ),
                                    tileColor: .lerp(
                                      Colors.black,
                                      Colors.white,
                                      .1,
                                    ),
                                    leading: CircleAvatar(
                                      radius: 32,
                                      backgroundColor: yellow.withAlpha(100),
                                      child: Icon(
                                        Icons.person,
                                        color: yellow,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      seller['name'],
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      seller['email'],
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 12,
                                        color: Colors.white60,
                                      ),
                                    ),

                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.white60,
                                    ),
                                  );
                                },
                              ),

                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '상태 등급',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: .bold,
                                          fontSize: 16,
                                        ),
                                      ),

                                      Card(
                                        margin: .all(8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: .circular(4),
                                        ),
                                        color: Colors.black54,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            album.condition,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: .bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    overflow: .ellipsis,
                                    detail['conditionDescription'],
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '상품 설명',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: .bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    overflow: .ellipsis,
                                    detail['description'],
                                    style: TextStyle(color: Colors.white60),
                                  ),

                                  SizedBox(),
                                  ListTile(
                                    contentPadding: .all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: .circular(12),
                                    ),
                                    tileColor: .lerp(
                                      Colors.black,
                                      Colors.white,
                                      .1,
                                    ),

                                    leading: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text(
                                          '가격',
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 14,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        Text(
                                          "\₩ ${NumberFormat('###,###').format(album.price)}",
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 24,
                                            color: yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: .end,
                                      children: [
                                        Text(
                                          '거래 방식',
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 14,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        Text(
                                          album.tradeMethod.l,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: .lerp(Colors.black, Colors.white, .1),
              padding: .all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellow,
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  padding: .symmetric(vertical: 16),
                ),
                onPressed: () async {
                  context.message('구배하기는 준비중 입니다.');
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      '구매하기',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: .bold,
                      ),
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
