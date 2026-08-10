import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/main.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';

class RecordWidget extends StatefulWidget {
  const RecordWidget({super.key});

  @override
  State<RecordWidget> createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget>
    with TickerProviderStateMixin {
  List<AlbumModel> albums = [];

  late final AnimationController controller;
  double angle = 0;

  int page = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      appCtrl.loadAlbums(sort: Sort.popular, limit: 5).then((value) {
        if (value == null) return;
        albums = (value['data'] as List<AlbumModel>).take(5).toList();

        if (mounted) setState(() {});
      });
    });
    super.initState();
  }

  double y = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: blackAccent,

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceOut,
              height: controller.isAnimating ? 550 : 450,
              child: PageView(
                onPageChanged: (value) {
                  angle = 0;
                  controller.stop();
                  setState(() {
                    page = value;
                  });
                },
                children: albums
                    .map(
                      (e) => SingleChildScrollView(
                        child: Column(
                          spacing: 16,
                          children: [
                            Column(
                              spacing: 4,
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: yellow),
                                    minimumSize: .zero,
                                    padding: .symmetric(
                                      vertical: 4,
                                      horizontal: 12,
                                    ),
                                  ),
                                  onPressed: () async {},
                                  child: Text(
                                    '오늘의 추천 바이닐',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: yellow,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ),

                                Text(
                                  textAlign: .center,
                                  '오늘, 이 바이닐은\n어떠세요?',
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '매일 새롭게 선별한 특별한 한 장',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            GestureDetector(
                              onVerticalDragUpdate: (details) {
                                angle = (angle - details.delta.dy * .01).clamp(
                                  -1,
                                  .5,
                                );
                                setState(() {});
                                if (angle <= .2 && !controller.isAnimating) {
                                  controller.repeat();
                                } else if (controller.isAnimating) {
                                  controller.stop();
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
                                    bottom: 12,
                                    right: 12,
                                    child: AnimatedBuilder(
                                      animation: controller,
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: controller.value * pi * 2,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Image.asset(
                                                  'assets/vinyl.png',
                                                  width: 220,
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  clipBehavior: .hardEdge,
                                                  width: 88,
                                                  height: 88,
                                                  decoration: BoxDecoration(
                                                    shape: .circle,
                                                    image: DecorationImage(
                                                      fit: .fill,
                                                      image: NetworkImage(
                                                        e.albumImage,
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
                                  ),

                                  Align(
                                    alignment: Alignment(.7, 0),
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

                            AnimatedOpacity(
                              curve: Curves.bounceOut,
                              opacity: controller.isAnimating ? 1 : 0,
                              duration: Duration(milliseconds: 300),
                              child: Row(
                                spacing: 12,
                                children: [
                                  ClipRRect(
                                    borderRadius: .circular(12),
                                    child: SizedBox.square(
                                      dimension: 68,
                                      child: Image.network(
                                        e.albumImage,
                                        fit: .cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: .zero,
                                      title: Text(
                                        e.albumName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: .bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            e.artist,
                                            style: TextStyle(
                                              color: yellow,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '${e.genre} • ${e.genre}',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),

                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white60,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
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
              spacing: 4,
              children: .generate(5, (index) {
                final act = index == page;
                return Container(
                  height: 6,
                  width: act ? 24 : 6,
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
