import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/widgets/album_card.dart';
import 'package:vinyl_groove_poc_3/widgets/app_appbar.dart';
import 'package:vinyl_groove_poc_3/widgets/barcode_button.dart';

import '../main.dart';
import '../models/album_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final sr = TextEditingController();

  var albums = <AlbumModel>[];

  Sort sort = .popular;
  List<String> genre = [''];
  List<String> con = [''];
  String trade = '';
  RangeValues price = RangeValues(1000, 1000000);

  int page = 1;
  int total = 1;
  bool hasNext = true;
  bool hide = false;

  final controller = ScrollController();

  Future<void> load({bool add = false}) async {
    if (!add) {
      page = 1;
    }

    final res = await appCtrl.loadStores(
      sort: sort.v,
      size: 12,
      keyword: sr.text,
      maxPrice: price.end.toInt(),
      minPrice: price.start.toInt(),
      conditions: con
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      tradeMethod: trade,
      genres: genre
          .fold('', (previousValue, element) => '$previousValue,$element')
          .replaceFirst(',', ''),
      page: page,
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
      setState(() {});
    }
  }

  @override
  void initState() {
    if (appCtrl.genre != null) {
      genre = [appCtrl.genre!.v];
      appCtrl.genre = null;
    }

    controller.addListener(() {
      if (controller.hasClients && controller.position.hasPixels) {
        if (controller.position.pixels >= controller.position.maxScrollExtent) {
          if (hasNext) {
            page++;
            load(add: true);
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
                  onChanged: (value) {
                    setState(() {});
                    load();
                  },
                  controller: sr,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                    filled: true,
                    fillColor: black1,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppIcon.search.icon(color: Colors.white60),
                    ),
                    hintStyle: TextStyle(color: Colors.white60),
                    hintText: '앨범명, 아티스트 검색',
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
                  ),
                ),

                Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.tune, color: Colors.white60, size: 18),

                    Text(
                      '필터',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: .bold,
                      ),
                    ),

                    Spacer(),

                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: .zero,
                        padding: .zero,
                        tapTargetSize: .shrinkWrap,
                        foregroundColor: yellow,
                      ),
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
                        style: TextStyle(fontWeight: .bold),
                      ),
                    ),
                  ],
                ),

                filter(),

                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      '검색 결과 ${total}개',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: .bold,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: .center,
                      children: [
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
                            spacing: 6,
                            children: [
                              Text(
                                sort == .price_asc ? '최저 가격순' : "${sort.l}순",
                                style: TextStyle(color: Colors.white60),
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
                  ],
                ),

                GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
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

  Column filter() {
    return Column(
      children: [
        if (!hide)
          Column(
            children: [
              Row(
                spacing: 4,

                children: [
                  SizedBox(
                    width: 60,
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
                              foregroundColor: genre.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: genre.contains('')
                                  ? yellow
                                  : black3,
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
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: act ? yellow : black3,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                minimumSize: .zero,
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
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                spacing: 4,

                children: [
                  SizedBox(
                    width: 60,
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
                              foregroundColor: con.contains('')
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: con.contains('')
                                  ? yellow
                                  : black3,
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

                          ...Con.values.map((e) {
                            final act = con.contains(e.v);
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: act ? yellow : black3,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  con.remove('');
                                  if (!con.remove(e.v)) con.add(e.v);
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
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                spacing: 4,
                children: [
                  SizedBox(
                    width: 60,
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
                            foregroundColor: Colors.white,
                            backgroundColor: black3,
                            padding: .symmetric(vertical: 8, horizontal: 12),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Text(
                            NumberFormat('₩#,###').format(price.start),
                            style: TextStyle(fontWeight: .bold, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: RangeSlider(
                            padding: .zero,
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
                            padding: .symmetric(vertical: 8, horizontal: 12),
                            minimumSize: .zero,
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
                ],
              ),

              Row(
                spacing: 4,

                children: [
                  SizedBox(
                    width: 60,
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
                              foregroundColor: trade == ''
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: trade == '' ? yellow : black3,
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
                                foregroundColor: act
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: act ? yellow : black3,
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
                          }).toList(),
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
                minimumSize: .zero,
                padding: .zero,
                tapTargetSize: .shrinkWrap,
                foregroundColor: Colors.white60,
              ),
              onPressed: () {
                setState(() {
                  hide = !hide;
                });
              },
              child: Row(
                mainAxisSize: .min,
                spacing: 6,
                children: [
                  Text(
                    hide ? '펼치기' : '접기',
                    style: TextStyle(color: Colors.white60),
                  ),

                  Icon(
                    hide
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),

        Divider(color: black2, thickness: 2),
        Divider(color: black1, thickness: 2),
      ],
    );
  }
}
