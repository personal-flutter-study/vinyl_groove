import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_7/main.dart';
import 'package:vinyl_groove_poc_7/screens/album_screen.dart';

import '../app_ctrl.dart';
import '../models/album_model.dart';

class RecodeWidget extends StatefulWidget {
  const RecodeWidget({super.key});

  @override
  State<RecodeWidget> createState() => _RecodeWidgetState();
}

class _RecodeWidgetState extends State<RecodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<AlbumModel> albums = [];

  double angle = pi / 8;
  int page = 0;

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 5, sort: Sort.popular);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      load();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: black2,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 4,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black2,
                    foregroundColor: yellow,
                    side: BorderSide(color: yellow),
                    padding: .symmetric(vertical: 8, horizontal: 16),
                    minimumSize: .zero,
                  ),
                  onPressed: () {},
                  child: Text(
                    '오늘의 추천 바이닐',
                    style: TextStyle(fontWeight: .bold, fontSize: 12),
                  ),
                ),

                Text(
                  '오늘, 이 바이닐은\n어떠세요?',
                  textAlign: .center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: .bold,
                  ),
                ),

                Text(
                  '매일 새롭게 선별한 특별한 한 장',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),

            AnimatedContainer(
              curve: Curves.decelerate,
              duration: Duration(milliseconds: 350),
              height: _controller.isAnimating ? 380 : 300,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    _controller.stop();
                    page = value;
                    angle = pi / 8;
                  });
                },
                children: albums
                    .map(
                      (e) => SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onVerticalDragUpdate: (details) {
                                setState(() {
                                  angle = (angle - details.delta.dy * .01)
                                      .clamp(-pi / 8, pi / 8);
                                });
                              },
                              onVerticalDragEnd: (details) {
                                setState(() {
                                  if (angle <= pi / 16) {
                                    _controller.repeat();
                                  } else {
                                    _controller.stop();
                                  }
                                });
                              },
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/turntable.png',
                                      fit: .cover,
                                      width: 300,
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment(-.05, -.15),
                                      child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: _controller.value * pi * 2,
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/vinyl.png',
                                                  ),
                                                ),
                                              ),

                                              alignment: .center,
                                              child: CircleAvatar(
                                                radius: 38,
                                                backgroundImage: NetworkImage(
                                                  e.albumImage,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment(.6, -.9),
                                      child: Transform.rotate(
                                        alignment: Alignment(.6, 0),
                                        angle: angle,
                                        child: Image.asset(
                                          'assets/tonearm.png',
                                          width: 180,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AnimatedOpacity(
                              duration: Duration(milliseconds: 800),
                              curve: Curves.decelerate,
                              opacity: _controller.isAnimating ? 1 : 0,
                              child: Material(
                                color: black2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
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
                                          height: 64,
                                          width: 64,
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
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              e.artist,
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: yellow,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              '${e.genre.v} • ${e.condition}',
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white60,
                                          size: 16,
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
                    )
                    .toList(),
              ),
            ),

            Row(
              mainAxisAlignment: .center,
              spacing: 8,
              children: List.generate(albums.length, (index) {
                final act = index == page;

                return Container(
                  width: act ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: .circular(99),
                    color: act ? yellow : Colors.white24,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
