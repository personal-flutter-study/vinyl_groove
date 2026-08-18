import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_10/main.dart';
import 'package:vinyl_groove_poc_10/screens/album_screen.dart';

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

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 5, sort: Sort.popular.v);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  late final AnimationController controller;

  double angle = pi / 8;
  int page = 0;

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

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      color: black2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              spacing: 4,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black2,
                    foregroundColor: yellow,
                    minimumSize: .zero,
                    side: BorderSide(color: yellow),
                    padding: .symmetric(vertical: 8, horizontal: 16),
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
                    fontWeight: .bold,
                    fontSize: 24,
                  ),
                ),

                Text(
                  '매일 새롭게 선별한 특별한 한 장',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: AnimatedContainer(
                curve: Curves.easeInOutCubic,
                height: controller.isAnimating ? 380 : 300,
                duration: Duration(milliseconds: 250),
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
                                      controller.repeat();
                                    } else {
                                      controller.stop();
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
                                        alignment: Alignment(-.1, -.1),
                                        child: AnimatedBuilder(
                                          animation: controller,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle: controller.value * pi * 2,
                                              child: Container(
                                                width: 210,
                                                height: 210,
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
                                        alignment: Alignment(.7, -.9),
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

                              ClipRect(
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeInOutCubic,
                                  opacity: controller.isAnimating ? 1 : .2,
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: .circular(12),
                                    ),
                                    color: black2,
                                    child: InkWell(
                                      onTap: () {
                                        context.go(AlbumScreen(id: e.id));
                                      },
                                      child: Row(
                                        spacing: 12,
                                        children: [
                                          AnimatedSlide(
                                            duration: Duration(
                                              milliseconds: 250,
                                            ),
                                            offset: controller.isAnimating
                                                ? .zero
                                                : .new(0, -.4),
                                            child: ClipRRect(
                                              borderRadius: .circular(12),
                                              child: Image.network(
                                                e.albumImage,
                                                width: 64,
                                                height: 64,
                                                fit: .cover,
                                              ),
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
                                                    color: yellow,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  '${e.genre.l} • ${e.condition}',
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
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            Row(
              spacing: 8,
              mainAxisAlignment: .center,
              children: List.generate(albums.length, (index) {
                final act = page == index;
                return Container(
                  height: 8,
                  width: act ? 18 : 8,
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
