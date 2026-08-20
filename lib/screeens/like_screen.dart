import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_13/app_ctrl.dart';
import 'package:vinyl_groove_poc_13/models/album_model.dart';
import 'package:vinyl_groove_poc_13/widgets/like_button.dart';

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

  delete() {
    appCtrl.likes.removeWhere((element) => deletes.contains(element));
    appCtrl.save();
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
                      spacing: 12,
                      mainAxisSize: .min,
                      children: [
                        AppIcon.heart.icon(color: Colors.white60, size: 72),

                        Text(
                          '관심 상품이 없습니다.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
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
                : ListView(
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
                                  x = (x + details.delta.dx).clamp(-180, 0);
                                });
                              },
                              onHorizontalDragEnd: (details) {
                                if (x < -120) {
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
                                                  onPressed: () {
                                                    appCtrl.likes.add(e);
                                                    appCtrl.save();
                                                    if (mounted)
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
                                          size: 42,
                                        ),
                                      ),
                                    ),
                                  ),

                                  AnimatedSlide(
                                    duration: Duration(milliseconds: 100),
                                    offset: .new(x / 220, 0),
                                    child: Material(
                                      color: black,
                                      child: InkWell(
                                        onTap: () async {
                                          delete();
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
                                                  width: 82,
                                                  height: 82,
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
                                                        fontWeight: .bold,
                                                        fontSize: 15,
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
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                      180,
                                                                    ),
                                                                borderRadius:
                                                                    .circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                          padding: .symmetric(
                                                            horizontal: 6,
                                                            vertical: 4,
                                                          ),
                                                          child: Text(
                                                            e.condition,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight: .w500,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),

                                                        Text(
                                                          '${e.genre.l}',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white30,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Column(
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
      },
    );
  }
}
