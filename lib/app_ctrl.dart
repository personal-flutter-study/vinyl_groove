import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_7/main.dart';
import 'package:vinyl_groove_poc_7/models/album_model.dart';

final appCtrl = AppCtrl();

const keyL = 'keyL';

class AppCtrl {
  final ValueNotifier<int> page = ValueNotifier(0);
  final ValueNotifier<int> ticker = ValueNotifier(0);
  final ValueNotifier<int> ticker2 = ValueNotifier(0);

  init() async {
    likes = (prefs.getStringList(keyL) ?? [])
        .map((e) => AlbumModel.from(jsonDecode(e)))
        .toList();
  }

  String? tkn;
  Map? user;
  Genre? genre;

  List<AlbumModel> likes = [];

  Future<void> save() async {
    await prefs.setStringList(
      keyL,
      likes.map((e) => jsonEncode(e.toJson())).toList(),
    );
    ticker.value++;
  }

  Future<Map?> loadAlbums({
    sort,
    limit,
    keyword,
    genres,
    conditions,
    minPrice,
    maxPrice,
    tradeMethod,
    page,
    size,
  }) =>
      get(
        Uri.parse('http://${baseUrl}/products').replace(
          queryParameters: {
            'sort': sort?.toString(),
            'limit': limit?.toString(),
            'keyword': keyword?.toString(),
            'genres': genres?.toString(),
            'conditions': conditions?.toString(),
            'minPrice': minPrice?.toString(),
            'maxPrice': maxPrice?.toString(),
            'tradeMethod': tradeMethod?.toString(),
            'page': page?.toString(),
            'size': size?.toString(),
          }..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          body['data'] = (body['data'] as List)
              .map((e) => AlbumModel.from(e))
              .toList();

          return body;
        }

        message((body['errors'] as List).firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));

  Map? alerts;

  Future<Map?> loadAlerts() =>
      get(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: baseHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);
        if (body['success'] ?? false) {
          alerts = body['data'];
          ticker2.value++;
          return;
        }

        message((body['errors'] as List).firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));
}

enum Genre {
  ROCK('ROCK', 'Rock', .rock),
  JAZZ('JAZZ', 'Jazz', .jazz),
  POP('POP', 'Pop', .pop),
  HIPHOP('HIPHOP', 'Hip-Hop', .hip),
  ELECTRONIC('ELECTRONIC', 'Electronic', .electronic),
  CLASSICAL('CLASSICAL', 'Classical', .classical),
  RNB_SOUL('RNB_SOUL', 'R&B/Soul', .rnb),
  ETC('ETC', 'Etc', .etc);

  final String v;
  final String l;
  final AppIcon i;

  const Genre(this.v, this.l, this.i);
}

enum Sort {
  popular('popular', '인기 매물'),
  recent('recent', '최신 등록'),
  price_asc('price_asc', '가격 인하');

  final String v;
  final String l;

  const Sort(this.v, this.l);
}

enum Trade {
  DIRECT('DIRECT', '직거래'),
  DELIVERY('DELIVERY', '택배'),
  BOTH('BOTH', '둘 다');

  final String v;
  final String l;

  const Trade(this.v, this.l);
}
