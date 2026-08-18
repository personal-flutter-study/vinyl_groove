import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_8/app_ctrl.dart';
import 'package:vinyl_groove_poc_8/models/album_model.dart';
import 'package:vinyl_groove_poc_8/widgets/album_card.dart';
import 'package:vinyl_groove_poc_8/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_8/widgets/barcode_button.dart';
import 'package:vinyl_groove_poc_8/widgets/recode_widget.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Sort sort = .popular;

  late final TabController tabController;

  List<AlbumModel> albums = [];

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 10, sort: sort.v);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  spacing: 18,
                  crossAxisAlignment: .start,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      onTap: () {
                        appCtrl.page.value = 1;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: black1,
                        border: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: Colors.white60),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: yellow),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명, 아티스트 검색',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.search.icon(color: Colors.white60),
                        ),
                        suffixIcon: BarcodeButton(),
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
                            fontSize: 20,
                          ),
                        ),

                        Spacer(),

                        TextButton(
                          style: TextButton.styleFrom(minimumSize: .zero),
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
                                  fontWeight: .w500,
                                  fontSize: 12,
                                ),
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
                      padding: .zero,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisExtent: 64,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),

                      physics: NeverScrollableScrollPhysics(),
                      children: Genre.values
                          .map(
                            (e) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(8),
                                side: BorderSide(color: Colors.white24),
                              ),
                              color: black1,
                              child: InkWell(
                                onTap: () {
                                  appCtrl.gen = e;

                                  appCtrl.page.value = 1;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    spacing: 4,
                                    children: [
                                      e.i.icon(color: yellow, size: 28),
                                      Text(
                                        e == .ETC ? '기타' : e.l,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
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
                            unselectedLabelColor: Colors.white60,
                            labelColor: Colors.white,
                            indicatorColor: yellow,
                            dividerHeight: 0,
                            isScrollable: true,
                            tabAlignment: .start,
                            padding: .zero,
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: .w500,
                            ),
                            labelPadding: .symmetric(horizontal: 8),
                            onTap: (value) {
                              setState(() {
                                sort = Sort.values[value];
                              });
                              load();
                            },
                            controller: tabController,
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
                                  fontWeight: .w500,
                                  fontSize: 12,
                                ),
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

              SizedBox(height: 24),

              SingleChildScrollView(
                padding: .symmetric(horizontal: 16),
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: .horizontal,
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
