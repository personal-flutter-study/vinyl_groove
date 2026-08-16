import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_2/models/album_model.dart';
import 'package:vinyl_groove_poc_2/widgets/like_button.dart';

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

          print(body);

          if (value.statusCode == 200) {
            album = AlbumModel.from(body['data']);
            info = body['data'];
            setState(() {});
            return body;
          }
        } catch (e) {
          print(e);
        }
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
        resizeToAvoidBottomInset: false,
        body: album == null
            ? Center(
                child: Text(
                  'no results',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    actions: [LikeButton(albumModel: album, size: 24)],
                    expandedHeight: 280,
                    flexibleSpace: Container(
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [black, Colors.black12, Colors.black12],
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
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.back();
                      },
                      icon: Icon(Icons.arrow_back),
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
                                style: TextStyle(color: Colors.white60),
                              ),
                            ],
                          ),

                          Row(
                            spacing: 8,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: black3,
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
                                  foregroundColor: Colors.white,
                                  backgroundColor: black3,
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
                                  foregroundColor: Colors.white,
                                  backgroundColor: black3,
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

                              return ListTile(
                                contentPadding: .all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                tileColor: black3,
                                leading: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: yellow.withAlpha(100),
                                  child: Icon(
                                    Icons.person,
                                    color: yellow,
                                    size: 32,
                                  ),
                                ),

                                title: Text(
                                  seller['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: .bold,
                                    fontSize: 18,
                                  ),
                                ),

                                subtitle: Text(
                                  seller['email'],
                                  style: TextStyle(color: Colors.white60),
                                ),

                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              );
                            },
                          ),

                          Builder(
                            builder: (context) {
                              final con = ConD.values
                                  .where(
                                    (element) => element.v == album.condition,
                                  )
                                  .first;

                              return Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '상태 등급',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: .bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: .circular(8),
                                        ),
                                        color: Colors.black54,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            con.v,
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
                                    con.l,
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                ],
                              );
                            },
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

                          ListTile(
                            contentPadding: .all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(12),
                            ),
                            tileColor: black3,

                            title: Column(
                              crossAxisAlignment: .start,

                              children: [
                                Text(
                                  '가격',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),

                                Text(
                                  '₩ ${NumberFormat('#,###').format(info['price'])}',
                                  style: TextStyle(
                                    color: yellow,
                                    fontWeight: .bold,
                                    fontSize: 20,
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
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),

                                Text(
                                  album.tradeMethod.l,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                padding: .symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                message('앨범 구매는 준비중에 있습니다.');
                              },
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    '구배하기',
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      fontSize: 16,
                                    ),
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
    );
  }
}

enum ConD {
  SS('SS', '미개봉 새상품. 완벽한 상태입니다.'),
  M('M', 'Mint. 개봉했으나 새것과 다름없는 완벽한 상태입니다.'),
  NM('NM', 'Near Mint. 거의 새것에 가까운 상태로, 미세한 사용감만 있습니다.'),
  EX('EX', 'Excellent. 전체적으로 깨끗하며, 약간의 사용감이 있습니다.'),
  VG_P('VG+', 'Very Good Plus. 양호한 상태로, 재생에 문제가 없습니다.'),
  VG('VG', 'Very Good. 사용감이 있으나 재생에 큰 문제가 없습니다.'),
  G('G', 'Good. 사용감이 많으나 재생은 가능합니다');

  final String v;
  final String l;

  const ConD(this.v, this.l);
}
