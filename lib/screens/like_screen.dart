import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';

import '../main.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  List<AlbumModel> temps = [];

  @override
  void dispose() {
    appCtrl.likes.removeWhere((element) => temps.contains(element));
    prefs.setStringList(
      lsk,
      appCtrl.likes.map((e) => jsonEncode(e.toJson())).toList(),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            '관심 상품',
            style: TextStyle(fontWeight: .bold, color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: ValueListenableBuilder(
          valueListenable: appCtrl.ticker,
          builder: (context, value, child) {
            return appCtrl.likes.isEmpty
                ? Center(
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.white60,
                          size: 72,
                        ),

                        Text(
                          '관심 상품이 없습니다.',
                          style: TextStyle(
                            fontWeight: .bold,
                            color: Colors.white60,
                          ),
                        ),

                        Text(
                          '마음에 드는 상품에 하트를 눌러보세요.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 16,
                        children: appCtrl.likes.map((e) {
                          double x = 0;
                          final delete = temps.contains(e);
                          return Opacity(
                            opacity: delete ? .4 : 1,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    padding: .all(16),
                                    color: Colors.red,
                                    alignment: .centerRight,
                                    child: AppIcon.delete.icon(
                                      color: Colors.white,
                                      width: 24,
                                    ),
                                  ),
                                ),

                                StatefulBuilder(
                                  builder: (context, setState2) {
                                    return GestureDetector(
                                      onHorizontalDragUpdate: (details) {
                                        setState2(() {
                                          x = (x + details.delta.dx).clamp(
                                            -120,
                                            0,
                                          );

                                          if (x <= -110) {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) => CupertinoAlertDialog(
                                                title: Text('관심 상품 삭제'),
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
                                                      appCtrl.likes.remove(e);
                                                      await prefs.setStringList(
                                                        lsk,
                                                        appCtrl.likes
                                                            .map(
                                                              (e) => jsonEncode(
                                                                e.toJson(),
                                                              ),
                                                            )
                                                            .toList(),
                                                      );

                                                      setState(() {});

                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          action: SnackBarAction(
                                                            label: '실행 취소',
                                                            onPressed: () async {
                                                              appCtrl.likes.add(
                                                                e,
                                                              );
                                                              await prefs.setStringList(
                                                                lsk,
                                                                appCtrl.likes
                                                                    .map(
                                                                      (
                                                                        e,
                                                                      ) => jsonEncode(
                                                                        e.toJson(),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                              );

                                                              setState(() {});
                                                            },
                                                          ),
                                                          content: Text(
                                                            '${e.albumName}을(를) 관심 목록에서 삭제했습니다.',
                                                          ),
                                                        ),
                                                      );

                                                      context.back();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: Transform.translate(
                                        offset: Offset(x, 0),
                                        child: Material(
                                          color: black,
                                          child: Row(
                                            spacing: 8,
                                            children: [
                                              ClipRRect(
                                                borderRadius: .circular(12),
                                                child: SizedBox.square(
                                                  dimension: 80,
                                                  child: Image.network(
                                                    e.albumImage,
                                                    fit: .cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: .zero,
                                                  title: Text(
                                                    overflow: .ellipsis,
                                                    e.albumName,
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
                                                        e.artist,
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                        ),
                                                      ),
                                                      Row(
                                                        spacing: 8,
                                                        children: [
                                                          Card(
                                                            margin: .all(0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      .circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                            color:
                                                                Colors.black54,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    4,
                                                                  ),
                                                              child: Text(
                                                                e.condition,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          Text(
                                                            e.genre,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white60,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  trailing: Row(
                                                    mainAxisSize: .min,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            .end,
                                                        children: [
                                                          Text(
                                                            "\₩ ${NumberFormat('###,###').format(e.price)}",
                                                            style: TextStyle(
                                                              color: yellow,
                                                              fontWeight: .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            e.tradeMethod.l,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white60,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        style:
                                                            IconButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black54,
                                                            ),
                                                        onPressed: () async {
                                                          if (!temps.remove(e))
                                                            temps.add(e);
                                                          setState(() {});
                                                        },
                                                        icon: Icon(
                                                          appCtrl.likes
                                                                      .contains(
                                                                        e,
                                                                      ) &&
                                                                  !delete
                                                              ? Icons.favorite
                                                              : Icons
                                                                    .favorite_border,
                                                          color:
                                                              appCtrl.likes
                                                                      .contains(
                                                                        e,
                                                                      ) &&
                                                                  !delete
                                                              ? Colors.red
                                                              : Colors.white,
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
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
