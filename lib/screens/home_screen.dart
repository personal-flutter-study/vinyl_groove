import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_2/models/album_model.dart';
import 'package:vinyl_groove_poc_2/widgets/album_card.dart';
import 'package:vinyl_groove_poc_2/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_2/widgets/barcode_button.dart';
import 'package:vinyl_groove_poc_2/widgets/recode_widget.dart';

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
    final res = await appCtrl.loadStores(sort: sort.v, limit: 10);

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
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: () async {
            await load();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                      border: OutlineInputBorder(borderRadius: .circular(12)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppIcon.search.icon(color: Colors.white60),
                      ),
                      hintStyle: TextStyle(color: Colors.white60),
                      hintText: '앨범명, 아티스트 검색',
                      suffixIcon: BarcodeButton(),
                      filled: true,
                      fillColor: black1,
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
                          padding: .zero,
                          minimumSize: .zero,
                          foregroundColor: Colors.white60,
                        ),
                        onPressed: () {
                          appCtrl.page.value = 1;
                        },
                        child: Row(
                          mainAxisSize: .min,
                          spacing: 8,
                          children: [
                            Text('전체 보기'),
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
                              child: Column(
                                mainAxisAlignment: .center,
                                children: [
                                  e.i.icon(color: yellow, size: 32),
                                  Text(
                                    e == .ETC ? '기타' : e.l,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
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
                          onTap: (value) async {
                            sort = Sort.values[value];
                            await load();
                          },
                          indicatorSize: .label,
                          dividerHeight: 0,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white60,
                          isScrollable: true,
                          tabAlignment: .start,
                          labelPadding: .symmetric(horizontal: 8),
                          indicatorColor: yellow,
                          controller: tab,
                          tabs: Sort.values.map((e) => Tab(text: e.l)).toList(),
                        ),
                      ),

                      TextButton(
                        style: TextButton.styleFrom(
                          padding: .zero,
                          minimumSize: .zero,
                          foregroundColor: Colors.white60,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: .min,
                          spacing: 8,
                          children: [
                            Text('전체 보기'),
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

                  SingleChildScrollView(
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
        ),
      ),
    );
  }
}
