import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';

import 'main.dart';

final appCtrl = AppCtrl();

const lsk = 'lsk';

class AppCtrl {
  List<AlbumModel> likes = [];

  init() async {
    likes =
        (await prefs.getStringList(
          lsk,
        ))?.map((e) => AlbumModel.from(jsonDecode(e))).toList() ??
        [];
  }

  format(n) => "\₩${NumberFormat('###,###').format(n)}";

  final ValueNotifier<int> ticker = ValueNotifier(0);
  final ValueNotifier<int> page = ValueNotifier(0);

  String tkn = '';
  Map? user;

  //"user": { "id": 1, "email": "test@example.com", "name": "홍길동" }

  Genre? genre;

  //{ "page": 1, "size": 12, "totalCount": 50, "totalPages": 5, "hasNext": true }
  Future<Map?> loadAlbums({
    sort,
    limit,
    keyword,
    List? genres,
    List? conditions,
    minPrice,
    maxPrice,
    tradeMethod,
    page,
    size,
  }) {
    print(
      {
        'sort': sort?.toString(),
        'limit': limit?.toString(),
        'keyword': keyword?.toString(),
        'genres': genres?.where((e) => e.toString().isNotEmpty).join(','),
        'conditions': conditions
            ?.where((e) => e.toString().isNotEmpty)
            .join(','),
        'minPrice': minPrice?.toString(),
        'maxPrice': maxPrice?.toString(),
        'tradeMethod': tradeMethod?.toString(),
        'page': page?.toString(),
        'size': size?.toString(),
      }..removeWhere((key, value) => value == null),
    );

    return get(
      headers: authHeader,
      Uri.parse('http://${baseUrl}/products').replace(
        queryParameters: {
          'sort': sort?.toString(),
          'limit': limit?.toString(),
          'keyword': keyword?.toString(),
          'genres': genres?.where((e) => e.toString().isNotEmpty).join(','),
          'conditions': conditions
              ?.where((e) => e.toString().isNotEmpty)
              .join(','),
          'minPrice': minPrice?.toString(),
          'maxPrice': maxPrice?.toString(),
          'tradeMethod': tradeMethod?.toString(),
          'page': page?.toString(),
          'size': size?.toString(),
        }..removeWhere((key, value) => value == null),
      ),
    ).then((value) async {
      try {
        final body = jsonDecode(value.body);

        print(body);
        if (value.statusCode == 200) {
          body['data'] = (body['data'] as List)
              .map((e) => AlbumModel.from(e))
              .toList();

          return body;
        }
      } catch (e) {
        print(e);
      }
      return null;
    });
  }

  Future<dynamic> loadAlbumDetail(id) =>
      get(
        Uri.parse('http://${baseUrl}/products/${id}'),
        headers: authHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);
        if (value.statusCode == 200) {
          return body['data'];
        }
      });

  Future<dynamic> loadAlerts() =>
      get(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: authHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);
        if (value.statusCode == 200) {
          return body['data'];
        }
      });
}

enum Sort {
  popular('popular', '인기 매물순'),
  recent('recent', '최신 등록순'),
  price_asc('price_asc', '최저 가격순');

  final String v;
  final String l;

  const Sort(this.v, this.l);
}

enum Genre {
  WH('', '전체', AppIcon.rock),
  ROCK('ROCK', 'Rock', AppIcon.rock),
  JAZZ('JAZZ', 'Jazz', AppIcon.jazz),
  POP('POP', 'Pop', AppIcon.pop),
  HIPHOP('HIPHOP', 'Hip-Hop', AppIcon.hip),
  ELECTRONIC('ELECTRONIC', 'Electronic', AppIcon.electronic),
  CLASSICAL('CLASSICAL', 'Classical', AppIcon.classical),
  RNB_SOUL('RNB_SOUL', 'R&B/Soul', AppIcon.rnb),
  ETC('ETC', '기타', AppIcon.etc);

  final String v;
  final String l;
  final AppIcon i;

  const Genre(this.v, this.l, this.i);
}

enum Condition {
  WH('', "전체"),
  M('M', "M"),
  NM('NM', "NM"),
  VG('VG', "VG"),
  VG_P('VG+', "VG_P"),
  G('G', "G");

  final String v;
  final String l;

  const Condition(this.v, this.l);
}

enum Trade {
  WH('', "전체"),
  DIRECT('DIRECT', "직거래"),
  DELIVERY('DELIVERY', "택배"),
  BOTH('BOTH', "둘 다");

  final String v;
  final String l;

  const Trade(this.v, this.l);
}
