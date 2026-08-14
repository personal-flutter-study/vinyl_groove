import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/main.dart';
import 'package:vinyl_groove_poc_3/models/album_model.dart';
import 'package:vinyl_groove_poc_3/screens/album_screen.dart';

class RecodeWidget extends StatefulWidget {
  const RecodeWidget({super.key});

  @override
  State<RecodeWidget> createState() => _RecodeWidgetState();
}

class _RecodeWidgetState extends State<RecodeWidget>
    with TickerProviderStateMixin {
  List<AlbumModel> albums = [];

  late final AnimationController controller;

  int page = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final res = await appCtrl.loadStores(limit: 5, sort: Sort.popular);

      if (res != null) {
        albums = res['data'];
        if (mounted) setState(() {});
      }
    });
    super.initState();
  }

  double angle = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      color: black3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            Column(
              spacing: 4,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: yellow,
                    padding: .symmetric(vertical: 8, horizontal: 12),
                    minimumSize: .zero,
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
                    fontSize: 22,
                  ),
                ),

                Text(
                  '매일 새롭게 선별한 특별한 한 장',
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),

            AnimatedContainer(
              height: controller.isAnimating ? 380 : 300,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    setState(() {
                      angle = pi / 8;
                      controller.stop();
                      page = value;
                    });
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
                                if (angle < pi / 18) {
                                  controller.repeat();
                                } else {
                                  controller.stop();
                                }

                                setState(() {});
                              },
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/turntable.png',
                                      width: 300,
                                      fit: .fitWidth,
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment(-.05, -.12),
                                      child: AnimatedBuilder(
                                        animation: controller,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: controller.value * pi * 2,
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
                                    alignment: Alignment(.6, .8),
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
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              opacity: controller.isAnimating ? 1 : 0,
                              child: InkWell(
                                onTap: () {
                                  context.go(AlbumScreen(id: e.id));
                                },
                                child: Material(
                                  type: .transparency,
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
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SizedBox(),
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              overflow: .ellipsis,
                                              e.albumName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                            Text(
                                              overflow: .ellipsis,

                                              e.artist,
                                              style: TextStyle(color: yellow),
                                            ),
                                            Text(
                                              overflow: .ellipsis,

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
                                        size: 18,
                                        color: Colors.white,
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
                  width: act ? 16 : 8,
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
