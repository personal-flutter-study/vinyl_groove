import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_5/widgets/album_card.dart';
import 'package:vinyl_groove_poc_5/widgets/app_appbar.dart';

import '../app_ctrl.dart';
import '../main.dart';
import '../models/album_model.dart';
import '../widgets/barcode_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Sort sort = .popular;
  List<String> genre = [''];
  List<String> con = [''];
  String trade = '';
  RangeValues price = RangeValues(1000, 1000000);

  bool hide = false;

  final sr = TextEditingController();

  final controller = ScrollController();

  List<AlbumModel> albums = [];

  int page = 1;
  bool hasNext = true;
  int total = 0;

  Future<void> load({bool refresh = true}) async {
    if (refresh) {
      page = 1;
    }

    final res = await appCtrl.loadAlbums(
      sort: sort.v,
      size: 12,
      page: page,
      keyword: sr.text,
      minPrice: price.start.toInt(),
      maxPrice: price.end.toInt(),
      conditions: con.fold(
        '',
        (previousValue, element) => '$previousValue,$element',
      ),
      genres: genre.fold(
        '',
        (previousValue, element) => '$previousValue,$element',
      ),
      tradeMethod: trade,
    );

    if (res != null) {
      if (!refresh) {
        albums.addAll(res['data']);
      } else {
        albums = res['data'];
      }
      page = res['pagination']['page'];
      total = res['pagination']['totalCount'];
      hasNext = res['pagination']['hasNext'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    if (appCtrl.genre != null) {
      genre = [appCtrl.genre!.v];
      appCtrl.genre = null;
    }

    controller.addListener(() {
      if (controller.position.hasPixels) {
        if (controller.position.pixels >= controller.position.maxScrollExtent) {
          if (hasNext) {
            page++;
            load(refresh: false);
          }
        }
      }
    });

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
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                TextField(
                  controller: sr,
                  onChanged: (value) {
                    setState(() {});
                    load();
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: black1,

                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: AppIcon.search.icon(color: Colors.white60),
                    ),
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: .circular(12),
                      borderSide: BorderSide(color: yellow),
                    ),
                    suffixIcon: sr.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              sr.clear();
                              setState(() {});
                              load();
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                          )
                        : BarcodeButton(),
                    hintStyle: TextStyle(color: Colors.white60),
                    hintText: '앨범명, 아티스트',
                  ),
                ),

                filter(),

                Row(
                  children: [
                    Text(
                      '검색 결과 ${total}개',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: 18,
                      ),
                    ),

                    Spacer(),

                    PopupMenuButton(
                      color: black2,
                      itemBuilder: (context) => Sort.values
                          .map(
                            (e) => PopupMenuItem(
                              onTap: () {
                                setState(() {
                                  sort = e;
                                });

                                load();
                              },
                              child: Text(
                                e == .price_asc ? '최저 가격순' : '${e.l}순',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                          )
                          .toList(),
                      child: Row(
                        children: [
                          Text(
                            sort == .price_asc ? '최저 가격순' : '${sort.l}순',
                            style: TextStyle(
                              fontWeight: .w500,
                              color: Colors.white60,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: Colors.white60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    mainAxisExtent: 200,
                  ),
                  shrinkWrap: true,
                  children: albums
                      .map((e) => AlbumCard(album: e, small: true))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column filter() {
    return Column(
      children: [
        Row(
          spacing: 12,
          children: [
            Icon(Icons.tune, color: Colors.white60, size: 18),

            Text(
              '필터',
              style: TextStyle(color: Colors.white, fontWeight: .w500),
            ),

            Spacer(),

            TextButton(
              style: TextButton.styleFrom(minimumSize: .zero, padding: .zero),
              onPressed: () {
                setState(() {
                  genre = [''];
                  con = [''];
                  trade = '';
                  price = RangeValues(1000, 1000000);
                });

                load();
              },
              child: Text(
                '필터 초기화',
                style: TextStyle(color: yellow, fontWeight: .w500),
              ),
            ),
          ],
        ),

        if (!hide)
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text('장르', style: TextStyle(color: Colors.white60)),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: genre.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: genre.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 8, horizontal: 12),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                genre = [''];
                              });

                              load();
                            },
                            child: Text(
                              '전체',
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),

                          ...Genre.values.map((e) {
                            final act = genre.contains(e.v);

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black2,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  genre.remove('');
                                  genre.add(e.v);
                                });
                                load();
                              },
                              child: Text(
                                e.l,
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(
                      '음반 상태',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: con.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: con.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 8, horizontal: 12),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                con = [''];
                              });

                              load();
                            },
                            child: Text(
                              '전체',
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),

                          ...['M', 'NM', 'VG+', 'VG', 'G'].map((e) {
                            final act = con.contains(e);

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black2,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  con.remove('');
                                  con.add(e);
                                });
                                load();
                              },
                              child: Text(
                                e == 'M' ? 'Mint' : e,
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(
                      '가격 범위',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: black2,
                            foregroundColor: Colors.white,
                            padding: .symmetric(vertical: 8, horizontal: 12),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Text(
                            NumberFormat('₩#,###').format(price.start),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Expanded(
                          child: RangeSlider(
                            max: 1000000,
                            min: 1000,
                            activeColor: yellow,
                            padding: .zero,
                            values: price,
                            onChanged: (value) {
                              setState(() {
                                price = value;
                              });
                            },
                            onChangeEnd: (value) {
                              load();
                            },
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: black2,
                            foregroundColor: Colors.white,
                            padding: .symmetric(vertical: 8, horizontal: 12),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Text(
                            price.end == 1000000
                                ? '₩1,000,000+'
                                : NumberFormat('₩#,###').format(price.end),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(
                      '거래 방식',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: trade == '' ? yellow : black2,
                              foregroundColor: trade == ''
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 8, horizontal: 12),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                trade = '';
                              });

                              load();
                            },
                            child: Text(
                              '전체',
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),

                          ...Trade.values.map((e) {
                            final act = trade == e.v;

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black2,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  trade = e.v;
                                });
                                load();
                              },
                              child: Text(
                                e.l,
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

        Row(
          mainAxisAlignment: .center,
          children: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white60),
              onPressed: () {
                setState(() {
                  hide = !hide;
                });
              },
              child: Row(
                spacing: 4,
                children: [
                  Text(
                    hide ? '펼치기' : '접기',
                    style: TextStyle(fontWeight: .w500, color: Colors.white60),
                  ),
                  Icon(
                    hide ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    size: 16,
                    color: Colors.white60,
                  ),
                ],
              ),
            ),
          ],
        ),

        Divider(color: black1),
        Divider(color: black2),
      ],
    );
  }
}
