import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';
import 'package:vinyl_groove_poc_1/widgets.dart';

import '../app_ctrl.dart';
import '../main.dart';
import '../widgets/like_button.dart';
import 'album_screen.dart';
import 'barcode_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final sr = TextEditingController();

  Map? page;
  List<AlbumModel> albums = [];

  selGenre(Genre genre) {
    if (genre == .WH) {
      genres.clear();
      genres.add(genre);
    } else {
      genres.remove(Genre.WH);
      if (!genres.remove(genre)) genres.add(genre);
    }
  }

  selCondition(Condition con) {
    if (con == .WH) {
      conditions.clear();
      conditions.add(con);
    } else {
      conditions.remove(Condition.WH);
      if (!conditions.remove(con)) conditions.add(con);
    }
  }

  refresh([bool load = false]) => appCtrl
      .loadAlbums(
        size: 12,
        page: page?['page'],
        sort: sort.v,
        conditions: conditions.map((e) => e.v).toList(),
        genres: genres.map((e) => e.v).toList(),
        tradeMethod: trade.v,
        keyword: sr.text,
        minPrice: prices.start.toInt(),
        maxPrice: prices.end.toInt(),
      )
      .then((value) {
        if (value != null) {
          page = value['pagination'];
          if (load) {
            albums.addAll(value['data']);
          } else {
            albums = value['data'];
          }
          setState(() {});
        }
        return value;
      });

  List<Genre> genres = [];
  List<Condition> conditions = [];
  Trade trade = .WH;

  Sort sort = .recent;

  RangeValues prices = RangeValues(1000, 1000000);

  late final ScrollController scr;

  @override
  void initState() {
    scr = ScrollController()
      ..addListener(() {
        if (scr.hasClients && scr.position.hasPixels) {
          if (scr.offset >= scr.position.maxScrollExtent) {
            if (page == null) return;
            if (page!['page'] >= page!['totalPages']) return;
            page!['page'] = page!['page'] + 1;
            refresh(true);
          }
        }
      });

    if (appCtrl.genre != null && !genres.contains(appCtrl.genre)) {
      selGenre(appCtrl.genre!);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      refresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            controller: scr,
            child: Column(
              spacing: 16,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {});
                    refresh();
                  },
                  controller: sr,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: .lerp(Colors.black, Colors.white, .05),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                    prefixIcon: Icon(Icons.search, color: Colors.white60),
                    hintStyle: TextStyle(color: Colors.white60),
                    hintText: '앨범명, 아티스트 검색',
                    suffixIcon: sr.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              sr.clear();
                              setState(() {});
                              refresh();
                            },
                            icon: Icon(Icons.close, color: Colors.white60),
                          )
                        : IconButton(
                            onPressed: () async {
                              final res = await context.go(BarcodeScreen());

                              print(res);

                              context.go(
                                AlbumScreen(
                                  albumModel: AlbumModel.from(
                                    await appCtrl.loadAlbumDetail(
                                      (res as List).first['id'],
                                    ),
                                  ),
                                ),
                              );

                              //context.message('바코드 검색을 현재 준비중에 있습니다.');
                            },
                            icon: AppIcon.barcodescan.icon(
                              color: Colors.white60,
                            ),
                          ),
                  ),
                ),

                filter(),

                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      '검색 결과 ${page?['totalCount'] ?? 0}개',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: .bold,
                        color: Colors.white,
                      ),
                    ),

                    PopupMenuButton(
                      onSelected: (value) async {
                        setState(() {
                          sort = value;
                        });
                        refresh();
                      },
                      menuPadding: .all(8),
                      color: .lerp(Colors.black, Colors.white, .2),
                      itemBuilder: (context) => Sort.values
                          .map(
                            (e) => PopupMenuItem(
                              value: e,
                              child: Text(
                                '${e.l}',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                          )
                          .toList(),
                      child: Row(
                        spacing: 4,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            sort.l,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                            color: Colors.white60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Builder(
                  builder: (context) {
                    if (albums.isEmpty) {
                      return Center(
                        child: Text(
                          'no results',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
                        ),
                      );
                    }

                    return GridView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 200,
                      ),
                      children: albums
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                context.go(AlbumScreen(albumModel: e));
                              },
                              child: Container(
                                clipBehavior: .antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: .circular(12),
                                  color: .lerp(Colors.black, Colors.white, .2),
                                ),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  spacing: 4,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Image.network(
                                              e.albumImage,
                                              fit: .cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => SizedBox(),
                                            ),
                                          ),

                                          Align(
                                            alignment: .topRight,
                                            child: LikeButton(albumModel: e),
                                          ),

                                          Align(
                                            alignment: .bottomLeft,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: .circular(4),
                                              ),
                                              color: Colors.black54,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                child: Text(
                                                  e.condition,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: .bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        spacing: 4,
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            overflow: .ellipsis,
                                            e.albumName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: .bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            e.artist,
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 10,
                                            ),
                                          ),

                                          Text(
                                            '₩ ${NumberFormat('###,###').format(e.price)}',
                                            style: TextStyle(
                                              color: yellow,
                                              fontWeight: .bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
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
            Expanded(
              child: Text(
                '필터',
                style: TextStyle(fontWeight: .bold, color: Colors.white),
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(foregroundColor: yellow),
              onPressed: () {
                genres = [.WH];
                conditions = [.WH];
                trade = .WH;
                prices = RangeValues(1000, 1000000);
                setState(() {});

                refresh();
              },
              child: Text('필터 초기화', style: TextStyle(fontWeight: .bold)),
            ),
          ],
        ),

        if (!toggle)
          SizedBox()
        else ...[
          Row(
            children: [
              SizedBox(
                width: 62,

                child: Text(
                  '장르',
                  style: TextStyle(fontWeight: .bold, color: Colors.white60),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: .horizontal,
                  child: Row(
                    spacing: 8,
                    children: Genre.values
                        .map(
                          (e) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 6, horizontal: 12),
                              backgroundColor: genres.contains(e)
                                  ? yellow
                                  : .lerp(Colors.black, Colors.white, .05),
                              foregroundColor: genres.contains(e)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                selGenre(e);
                              });
                              refresh();
                            },
                            child: Text(
                              e.l,
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 62,

                child: Text(
                  '음반 상태',
                  style: TextStyle(fontWeight: .bold, color: Colors.white60),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: .horizontal,
                  child: Row(
                    spacing: 8,
                    children: Condition.values
                        .map(
                          (e) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 6, horizontal: 12),
                              backgroundColor: conditions.contains(e)
                                  ? yellow
                                  : .lerp(Colors.black, Colors.white, .05),
                              foregroundColor: conditions.contains(e)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              setState(() {
                                selCondition(e);
                              });

                              refresh();
                            },
                            child: Text(
                              e.l,
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 62,

                child: Text(
                  '장르',
                  style: TextStyle(fontWeight: .bold, color: Colors.white60),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: .zero,
                        padding: .symmetric(vertical: 6, horizontal: 12),
                        backgroundColor: .lerp(Colors.black, Colors.white, .05),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Text(
                        "\₩${NumberFormat('###,###').format(prices.start)}",
                        style: TextStyle(fontWeight: .bold, fontSize: 12),
                      ),
                    ),

                    Expanded(
                      child: RangeSlider(
                        activeColor: yellow,
                        min: 1000,
                        max: 1000000,
                        values: prices,
                        onChanged: (value) {
                          setState(() {
                            prices = value;
                          });
                          refresh();
                        },
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: .zero,
                        padding: .symmetric(vertical: 6, horizontal: 12),
                        backgroundColor: .lerp(Colors.black, Colors.white, .05),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Text(
                        "\₩${NumberFormat('###,###').format(prices.end)}${prices.end == 1000000 ? '+' : ''}",
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
                width: 62,
                child: Text(
                  '거래 방식',
                  style: TextStyle(fontWeight: .bold, color: Colors.white60),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: .horizontal,
                  child: Row(
                    spacing: 8,
                    children: Trade.values
                        .map(
                          (e) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: .zero,
                              padding: .symmetric(vertical: 6, horizontal: 12),
                              backgroundColor: trade == e
                                  ? yellow
                                  : .lerp(Colors.black, Colors.white, .05),
                              foregroundColor: trade == e
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () async {
                              setState(() {
                                trade = e;
                              });

                              refresh();
                            },
                            child: Text(
                              e.l,
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],

        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.white60),
          onPressed: () {
            setState(() {
              toggle = !toggle;
            });
          },
          child: Row(
            spacing: 4,
            mainAxisSize: .min,
            children: [
              Text(toggle ? '접기' : '펼치기', style: TextStyle(fontSize: 12)),
              Icon(
                toggle ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool toggle = true;
}
