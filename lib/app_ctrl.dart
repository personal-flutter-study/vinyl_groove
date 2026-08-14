import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_3/main.dart';
import 'package:vinyl_groove_poc_3/models/album_model.dart';

final appCtrl = AppCtrl();

const keyL = 'keyL';

class AppCtrl {
  init() async {
    likes = (prefs.getStringList(keyL) ?? [])
        .map((e) => AlbumModel.from(jsonDecode(e)))
        .toList();
  }

  final ValueNotifier<int> page = ValueNotifier(0);
  final ValueNotifier<int> ticker = ValueNotifier(0);

  Future<void> save() async {
    await prefs.setStringList(
      keyL,
      likes.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  List<AlbumModel> likes = [];

  String? tkn;
  Map? user;

  Genre? genre;

  Future<Map?> loadStores({
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
      ).then((value) {
        final body = jsonDecode(value.body);

        if (value.statusCode == 200) {
          body['data'] = (body['data'] as List)
              .map((e) => AlbumModel.from(e))
              .toList();
          return body;
        }
        message((body['errors'] as List).first['message']);

        return null;
      });

  Map? alerts;

  Future<Map?> loadAlert() =>
      get(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: baseHeader,
      ).then((value) {
        final body = jsonDecode(value.body);

        if (value.statusCode == 200) {
          alerts = body['data'];
          ticker.value++;
          return;
        }
        message((body['errors'] as List).first['message']);

        return null;
      });
}

enum Sort {
  popular('popular', '인기 매물'),
  recent('recent', '최신 등록'),
  price_asc('price_asc', '가격 인하');

  final String v;
  final String l;

  const Sort(this.v, this.l);
}

enum Genre {
  ROCK('ROCK', 'Rock', AppIcon.rock),
  JAZZ('JAZZ', 'Jazz', AppIcon.jazz),
  POP('POP', 'Pop', AppIcon.pop),
  HIPHOP('HIPHOP', 'Hip-Hop', AppIcon.hip),
  ELECTRONIC('ELECTRONIC', 'Electronic', AppIcon.electronic),
  CLASSICAL('CLASSICAL', 'Classical', AppIcon.classical),
  RNB_SOUL('RNB_SOUL', 'R&B/Soul', AppIcon.rnb),
  ETC('ETC', 'Etc', AppIcon.etc);

  final String v;
  final String l;
  final AppIcon i;

  const Genre(this.v, this.l, this.i);
}

enum Con {
  M('M', ''),
  NM('NM', ''),
  VG_P('VG+', ''),
  VG('VG', ''),
  G('G', '');

  final String v;
  final String l;

  const Con(this.v, this.l);
}

enum Trade {
  DIRECT('DIRECT', '직거래'),
  DELIVERY('DELIVERY', '택배'),
  BOTH('BOTH', '둘 다');

  final String v;
  final String l;

  const Trade(this.v, this.l);
}
