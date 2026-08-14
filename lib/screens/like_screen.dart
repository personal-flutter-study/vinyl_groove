import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/models/album_model.dart';
import 'package:vinyl_groove_poc_3/screens/album_screen.dart';
import 'package:vinyl_groove_poc_3/widgets/like_button.dart';

import '../main.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  List<AlbumModel> deletes = [];

  @override
  void dispose() {
    appCtrl.likes.removeWhere((element) => deletes.contains(element));
    appCtrl.save();

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
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: appCtrl.likes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    spacing: 12,
                    children: [
                      AppIcon.heart.icon(size: 72, color: Colors.white60),

                      Text(
                        '관심 상품이 없습니다.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 18,
                          fontWeight: .bold,
                        ),
                      ),

                      Text(
                        '마음에 드는 상품에 하트를 눌러보세요.',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: .start,
                  spacing: 16,
                  children: appCtrl.likes.map((e) {
                    double x = 0;

                    final dis = deletes.contains(e);

                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: dis ? .6 : 1,
                      child: StatefulBuilder(
                        builder: (context, setState2) {
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  padding: .all(12),
                                  color: Colors.red,
                                  alignment: .centerRight,
                                  child: AppIcon.delete.icon(
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  setState2(() {
                                    x = (x + details.delta.dx).clamp(-120, 0);
                                  });
                                },

                                onTap: () {
                                  context.go(AlbumScreen(id: e.id));
                                },
                                onHorizontalDragEnd: (details) {
                                  if (x <= -100) {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                        title: Text('관심 상품 삭제'),
                                        actions: [
                                          CupertinoButton(
                                            child: Text('취소'),
                                            onPressed: () {
                                              context.back();
                                              setState(() {});
                                            },
                                          ),
                                          CupertinoButton(
                                            child: Text('삭제'),
                                            onPressed: () {
                                              appCtrl.likes.remove(e);
                                              appCtrl.save();

                                              setState(() {});

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${e.albumName}을(를)\n관심 목록에서 삭제했습니다.',
                                                  ),
                                                  action: SnackBarAction(
                                                    label: '실행 취소',
                                                    onPressed: () {
                                                      appCtrl.likes.add(e);
                                                      appCtrl.save();
                                                      setState(() {});
                                                    },
                                                    textColor: yellow,
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
                                },
                                child: Transform.translate(
                                  offset: .new(x, 0),
                                  child: Material(
                                    color: black,
                                    child: Row(
                                      spacing: 12,
                                      children: [
                                        ClipRRect(
                                          borderRadius: .circular(12),
                                          child: Image.network(
                                            e.albumImage,
                                            width: 72,
                                            height: 72,
                                            fit: .cover,
                                          ),
                                        ),

                                        Expanded(
                                          child: Column(
                                            spacing: 4,
                                            crossAxisAlignment: .start,
                                            children: [
                                              Text(
                                                e.albumName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: .bold,
                                                ),
                                              ),
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
                                                    margin: .zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              .circular(4),
                                                        ),
                                                    color: Colors.black54,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 6.0,
                                                            vertical: 4,
                                                          ),
                                                      child: Text(
                                                        e.condition,
                                                        style: TextStyle(
                                                          fontWeight: .bold,
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Text(
                                                    e.genre.l,
                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Column(
                                          spacing: 4,
                                          crossAxisAlignment: .end,
                                          children: [
                                            Text(
                                              NumberFormat(
                                                '₩ #,###',
                                              ).format(e.price),
                                              style: TextStyle(
                                                color: yellow,
                                                fontWeight: .bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              e.tradeMethod.l,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),

                                        LikeButton(
                                          albumModel: e,
                                          fav: !dis,
                                          action: () {
                                            setState(() {
                                            if (!deletes.remove(e)) {
                                                deletes.add(e);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
