import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_6/main.dart';
import 'package:vinyl_groove_poc_6/widgets/album_card.dart';
import 'package:vinyl_groove_poc_6/widgets/app_appbar.dart';

import '../app_ctrl.dart';
import '../models/album_model.dart';
import '../widgets/barcode_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<AlbumModel> albums = [];

  final sr = TextEditingController();
  final controller = ScrollController();

  Sort sort = .popular;
  List<String> genre = [''];
  List<String> con = [''];
  String trd = '';
  RangeValues pri = RangeValues(1000, 1000000);

  bool hide = false;

  int page = 1;
  int total = 0;
  bool hasNext = true;

  Future<void> load({refresh = true}) async {
    if (refresh) {
      page = 1;
    }

    final res = await appCtrl.loadAlbums(
      sort: sort.v,
      page: page,
      size: 12,
      tradeMethod: trd,
      genres: genre
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      conditions: con
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      maxPrice: pri.end.toInt(),
      minPrice: pri.start.toInt(),
      keyword: sr.text,
    );

    if (res != null) {
      page = res['pagination']['page'];
      total = res['pagination']['totalCount'];
      hasNext = res['pagination']['hasNext'];

      if (refresh) {
        albums = res['data'];
      } else {
        albums.addAll(res['data']);
      }
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    controller.addListener(() async {
      if (controller.position.hasPixels) {
        if (controller.position.pixels >= controller.position.maxScrollExtent) {
          if (hasNext) {
            page++;
            load(refresh: false);
          }
        }
      }
    });

    if (appCtrl.genre != null) {
      genre = [appCtrl.genre!.v];
      appCtrl.genre = null;
    }

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
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: sr,
                  onChanged: (value) {
                    setState(() {});
                    load();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: black1,
                    hintStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: AppIcon.search.icon(color: Colors.white60),
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
                        : BarcodeWidget(),
                    hintText: '앨범명, 아티스트',
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
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: filter(),
              ),

              Divider(color: black1, height: 1),
              Divider(color: black2, height: 1),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      '검색 결과 ${total}개',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: .bold,
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
                                    style: TextStyle(color: Colors.white),
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
                            size: 22,
                            color: Colors.white60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              GridView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: .symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  mainAxisExtent: 210,
                ),
                children: albums.indexed
                    .map((e) => AlbumCard(album: e.$2, size: 12))
                    .toList(),
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
            Icon(Icons.tune, color: Colors.white60, size: 24),

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
              style: TextButton.styleFrom(
                foregroundColor: yellow,
                minimumSize: .zero,
                padding: .zero,
              ),
              onPressed: () {
                setState(() {
                  genre = [''];
                  con = [''];
                  trd = '';
                  pri = RangeValues(1000, 1000000);
                });

                load();
              },
              child: Text('필터 초기화', style: TextStyle(fontWeight: .w500)),
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
                        spacing: 6,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: genre.contains('')
                                  ? yellow
                                  : black2,
                              foregroundColor: genre.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              padding: .symmetric(vertical: 6, horizontal: 16),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                genre = [''];
                              });

                              load();
                            },
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text('전체', style: TextStyle(fontWeight: .bold)),
                              ],
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
                                  vertical: 6,
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  genre.remove('');
                                  if (!genre.contains(e.v)) genre.add(e.v);
                                });
                                load();
                              },
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    e.l,
                                    style: TextStyle(fontWeight: .bold),
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
                      style: TextStyle(color: Colors.white60),
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
                              padding: .symmetric(vertical: 6, horizontal: 16),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                con = [''];
                              });

                              load();
                            },
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text('전체', style: TextStyle(fontWeight: .bold)),
                              ],
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
                                  vertical: 6,
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  con.remove('');

                                  if (!con.contains(e)) con.add(e);
                                });
                                load();
                              },
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    e == 'M' ? "Mint" : e,
                                    style: TextStyle(fontWeight: .bold),
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
                      '거래 방식',
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
                            padding: .symmetric(vertical: 6, horizontal: 16),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              Text(
                                NumberFormat('₩ #,###').format(pri.start),
                                style: TextStyle(fontWeight: .bold),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: RangeSlider(
                            min: 1000,
                            max: 1000000,
                            padding: .zero,
                            activeColor: yellow,
                            values: pri,
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
                            padding: .symmetric(vertical: 6, horizontal: 16),
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
                                style: TextStyle(fontWeight: .bold),
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
                      style: TextStyle(color: Colors.white60),
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
                              padding: .symmetric(vertical: 6, horizontal: 16),
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
                                Text('전체', style: TextStyle(fontWeight: .bold)),
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
                                  vertical: 6,
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
                                    style: TextStyle(fontWeight: .bold),
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
                size: 14,
                color: Colors.white60,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
