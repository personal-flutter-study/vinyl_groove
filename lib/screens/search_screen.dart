import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_2/widgets/album_card.dart';
import 'package:vinyl_groove_poc_2/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_2/widgets/barcode_button.dart';

import '../app_ctrl.dart';
import '../main.dart';
import '../models/album_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final word = TextEditingController();

  List<AlbumModel> albums = [];

  Sort sort = .popular;
  List<String> genre = [''];
  List<String> con = [''];
  String trade = '';
  RangeValues price = RangeValues(1000, 1000000);

  int page = 1;
  int totalP = 1;
  int total = 0;

  bool hide = false;

  final controller = ScrollController();

  Future<void> load({bool add = false}) async {
    final res = await appCtrl.loadStores(
      sort: sort.v,
      page: page,
      genres: genre
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      conditions: con
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      tradeMethod: trade,
      minPrice: price.start.toInt(),
      maxPrice: price.end.toInt(),
      size: 12,
      keyword: word.text,
    );

    if (res != null) {
      page = res['pagination']['page'];
      totalP = res['pagination']['totalPages'];
      total = res['pagination']['totalCount'];

      if (add) {
        albums.addAll(res['data']);
      } else
        albums = res['data'];

      print(albums);

      setState(() {});
    }
  }

  @override
  void initState() {
    if (appCtrl.genre != null) {
      genre = [appCtrl.genre!.v];
      appCtrl.genre = null;
    }

    controller.addListener(() async {
      if (controller.hasClients && controller.position.hasPixels) {
        if (controller.position.pixels >= controller.position.maxScrollExtent) {
          page = min(totalP, page + 1);

          if (page != total) {
            await load(add: true);
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
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                TextField(
                  controller: word,
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

                filter(),

                Row(
                  spacing: 8,
                  children: [
                    Text(
                      '검색 결과 ${total}개',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    Spacer(),

                    PopupMenuButton(
                      color: black3,
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
                      style: TextButton.styleFrom(
                        padding: .zero,
                        minimumSize: .zero,
                      ),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          Text(
                            sort == .price_asc ? '최저 가격순' : '${sort.l}순',

                            style: TextStyle(color: Colors.white60),
                          ),

                          Icon(Icons.arrow_drop_down, color: Colors.white60),
                        ],
                      ),
                    ),
                  ],
                ),

                GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 180,
                  ),
                  shrinkWrap: true,
                  children: albums.map((e) => AlbumCard(album: e)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  filter() {
    return Column(
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Icons.tune, color: Colors.white60),
            Text('필터', style: TextStyle(color: Colors.white, fontSize: 16)),

            Spacer(),

            TextButton(
              style: TextButton.styleFrom(
                padding: .zero,
                minimumSize: .zero,
                foregroundColor: yellow,
              ),
              onPressed: () {
                sort = .popular;
                genre = [''];
                con = [''];
                trade = '';
                price = RangeValues(1000, 1000000);
                setState(() {});

                load();
              },
              child: Text('필터 초기화'),
            ),
          ],
        ),

        if (!hide)
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      '장르',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: genre.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: genre.contains('')
                                  ? yellow
                                  : black3,
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
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: act ? yellow : black3,
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  genre.remove('');

                                  if (!act) {
                                    genre.add(e.v);
                                  }
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
                    width: 60,
                    child: Text(
                      '음반 상태',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: con.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: con.contains('')
                                  ? yellow
                                  : black3,
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

                          ...Con.values.map((e) {
                            final act = con.contains(e.v);

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: act ? yellow : black3,
                                minimumSize: .zero,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  con.remove('');

                                  if (!act) {
                                    con.add(e.v);
                                  }
                                });
                                load();
                              },
                              child: Text(
                                e == .M ? 'Mint' : e.v,
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
                    width: 60,
                    child: Text(
                      '거래 방식',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: black3,
                      minimumSize: .zero,
                      padding: .symmetric(vertical: 8, horizontal: 12),
                    ),
                    onPressed: () {},
                    child: Text(
                      '₩${NumberFormat('#,###').format(price.start)}',
                      style: TextStyle(fontWeight: .bold, fontSize: 12),
                    ),
                  ),

                  Expanded(
                    child: RangeSlider(
                      activeColor: yellow,
                      min: 1000,
                      max: 1000000,
                      values: price,
                      onChanged: (value) {
                        setState(() {
                          price = value;
                        });
                        load();
                      },
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: black3,
                      minimumSize: .zero,
                      padding: .symmetric(vertical: 8, horizontal: 12),
                    ),
                    onPressed: () {},
                    child: Text(
                      '₩${NumberFormat('#,###').format(price.end)}',
                      style: TextStyle(fontWeight: .bold, fontSize: 12),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      '거래 방식',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: trade == ''
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: trade == '' ? yellow : black3,
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
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: act ? yellow : black3,
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
              style: TextButton.styleFrom(
                padding: .zero,
                minimumSize: .zero,
                foregroundColor: Colors.white60,
              ),
              onPressed: () {
                setState(() {
                  hide = !hide;
                });
              },
              child: Row(
                mainAxisSize: .min,
                spacing: 4,
                children: [
                  Text(hide ? ' 펼치기' : '접기'),
                  Icon(
                    hide
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    color: Colors.white60,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
