import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_6/app_ctrl.dart';
import 'package:vinyl_groove_poc_6/main.dart';
import 'package:vinyl_groove_poc_6/models/album_model.dart';
import 'package:vinyl_groove_poc_6/widgets/album_card.dart';
import 'package:vinyl_groove_poc_6/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_6/widgets/barcode_widget.dart';
import 'package:vinyl_groove_poc_6/widgets/recode_widget.dart';

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
    final res = await appCtrl.loadAlbums(sort: sort.v, limit: 10);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
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
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: load,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 16,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      onTap: () {
                        appCtrl.page.value = 1;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: black1,
                        hintStyle: TextStyle(color: Colors.white60),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.search.icon(color: Colors.white60),
                        ),
                        suffixIcon: BarcodeWidget(),
                        hintText: '앨범명, 아티스트 검색',
                        border: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: Colors.white60),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
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
                          onPressed: () {
                            appCtrl.page.value = 1;
                          },
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 4,
                            children: [
                              Text(
                                '전체 보기',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                  fontWeight: .w500,
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.white60,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        mainAxisExtent: 64,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: Genre.values
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                appCtrl.genre = e;
                                appCtrl.page.value = 1;
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(8),
                                  side: BorderSide(color: Colors.white24),
                                ),
                                color: black1,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    spacing: 2,
                                    children: [
                                      e.i.icon(color: yellow, size: 28),

                                      Text(
                                        e.l,
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

                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            isScrollable: true,
                            tabAlignment: .start,
                            labelPadding: .symmetric(horizontal: 12),
                            dividerHeight: 0,
                            indicatorColor: yellow,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white60,
                            onTap: (value) {
                              setState(() {
                                sort = Sort.values[value];
                              });

                              load();
                            },
                            controller: tab,
                            tabs: Sort.values
                                .map((e) => Tab(text: e.l))
                                .toList(),
                          ),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 4,
                            children: [
                              Text(
                                '전체 보기',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                  fontWeight: .w500,
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.white60,
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
                padding: .symmetric(horizontal: 16),
                scrollDirection: .horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                child: Row(
                  spacing: 12,
                  children: albums.map((e) => AlbumCard(album: e)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
