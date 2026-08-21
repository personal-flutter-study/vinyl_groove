import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_14/app_ctrl.dart';

import '../main.dart';
import 'album_screen.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker,
      builder: (context, _, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                '관심 상품',
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: black,
            body: appCtrl.likes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: .min,
                      spacing: 12,
                      children: [
                        AppIcon.heart.icon(color: Colors.white38, size: 72),

                        Text(
                          '관심 상품이 없습니다.',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                            fontWeight: .bold,
                          ),
                        ),

                        Text(
                          '마음에 드는 상품에 하트를 눌러보세요.',
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: appCtrl.likes.map((e) {
                      double x = 0;

                      return StatefulBuilder(
                        builder: (context, setState2) {
                          return GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState2(() {
                                x = (x + details.delta.dx).clamp(-180, 0);
                              });
                            },
                            onHorizontalDragEnd: (details) {
                              if (x <= -160) {
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

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${e.albumName}을(를)\n관심 목록에서 삭제했습니다.',
                                              ),
                                              action: SnackBarAction(
                                                textColor: yellow,
                                                label: '실행 취소',
                                                onPressed: () {
                                                  appCtrl.likes.add(e);
                                                  appCtrl.save();
                                                },
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
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.red,
                                    alignment: .centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AppIcon.delete.icon(
                                        color: Colors.white,
                                        size: 72,
                                      ),
                                    ),
                                  ),
                                ),

                                AnimatedSlide(
                                  duration: Duration(milliseconds: 100),
                                  offset: .new(x / 220, 0),
                                  child: Material(
                                    clipBehavior: .antiAlias,
                                    color: black,
                                    child: InkWell(
                                      onTap: () {
                                        context.go(AlbumScreen(id: e.id));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          spacing: 12,
                                          children: [
                                            ClipRRect(
                                              borderRadius: .circular(12),
                                              child: Image.network(
                                                e.albumImage,
                                                fit: .cover,
                                                width: 72,
                                                height: 72,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => SizedBox(),
                                              ),
                                            ),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: .start,
                                                spacing: 4,
                                                children: [
                                                  Text(
                                                    e.albumName,
                                                    overflow: .ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: .bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    e.artist,
                                                    overflow: .ellipsis,

                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Row(
                                                    spacing: 8,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                                  .circular(6),
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                    180,
                                                                  ),
                                                            ),
                                                        padding: .symmetric(
                                                          horizontal: 6,
                                                          vertical: 4,
                                                        ),
                                                        child: Text(
                                                          e.condition,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: .w500,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${e.genre.l}',
                                                        overflow: .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.white30,
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
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  e.tradeMethod.l,
                                                  style: TextStyle(
                                                    color: Colors.white30,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
        );
      },
    );
  }
}
