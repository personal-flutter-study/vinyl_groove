import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_4/widgets/album_card.dart';
import 'package:vinyl_groove_poc_4/widgets/app_appbar.dart';

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
  final sr = TextEditingController();

  final controller = ScrollController();

  List<AlbumModel> albums = [];

  Sort sort = .popular;
  List<String> genre = [''];
  List<String> con = [''];
  String trade = '';
  RangeValues price = RangeValues(1000, 1000000);

  bool hide = false;

  int page = 1;
  int total = 0;
  bool hasNext = true;

  Future<void> load({bool add = false}) async {
    final res = await appCtrl.loadAlbums(
      sort: sort.v,
      size: 12,
      page: page,
      genres: genre
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      tradeMethod: trade,
      conditions: con
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      minPrice: price.start.toInt(),
      maxPrice: price.end.toInt(),
      keyword: sr.text,
    );
    if (res != null) {
      if (add) {
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

    controller.addListener(() async {
      if (controller.position.hasPixels) {
        if (controller.position.pixels >= controller.position.maxScrollExtent) {
          if (hasNext) {
            page++;
            await load(add: true);
          }
        }
      }
    });

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
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
                    fillColor: black1,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: .circular(12),
                      borderSide: BorderSide(color: yellow),
                    ),
                    suffixIcon: sr.text.isNotEmpty
                        ? IconButton(
                            style: IconButton.styleFrom(),
                            onPressed: () {
                              sr.clear();

                              setState(() {});
                              load();
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                          )
                        : BarcodeButton(),
                    hintStyle: TextStyle(color: Colors.white60),
                    hintText: '앨범명, 아티스트 검색',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: AppIcon.search.icon(color: Colors.white60),
                    ),
                  ),
                ),

                Row(
                  spacing: 12,
                  children: [
                    Icon(Icons.tune, color: Colors.white60, size: 28),

                    Text(
                      '필터',
                      style: TextStyle(color: Colors.white, fontWeight: .w500),
                    ),

                    Spacer(),

                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: yellow),
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
                        style: TextStyle(fontWeight: .w500),
                      ),
                    ),
                  ],
                ),

                filter(),

                Row(
                  children: [
                    Text(
                      '검색 결과 ${total}개',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: .bold,
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
                        mainAxisSize: .min,

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
                            color: Colors.white60,
                            size: 24,
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
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    mainAxisExtent: 220,
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
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: genre.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: genre.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 12),
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
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  genre.remove('');
                                  if (!genre.remove(e.v)) genre.add(e.v);
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
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: con.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: con.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 12),
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
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  con.remove('');
                                  if (!con.remove(e)) con.add(e);
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
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: black2,
                              foregroundColor: Colors.white,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 12),
                            ),
                            onPressed: () {},
                            child: Text(
                              NumberFormat('₩#,###').format(price.start),
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),

                          RangeSlider(
                            onChangeEnd: (value) {
                              load();
                            },
                            padding: .zero,
                            activeColor: yellow,
                            min: 1000,
                            max: 1000000,
                            values: price,
                            onChanged: (value) {
                              setState(() {
                                price = value;
                              });
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: black2,
                              foregroundColor: Colors.white,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 12),
                            ),
                            onPressed: () {},
                            child: Text(
                              price.end == 1000000
                                  ? '₩1,000,000+'
                                  : NumberFormat('₩#,###').format(price.end),
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),
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
                      '거래 방식',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: trade == '' ? yellow : black2,
                              foregroundColor: trade == ''
                                  ? Colors.black
                                  : Colors.white,
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 8, horizontal: 12),
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
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
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
                mainAxisSize: .min,
                spacing: 4,
                children: [
                  Text(
                    hide ? '펼치기' : '접기',
                    style: TextStyle(fontWeight: .w500),
                  ),

                  Icon(
                    hide ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: Colors.white60,
                    size: 14,
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
