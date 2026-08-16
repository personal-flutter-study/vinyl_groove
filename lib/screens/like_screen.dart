import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/models/album_model.dart';
import 'package:vinyl_groove_poc_2/widgets/like_button.dart';

import '../main.dart';
import 'album_screen.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  List<AlbumModel> deletes = [];
  late AppLifecycleListener _listener;

  @override
  void initState() {
    _listener = AppLifecycleListener(
      onPause: () {
        appCtrl.likes.removeWhere((element) => deletes.contains(element));
        appCtrl.save();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    appCtrl.likes.removeWhere((element) => deletes.contains(element));
    appCtrl.save();
    _listener.dispose();
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
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        backgroundColor: black,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: appCtrl.likes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    spacing: 12,
                    children: [
                      AppIcon.heart.icon(size: 80, color: Colors.white60),

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
                        style: TextStyle(color: Colors.white60, fontSize: 14),
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

                    return Opacity(
                      opacity: dis ? .6 : 1,
                      child: StatefulBuilder(
                        builder: (context, setState2) {
                          return GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState2(() {
                                x = (x + details.delta.dx).clamp(-100, 0);
                              });
                            },
                            onHorizontalDragEnd: (details) {
                              if (x < -80) {
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
                                          setState(() {
                                            appCtrl.likes.remove(e);
                                          });
                                          appCtrl.save();
                                          context.back();

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              action: SnackBarAction(
                                                label: '실행 취소',
                                                onPressed: () {
                                                  setState(() {
                                                    appCtrl.likes.add(e);
                                                  });
                                                  appCtrl.save();
                                                },
                                              ),
                                              content: Text(
                                                '${e.albumName}을(를)\n관심 목록에서 삭제했습니다.',
                                              ),
                                            ),
                                          );
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
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),

                                Transform.translate(
                                  offset: .new(x, 0),
                                  child: Material(
                                    color: black,
                                    child: InkWell(
                                      onTap: () {
                                        context.go(AlbumScreen(id: e.id));
                                      },
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
                                              crossAxisAlignment: .start,
                                              spacing: 4,
                                              children: [
                                                Text(
                                                  e.albumName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: .bold,
                                                    fontSize: 16,
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
                                                                .circular(2),
                                                          ),
                                                      color: Colors.black54,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              2.0,
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
                                            crossAxisAlignment: .end,
                                            children: [
                                              Text(
                                                '₩ ${NumberFormat('#,###').format(e.price)}',
                                                style: TextStyle(
                                                  color: yellow,
                                                  fontSize: 16,
                                                  fontWeight: .bold,
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
                                            act: () {
                                              if (!deletes.remove(e)) {
                                                deletes.add(e);
                                              }

                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
