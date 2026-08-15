import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_7/app_ctrl.dart';
import 'package:vinyl_groove_poc_7/models/album_model.dart';
import 'package:vinyl_groove_poc_7/widgets/album_card.dart';
import 'package:vinyl_groove_poc_7/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_7/widgets/barcode_button.dart';
import 'package:vinyl_groove_poc_7/widgets/recode_widget.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController tabController;

    Sort sort = .popular;

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

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        load();
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppbar(),
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
                        fillColor: black1,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.search.icon(color: Colors.white60),
                        ),
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명, 아티스트 검색',
                        border: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        suffixIcon: BarcodeButton(),
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
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 14,
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
                        mainAxisExtent: 68,
                      ),
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
                                  appCtrl.genre = e;
                                  appCtrl.page.value = 1;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    spacing: 4,
                                    children: [
                                      e.i.icon(color: yellow, size: 24),
                                      Text(
                                        e == .ETC ? '기타' : e.l,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: .w500,
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
                            dividerHeight: 0,
                            indicatorColor: yellow,
                            isScrollable: true,
                            tabAlignment: .start,
                            padding: .zero,
                            labelPadding: .symmetric(horizontal: 8),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white60,
                            controller: tabController,
                            onTap: (value) {
                              setState(() {
                                sort = Sort.values[value];
                              });
                              load();
                            },
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
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 14,
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
        backgroundColor: black,
      ),
    );
  }
}
