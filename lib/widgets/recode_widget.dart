import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';
import 'package:vinyl_groove_poc_2/models/album_model.dart';
import 'package:vinyl_groove_poc_2/screens/album_screen.dart';

import '../main.dart';

class RecodeWidget extends StatefulWidget {
  const RecodeWidget({super.key});

  @override
  State<RecodeWidget> createState() => _RecodeWidgetState();
}

class _RecodeWidgetState extends State<RecodeWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  List<AlbumModel> albums = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final res = await appCtrl.loadStores(limit: 5, sort: Sort.popular.v);

      if (res != null) {
        albums = res['data'];
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double angle = 0;

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: black3,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 4,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: yellow,
                    minimumSize: .zero,
                    padding: .symmetric(vertical: 8, horizontal: 12),
                    side: BorderSide(color: yellow),
                  ),
                  onPressed: () {},
                  child: Text(
                    '오늘의 추천 바이닐',
                    style: TextStyle(fontWeight: .bold, fontSize: 12),
                  ),
                ),

                Text(
                  textAlign: .center,
                  '오늘, 이 바이닐은\n어떠세요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: .bold,
                    fontSize: 20,
                  ),
                ),

                Text(
                  '매일 새롭게 선별한 특별한 한 장',
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),

            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 400),
              height: _controller.isAnimating ? 380 : 300,
              child: PageView(
                onPageChanged: (value) {
                  _controller.stop();
                  setState(() {
                    angle = pi / 8;
                    page = value;
                  });
                },
                children: albums
                    .map(
                      (e) => SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            GestureDetector(
                              onVerticalDragUpdate: (details) {
                                angle = (angle - details.delta.dy * .01).clamp(
                                  -pi / 4,
                                  pi / 8,
                                );
                                setState(() {});
                              },
                              onVerticalDragEnd: (details) {
                                if (angle < pi / 16) {
                                  if (!_controller.isAnimating) {
                                    _controller.repeat();
                                    setState(() {});
                                  }
                                } else {
                                  _controller.stop();
                                  setState(() {});
                                }
                              },
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/turntable.png',
                                      width: 300,
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment(-.1, -.125),
                                      child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: _controller.value * pi * 2,
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                shape: .circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/vinyl.png',
                                                  ),
                                                ),
                                              ),
                                              alignment: Alignment(0, 0),
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

                                  Align(
                                    alignment: Alignment(.8, .8),
                                    child: Transform.rotate(
                                      alignment: Alignment(.6, 0),
                                      angle: angle,
                                      child: Image.asset(
                                        'assets/tonearm.png',
                                        width: 200,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            AnimatedOpacity(
                              duration: Duration(milliseconds: 400),
                              opacity: _controller.isAnimating ? 1.0 : 0,
                              curve: Curves.easeInOut,

                              child: Material(
                                type: .transparency,
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
                                          width: 60,
                                          height: 60,
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
                                              ),
                                            ),
                                            Text(
                                              e.artist,
                                              style: TextStyle(color: yellow),
                                            ),
                                            Text(
                                              '${e.genre.l} • ${e.condition}',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 18,
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
              spacing: 4,
              mainAxisAlignment: .center,
              children: List.generate(albums.length, (index) {
                final act = page == index;
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
