import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_8/app_ctrl.dart';
import 'package:vinyl_groove_poc_8/models/album_model.dart';
import 'package:vinyl_groove_poc_8/widgets/like_button.dart';

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

  delete() async {
    appCtrl.likes.removeWhere((element) => deletes.contains(element));
    await appCtrl.save();
  }

  @override
  void initState() {
    _listener = AppLifecycleListener(
      onPause: () {
        delete();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    delete();
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
        body: appCtrl.likes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: .center,
                  spacing: 12,
                  children: [
                    AppIcon.heart.icon(color: Colors.white60, size: 72),

                    Text(
                      '관심 상품이 없습니다.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontWeight: .bold,
                        fontSize: 16,
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
                spacing: 16,
                crossAxisAlignment: .start,
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
                              x = (x + details.delta.dx).clamp(-120, 0);
                            });
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

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${e.albumName}을(를)\n관심 목록에서 삭제했습니다.',
                                            ),
                                            action: SnackBarAction(
                                              label: '실행 취소',
                                              textColor: yellow,
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
                                  alignment: .centerRight,
                                  color: Colors.red,
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
                                  clipBehavior: .antiAlias,
                                  child: InkWell(
                                    onTap: () async {
                                      context.go(AlbumScreen(id: e.id));
                                      delete();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        spacing: 12,
                                        children: [
                                          ClipRRect(
                                            clipBehavior: .antiAlias,
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
                                                  overflow: .ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: .bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  e.artist,
                                                  overflow: .ellipsis,

                                                  style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 14,
                                                  ),
                                                ),

                                                Row(
                                                  spacing: 8,
                                                  children: [
                                                    Container(
                                                      padding: .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black87,
                                                        borderRadius: .circular(
                                                          4,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        e.condition,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: .w500,
                                                        ),
                                                      ),
                                                    ),

                                                    Text(
                                                      e.genre.l,
                                                      style: TextStyle(
                                                        color: Colors.white38,
                                                        fontWeight: .w500,
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
                                                  color: Colors.white30,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),

                                          LikeButton(
                                            albumModel: e,
                                            fav: !dis,
                                            act: () {
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
    );
  }
}
