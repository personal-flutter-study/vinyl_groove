import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/models/album_model.dart';
import 'package:vinyl_groove_poc_3/widgets/album_card.dart';
import 'package:vinyl_groove_poc_3/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_3/widgets/barcode_button.dart';
import 'package:vinyl_groove_poc_3/widgets/recode_widget.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController tab;

  List<AlbumModel> albums = [];

  Sort sort = .popular;

  Future<void> load() async {
    final res = await appCtrl.loadStores(limit: 10, sort: sort.v);

    if (res != null) {
      albums = res['data'];
      setState(() {});
    }
  }

  @override
  void initState() {
    tab = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppbar(),
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await load();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 24,
                children: [
                  TextField(
                    onTap: () {
                      appCtrl.page.value = 1;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: .circular(12)),
                      filled: true,
                      fillColor: black1,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppIcon.search.icon(color: Colors.white60),
                      ),
                      hintStyle: TextStyle(color: Colors.white60),
                      hintText: '앨범명, 아티스트 검색',
                      suffixIcon: BarcodeButton(),
                    ),
                  ),

                  RecodeWidget(),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '장르별 둘러보기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: .bold,
                        ),
                      ),

                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: .zero,
                          padding: .zero,
                          tapTargetSize: .shrinkWrap,
                          foregroundColor: Colors.white60,
                        ),
                        onPressed: () {
                          appCtrl.page.value = 1;
                        },
                        child: Row(
                          mainAxisSize: .min,
                          spacing: 6,
                          children: [
                            Text('전체 보기', style: TextStyle(fontWeight: .bold)),

                            Icon(Icons.arrow_forward_ios, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),

                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 62,
                    ),
                    shrinkWrap: true,
                    children: Genre.values
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              appCtrl.genre = e;
                              appCtrl.page.value = 1;
                            },
                            child: Card(
                              color: black1,
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(8),
                                side: BorderSide(color: Colors.white24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    e.i.icon(color: yellow, size: 32),

                                    Text(
                                      e == .ETC ? '기타' : e.l,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  Column(
                    spacing: 16,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              onTap: (value) {
                                sort = Sort.values[value];
                                setState(() {});
                                load();
                              },
                              indicatorColor: yellow,
                              dividerHeight: 0,
                              isScrollable: true,
                              tabAlignment: .start,
                              labelPadding: .symmetric(horizontal: 8),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white60,
                              controller: tab,
                              tabs: Sort.values
                                  .map((e) => Tab(text: e.l))
                                  .toList(),
                            ),
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: .zero,
                              padding: .zero,
                              tapTargetSize: .shrinkWrap,
                              foregroundColor: Colors.white60,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 6,
                              children: [
                                Text(
                                  '전체 보기',
                                  style: TextStyle(fontWeight: .bold),
                                ),

                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: .horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Row(
                          spacing: 12,
                          children: albums
                              .map((e) => AlbumCard(album: e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
