import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_5/main.dart';
import 'package:vinyl_groove_poc_5/screens/album_screen.dart';

import '../app_ctrl.dart';
import '../models/album_model.dart';

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

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 5, sort: Sort.popular);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      load();
    });
    super.initState();
  }

  double angle = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: .antiAlias,
      borderRadius: .circular(12),
      color: black2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 6,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: yellow,
                    padding: .symmetric(vertical: 8, horizontal: 12),
                    side: BorderSide(color: yellow),
                    minimumSize: .zero,
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
                    fontSize: 24,
                    fontWeight: .bold,
                  ),
                ),
                Text(
                  '매일 새롭게 선별한 특별한 한 장',
                  style: TextStyle(color: Colors.white60, fontWeight: .w500),
                ),
              ],
            ),

            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeIn,
              height: controller.isAnimating ? 380 : 300,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    page = value;

                    controller.stop();

                    angle = pi / 8;
                  });
                },
                children: albums
                    .map(
                      (e) =>
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onVerticalDragUpdate: (details) {
                                setState(() {
                                  angle = (angle - details.delta.dy * .01)
                                      .clamp(-pi / 4, pi / 8);
                                });
                              },
                              onVerticalDragEnd: (details) {
                                if (angle < pi / 12) {
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
                                      fit: .fitWidth,
                                      width: 300,
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment(-.05, -.1),
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
                                      alignment: Alignment(.65, -.9),
                                      child: Transform.rotate(
                                        alignment: Alignment(.65, 0),
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

                            SizedBox(height: 8),

                            AnimatedOpacity(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                              opacity: controller.isAnimating ? 1 : 0,
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
                                          fit: .cover,
                                          width: 64,
                                          height: 64,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          spacing: 4,
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              e.albumName,
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: .bold,
                                                fontSize: 16,
                                              ),
                                            ),

                                            Text(
                                              e.artist,
                                              overflow: .ellipsis,
                                              style: TextStyle(color: yellow),
                                            ),
                                            Text(
                                              '${e.genre.l} • ${e.condition}',
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.white,
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
              spacing: 8,
              mainAxisAlignment: .center,
              children: List.generate(albums.length, (index) {
                final act = page == index;

                return Container(
                  height: 8,
                  width: act ? 16 : 8,
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
