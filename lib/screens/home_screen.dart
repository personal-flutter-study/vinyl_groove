import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/screens/album_screen.dart';
import 'package:vinyl_groove_poc_1/screens/barcode_screen.dart';
import 'package:vinyl_groove_poc_1/widgets.dart';
import 'package:vinyl_groove_poc_1/widgets/like_button.dart';
import 'package:vinyl_groove_poc_1/widgets/record_widget.dart';

import '../main.dart';
import '../models/album_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController tab;

  final sr = TextEditingController();

  Sort sort = .popular;

  @override
  void initState() {
    tab = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Scaffold(
          appBar: appBar(context),
          resizeToAvoidBottomInset: false,
          backgroundColor: black,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 24,
                  children: [
                    TextField(
                      onTap: () {
                        appCtrl.page.value = 1;
                      },
                      controller: sr,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: .lerp(Colors.black, Colors.white, .05),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: .circular(12)),
                        prefixIcon: Icon(Icons.search, color: Colors.white60),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명, 아티스트 검색',
                        suffixIcon: IconButton(
                          onPressed: () {
                            context.go(BarcodeScreen());
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/barcode-scan.svg',
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ),

                    RecordWidget(),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          '장르별 둘러보기',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
                        ),

                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white60,
                          ),
                          onPressed: () {
                            appCtrl.page.value = 2;
                          },
                          child: Row(
                            spacing: 4,
                            mainAxisSize: .min,
                            children: [
                              Text('전체 보기', style: TextStyle(fontSize: 12)),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),

                    GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        mainAxisExtent: 64,
                      ),
                      shrinkWrap: true,
                      children: Genre.values
                          .where((element) => element.v.isNotEmpty)
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                appCtrl.genre = e;
                                appCtrl.page.value = 1;
                              },
                              child: Card(
                                shadowColor: Colors.white60,
                                color: Colors.black,
                                child: Column(
                                  mainAxisAlignment: .center,
                                  children: [
                                    e.i.icon(color: yellow, width: 28),

                                    Text(
                                      e.l,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            onTap: (value) {
                              setState(() {
                                sort = Sort.values[value];
                              });
                            },
                            unselectedLabelColor: Colors.white60,
                            indicatorSize: .tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            indicatorColor: yellow,
                            controller: tab,
                            padding: .zero,
                            isScrollable: true,
                            tabAlignment: .start,
                            labelStyle: TextStyle(fontSize: 16),
                            labelPadding: .symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            tabs: [
                              Tab(text: '인기 매물'),
                              Tab(text: '최신 등록'),
                              Tab(text: '가격 인하'),
                            ],
                          ),
                        ),

                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white60,
                          ),
                          onPressed: () {},
                          child: Row(
                            spacing: 4,
                            mainAxisSize: .min,
                            children: [
                              Text('전체 보기', style: TextStyle(fontSize: 12)),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              FutureBuilder<Map?>(
                future: appCtrl.loadAlbums(sort: sort.v, size: 10),
                builder: (context, asyncSnapshot) {
                  final data = asyncSnapshot.data;

                  if (data == null) {
                    return Center(
                      child: Text(
                        'no results',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: .horizontal,
                    padding: .symmetric(horizontal: 12),
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Row(
                      spacing: 12,
                      children: (data['data'] as List<AlbumModel>).map((e) {
                        bool isPressed = false;

                        return GestureDetector(
                          onTap: () {
                            context.go(AlbumScreen(albumModel: e));
                          },
                          child: Container(
                            width: 160,
                            height: 240,
                            clipBehavior: .antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: .circular(12),
                              color: .lerp(Colors.black, Colors.white, .2),
                            ),
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 4,
                              children: [
                                SizedBox(
                                  height: 140,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          e.albumImage,
                                          fit: .cover,
                                        ),
                                      ),

                                      Align(
                                        alignment: .topRight,
                                        child: LikeButton(albumModel: e),
                                      ),

                                      Align(
                                        alignment: .bottomLeft,
                                        child: Card(
                                          margin: .all(8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: .circular(4),
                                          ),
                                          color: Colors.black54,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              e.condition,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    spacing: 4,
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
                                        e.artist,
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),

                                      Text(
                                        '₩ ${NumberFormat('###,###').format(e.price)}',
                                        style: TextStyle(
                                          color: yellow,
                                          fontWeight: .bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
