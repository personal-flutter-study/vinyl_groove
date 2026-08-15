import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_4/models/album_model.dart';
import 'package:vinyl_groove_poc_4/widgets/album_card.dart';
import 'package:vinyl_groove_poc_4/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_4/widgets/barcode_button.dart';
import 'package:vinyl_groove_poc_4/widgets/recode_widget.dart';

import '../app_ctrl.dart';
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
    final res = await appCtrl.loadAlbums(limit: 10, sort: sort.v);
    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    tab = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await load();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppbar(),
        backgroundColor: black,
        body: RefreshIndicator(
          onRefresh: () async {
            await load();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      TextField(
                        onTap: () {
                          appCtrl.page.value = 1;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: black1,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: .circular(12),
                            borderSide: BorderSide(color: yellow),
                          ),
                          suffixIcon: BarcodeButton(),
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: '앨범명, 아티스트 검색',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: AppIcon.search.icon(color: Colors.white60),
                          ),
                        ),
                      ),

                      RecodeWidget(),

                      Row(
                        children: [
                          Text(
                            '장르별 둘러보기',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                              fontSize: 18,
                            ),
                          ),

                          Spacer(),

                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white60,
                            ),
                            onPressed: () {
                              appCtrl.page.value = 1;
                            },
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 4,
                              children: [
                                Text(
                                  '전체 보기',
                                  style: TextStyle(fontWeight: .w500),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white60,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      GridView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          mainAxisExtent: 64,
                        ),
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
                                      spacing: 2,
                                      children: [
                                        e.i.icon(color: yellow, size: 28),
                                        Text(
                                          e == .ETC ? '기타' : e.l,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
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

                      Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              onTap: (value) {
                                setState(() {
                                  sort = Sort.values[value];
                                });
                                load();
                              },
                              dividerHeight: 0,
                              indicatorColor: yellow,
                              unselectedLabelColor: Colors.white60,
                              labelColor: Colors.white,
                              tabAlignment: .start,
                              isScrollable: true,
                              labelPadding: .symmetric(horizontal: 6),
                              controller: tab,
                              tabs: Sort.values
                                  .map((e) => Tab(text: e.l))
                                  .toList(),
                            ),
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white60,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 4,
                              children: [
                                Text(
                                  '전체 보기',
                                  style: TextStyle(fontWeight: .w500),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white60,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  padding: .symmetric(horizontal: 8),
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: .horizontal,
                  child: Row(
                    children: albums.map((e) => AlbumCard(album: e)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
