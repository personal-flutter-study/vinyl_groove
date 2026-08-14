import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_6/main.dart';
import 'package:vinyl_groove_poc_6/screens/album_screen.dart';
import 'package:vinyl_groove_poc_6/screens/barcode_screen.dart';

class BarcodeWidget extends StatefulWidget {
  const BarcodeWidget({super.key});

  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        String? res = await context.go(BarcodeScreen());

        if (res != null) {
          res = res.padLeft(13, '0');

          get(
            Uri.parse('http://${baseUrl}/products?barcode=${res}'),
            headers: baseHeader,
          ).then((value) {
            try {
              final body = jsonDecode(value.body);
              if (body['success'] ?? false) {
                final data = body['data'] as List;

                if (data.isEmpty) {
                  message('바코드 "${res}"에 해당하는 상품을 찾을 수 없습니다');
                  return;
                }
                context.go(AlbumScreen(id: data.first['id']));

                return;
              }
              message((body['errors'] as List?)?.first['message']);
            } catch (e) {
              message("서버 통신 에러");
            }
          }, onError: (e) => message("서버 통신 에러"));
        }

        //message('바코드 검색은 준비중입니다.');
      },
      icon: AppIcon.barcode.icon(color: Colors.white60),
    );
  }
}
