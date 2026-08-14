import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_6/app_ctrl.dart';
import 'package:vinyl_groove_poc_6/main.dart';
import 'package:vinyl_groove_poc_6/screens/album_screen.dart';

import '../models/album_model.dart';

class RecodeWidget extends StatefulWidget {
  const RecodeWidget({super.key});

  @override
  State<RecodeWidget> createState() => _RecodeWidgetState();
}

class _RecodeWidgetState extends State<RecodeWidget>
    with TickerProviderStateMixin {
  List<AlbumModel> albums = [];

  int page = 0;
  double angle = pi / 8;

  late final AnimationController controller;

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(sort: Sort.popular, limit: 5);
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: black2,
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
                    padding: .symmetric(vertical: 6, horizontal: 16),
                    minimumSize: .zero,
                    side: BorderSide(color: yellow),
                  ),
                  onPressed: () {},
                  child: Text(
                    '오늘의 추천 바이닐',
                    style: TextStyle(fontWeight: .bold),
                  ),
                ),
                Text(
                  textAlign: .center,
                  '오늘, 이 바이닐은\n어떠세요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: .bold,
                    fontSize: 24,
                  ),
                ),

                Text(
                  '매일 새롭게 선별한 특별한 한 장',
                  style: TextStyle(color: Colors.white60, fontWeight: .w500),
                ),
              ],
            ),

            Column(
              children: [
                AnimatedContainer(
                  height: controller.isAnimating ? 380 : 300,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                  child: PageView(
                    onPageChanged: (value) {
                      setState(() {
                        angle = pi / 8;
                        controller.stop();
                        page = value;
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
                                          .clamp(-pi / 6, pi / 8);
                                    });
                                  },
                                  onVerticalDragEnd: (details) {
                                    setState(() {
                                      if (angle <= pi / 12) {
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
                                            builder: (context, child) =>
                                                Transform.rotate(
                                                  angle:
                                                      controller.value * pi * 2,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          'assets/vinyl.png',
                                                        ),
                                                        fit: .cover,
                                                      ),
                                                    ),
                                                    height: 200,
                                                    width: 200,
                                                    alignment: .center,
                                                    child: CircleAvatar(
                                                      radius: 38,
                                                      backgroundImage:
                                                          NetworkImage(
                                                            e.albumImage,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),

                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment(.75, -.9),
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
                                  opacity: controller.isAnimating ? 1 : 0,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
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
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  e.artist,
                                                  overflow: .ellipsis,
                                                  style: TextStyle(
                                                    color: yellow,
                                                    fontSize: 12,
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
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: .center,
              spacing: 8,
              children: List.generate(albums.length, (index) {
                final act = page == index;

                return Container(
                  height: 8,
                  width: act ? 18 : 8,
                  decoration: BoxDecoration(
                    color: act ? yellow : Colors.white24,
                    borderRadius: .circular(99),
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
