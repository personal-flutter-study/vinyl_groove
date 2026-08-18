import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_8/widgets/album_card.dart';
import 'package:vinyl_groove_poc_8/widgets/app_appbar.dart';

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

  List<String> gen = [''];
  List<String> con = [''];
  String trd = '';
  RangeValues pri = RangeValues(1000, 1000000);

  final sr = TextEditingController();

  bool hide = false;

  int page = 1;
  int total = 0;
  bool hasNext = true;

  final ScrollController scrollController = ScrollController();

  List<AlbumModel> albums = [];

  Future<void> load({refresh = true}) async {
    if (refresh) {
      page = 1;
    }

    final res = await appCtrl.loadAlbums(
      sort: sort.v,
      size: 12,
      page: page,
      tradeMethod: trd,
      genres: gen
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      conditions: con
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      minPrice: pri.start.toInt(),
      maxPrice: pri.end.toInt(),
      keyword: sr.text,
    );

    if (res != null) {
      if (refresh) {
        albums = res['data'];
      } else {
        albums.addAll(res['data']);
      }
      page = res['pagination']['page'];
      total = res['pagination']['totalCount'];
      hasNext = res['pagination']['hasNext'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    if (appCtrl.gen != null) {
      gen = [appCtrl.gen!.v];
      appCtrl.gen = null;
    }

    scrollController.addListener(() {
      if (scrollController.position.hasPixels) {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) {
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
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: .start,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: sr,
                      onChanged: (value) {
                        setState(() {});
                        load();
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
                        hintText: '앨범명, 아티스트',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: AppIcon.search.icon(color: Colors.white60),
                        ),
                        suffixIcon: sr.text.isNotEmpty
                            ? IconButton(
                                style: IconButton.styleFrom(),
                                onPressed: () {
                                  setState(() {
                                    sr.clear();
                                  });
                                  load();
                                },
                                icon: Icon(Icons.close, color: Colors.white),
                              )
                            : BarcodeButton(),
                      ),
                    ),
                    filter(),
                  ],
                ),
              ),

              Divider(color: black1, height: 1),
              Divider(color: black2, height: 1),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16,
                  children: [
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
                          itemBuilder: (context) =>
                              <Sort>[.recent, .popular, .price_asc]
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
                                  color: Colors.white60,
                                  fontWeight: .w500,
                                  fontSize: 12,
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
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        mainAxisExtent: 210,
                      ),
                      children: albums
                          .map((e) => AlbumCard(album: e, size: 12))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column filter() {
    return Column(
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Icons.tune, color: Colors.white60, size: 22),

            Text(
              '필터',
              style: TextStyle(
                color: Colors.white,
                fontWeight: .w500,
                fontSize: 15,
              ),
            ),

            Spacer(),

            TextButton(
              style: TextButton.styleFrom(foregroundColor: yellow),
              onPressed: () {
                setState(() {
                  gen = [''];
                  con = [''];
                  trd = '';
                  pri = RangeValues(1000, 1000000);
                });
                load();
              },
              child: Text(
                '필터 초기화',
                style: TextStyle(fontWeight: .w500, fontSize: 12),
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
                    child: Text(
                      '장르',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: .w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        spacing: 6,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gen.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: gen.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 8, horizontal: 16),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                gen = [''];
                              });

                              load();
                            },
                            child: Text(
                              '전체',
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),

                          ...Genre.values.map((e) {
                            final act = gen.contains(e.v);

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black2,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  gen.remove('');
                                  if (!act) {
                                    gen.add(e.v);
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
                    width: 64,
                    child: Text(
                      '음반 상태',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: .w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        spacing: 6,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: con.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: con.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 8, horizontal: 16),
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
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  con.remove('');
                                  if (!act) {
                                    con.add(e);
                                  }
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
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: .w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Row(
                      spacing: 6,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: black2,
                            foregroundColor: Colors.white,
                            padding: .symmetric(vertical: 8, horizontal: 16),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Text(
                            NumberFormat('₩#,###').format(pri.start),
                            style: TextStyle(fontWeight: .bold, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: RangeSlider(
                            min: 1000,
                            max: 1000000,
                            values: pri,
                            onChanged: (value) {
                              setState(() {
                                pri = value;
                              });
                            },
                            activeColor: yellow,
                            padding: .zero,
                            onChangeEnd: (value) {
                              load();
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: black2,
                            foregroundColor: Colors.white,
                            padding: .symmetric(vertical: 8, horizontal: 16),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Text(
                            pri.end == 1000000
                                ? '₩1,000,000+'
                                : NumberFormat('₩#,###').format(pri.end),
                            style: TextStyle(fontWeight: .bold, fontSize: 12),
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
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: .w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Row(
                        spacing: 6,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: trd == '' ? yellow : black2,
                              foregroundColor: trd == ''
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 8, horizontal: 16),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                trd = '';
                              });

                              load();
                            },
                            child: Text(
                              '전체',
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),

                          ...Trade.values.map((e) {
                            final act = trd == e.v;

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: act ? yellow : black2,
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  trd = e.v;
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

        TextButton(
          style: TextButton.styleFrom(minimumSize: .zero, padding: .zero),
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
                style: TextStyle(
                  fontWeight: .w500,
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),

              Icon(
                hide ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.white60,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
