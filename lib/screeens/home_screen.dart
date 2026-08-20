import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_13/app_ctrl.dart';
import 'package:vinyl_groove_poc_13/models/album_model.dart';
import 'package:vinyl_groove_poc_13/widgets/album_card.dart';
import 'package:vinyl_groove_poc_13/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_13/widgets/barcode_button.dart';
import 'package:vinyl_groove_poc_13/widgets/recode_widget.dart';

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
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: RefreshIndicator(
          onRefresh: load,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        hintStyle: TextStyle(color: Colors.white60),
                        hintText: '앨범명, 아티스트 검색',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.search.icon(color: Colors.white60),
                        ),
                        suffixIcon: BarcodeButton(),
                        border: OutlineInputBorder(borderRadius: .circular(12)),
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
                                  fontWeight: .w500,
                                  fontSize: 12,
                                  color: Colors.white60,
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        mainAxisExtent: 68,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: Genre.values
                          .map(
                            (e) => Card(
                              color: black1,
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(8),
                                side: BorderSide(color: Colors.white24),
                              ),
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
                            controller: tabController,
                            isScrollable: true,
                            tabAlignment: .start,
                            padding: .zero,
                            labelPadding: .symmetric(horizontal: 8),
                            indicatorColor: yellow,
                            dividerHeight: 0,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white60,
                            labelStyle: TextStyle(fontSize: 15),
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
                                  fontWeight: .w500,
                                  fontSize: 12,
                                  color: Colors.white60,
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SingleChildScrollView(
                  padding: .symmetric(horizontal: 16),
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: .horizontal,
                  child: Row(
                    spacing: 12,
                    children: albums.map((e) => AlbumCard(album: e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
