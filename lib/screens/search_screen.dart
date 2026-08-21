import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_14/widgets/album_card.dart';
import 'package:vinyl_groove_poc_14/widgets/app_appbar.dart';

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
  Sort sort = .recent;

  String gen = '';
  String con = '';
  String trd = '';
  RangeValues pri = RangeValues(1000, 1000000);

  List<AlbumModel> albums = [];

  bool hide = false;
  final sr = TextEditingController();

  int page = 1;
  int total = 0;
  bool hasNext = true;

  final _controller = ScrollController();

  Future<void> load({refresh = true}) async {
    final text = sr.text;

    if (refresh) {
      page = 1;
    } else {
      page++;
    }

    final res = await appCtrl.loadAlbums(
      sort: sort.v,
      size: 12,
      page: page,
      genres: gen,
      conditions: con,
      minPrice: pri.start.toInt(),
      tradeMethod: trd,
      maxPrice: pri.end.toInt(),
      keyword: text,
    );

    if (res != null) {
      if (text != sr.text) return;

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
    super.initState();

    if (appCtrl.gen != null) {
      gen = appCtrl.gen!.v;
      appCtrl.gen = null;
    }

    _controller.addListener(() {
      if (_controller.position.hasPixels) {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent) {
          if (hasNext) {
            load(refresh: false);
          }
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppbar(),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      hintStyle: TextStyle(color: Colors.white60),
                      hintText: '앨범명, 아티스트',
                      border: OutlineInputBorder(borderRadius: .circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: .circular(12),
                        borderSide: BorderSide(color: yellow),
                      ),
                    ),
                  ),

                  filter(),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 24,
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
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontWeight: .w500,
                                        ),
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
                                  fontSize: 12,
                                  fontWeight: .w500,
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

                    Expanded(
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: GridView(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                                mainAxisExtent: 210,
                              ),
                          shrinkWrap: true,
                          children: albums
                              .map((e) => AlbumCard(album: e, size: 11))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  filter() {
    return Column(
      children: [
        Row(
          spacing: 12,
          children: [
            Icon(Icons.tune, color: Colors.white60, size: 20),

            Text(
              '필터',
              style: TextStyle(
                color: Colors.white,
                fontWeight: .w500,
                fontSize: 16,
              ),
            ),

            Spacer(),

            TextButton(
              style: TextButton.styleFrom(minimumSize: .zero, padding: .zero),
              onPressed: () {
                setState(() {
                  gen = '';
                  con = '';
                  trd = '';
                  pri = RangeValues(1000, 1000000);
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

        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: hide ? 0 : 190,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 64,
                      child: Text(
                        '장르',
                        style: TextStyle(
                          color: Colors.white60,
                          fontWeight: .w500,
                          fontSize: 12,
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
                                backgroundColor: gen == '' ? yellow : black2,
                                foregroundColor: gen == ''
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
                                  gen = '';
                                });

                                load();
                              },
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    '전체',
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ...Genre.values.map((e) {
                              final act = gen == e.v;

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
                                    gen = e.v;
                                  });

                                  load();
                                },
                                child: Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      e.l,
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
                          fontWeight: .w500,
                          fontSize: 12,
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
                                backgroundColor: con == '' ? yellow : black2,
                                foregroundColor: con == ''
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
                                  con = '';
                                });

                                load();
                              },
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    '전체',
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ...['M', 'NM', 'VG+', 'VG', 'G'].map((e) {
                              final act = con == e;

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
                                    con = e;
                                  });

                                  load();
                                },
                                child: Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      e == 'M' ? "Mint" : e,
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
                          fontWeight: .w500,
                          fontSize: 12,
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
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  NumberFormat('₩ #,###').format(pri.start),
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: RangeSlider(
                              min: 1000,
                              max: 1000000,
                              values: pri,
                              activeColor: yellow,
                              padding: .zero,
                              onChanged: (value) {
                                setState(() {
                                  pri = value;
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
                              padding: .symmetric(vertical: 8, horizontal: 16),
                              minimumSize: .zero,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  pri.end == 1000000
                                      ? '₩1,000,000+'
                                      : NumberFormat('₩ #,###').format(pri.end),
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                          fontWeight: .w500,
                          fontSize: 12,
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
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  trd = '';
                                });

                                load();
                              },
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    '전체',
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
                                child: Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      e.l,
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
          ),
        ),

        TextButton(
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
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: .w500,
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
