import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_4/models/album_model.dart';
import 'package:vinyl_groove_poc_4/widgets/like_button.dart';

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
      await get(
        Uri.parse('http://${baseUrl}/products/${widget.id}'),
        headers: baseHeader,
      ).then((value) {
        try {
          final body = jsonDecode(value.body);

          if (value.statusCode == 200) {
            album = AlbumModel.from(body['data']);
            info = body['data'];
            setState(() {});
            return body;
          }
          message((body['errors'] as List).first['message']);
        } catch (e) {
          print(e);
        }
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
                          actions: [LikeButton(albumModel: album, size: 28)],
                          expandedHeight: 300,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: Container(
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: .bottomCenter,
                                end: .topCenter,
                                colors: [black, Colors.black12, Colors.black12],
                              ),
                            ),
                            height: 500,
                            child: Image.network(
                              album.albumImage,
                              fit: .fitHeight,
                            ),
                          ),
                          leading: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            onPressed: () {
                              context.back();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
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
                                  spacing: 4,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      album.albumName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: .bold,
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
                                  spacing: 12,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: black2,
                                        foregroundColor: Colors.white,
                                        minimumSize: .zero,
                                        padding: .symmetric(
                                          vertical: 8,
                                          horizontal: 12,
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
                                          horizontal: 12,
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
                                          horizontal: 12,
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
                                        padding: const EdgeInsets.all(12.0),
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
                                                size: 28,
                                                color: yellow,
                                              ),
                                            ),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: .start,
                                                children: [
                                                  Text(
                                                    seller['name'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: .bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    seller['email'],
                                                    style: TextStyle(
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
                                                size: 18,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                                            vertical: 2,
                                            horizontal: 6,
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
                                      Con.values
                                          .where(
                                            (element) =>
                                                element.v == album.condition,
                                          )
                                          .first
                                          .l,
                                      style: TextStyle(color: Colors.white60),
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
                                                '기격',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              Text(
                                                NumberFormat(
                                                  '₩ #,###',
                                                ).format(album.price),
                                                style: TextStyle(
                                                  color: yellow,
                                                  fontSize: 20,
                                                  fontWeight: .bold,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(12),
                        ),
                        padding: .symmetric(vertical: 14),
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

enum Con {
  SS('SS', '미개봉 새상품. 완벽한 상태입니다.'),
  M('M', 'Mint. 개봉했으나 새것과 다름없는 완벽한 상태입니다.'),
  NM('NM', 'Near Mint. 거의 새것에 가까운 상태로, 미세한 사용감만 있습니다.'),
  EX('EX', 'Excellent. 전체적으로 깨끗하며, 약간의 사용감이 있습니다.'),
  VG_P('VG+', 'Very Good Plus. 양호한 상태로, 재생에 문제가 없습니다.'),
  VG('VG', 'Very Good. 사용감이 있으나 재생에 큰 문제가 없습니다.'),
  G('G', 'Good. 사용감이 많으나 재생은 가능합니다.');

  final String v;
  final String l;

  const Con(this.v, this.l);
}
