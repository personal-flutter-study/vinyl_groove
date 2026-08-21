import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_14/main.dart';
import 'package:vinyl_groove_poc_14/screens/album_screen.dart';
import 'package:vinyl_groove_poc_14/screens/barcode_screen.dart';

class BarcodeButton extends StatefulWidget {
  const BarcodeButton({super.key});

  @override
  State<BarcodeButton> createState() => _BarcodeButtonState();
}

class _BarcodeButtonState extends State<BarcodeButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(),
      onPressed: () async {
        String? res = await context.go(BarcodeScreen());

        if (res != null) {
          res = res.padLeft(13, '0');
          get(
            Uri.parse('http://${baseUrl}/products?barcode=${res}'),
            headers: baseHeader,
          ).then((value) {
            final body = jsonDecode(value.body);

            if (body['success'] ?? false) {
              final data = body['data'] as List;

              if (data.isEmpty) {
                message('바코드 "${res}"에\n해당하는 상품을 찾을 수 없습니다');
                return;
              }

              context.go(AlbumScreen(id: data.first['id']));

              return body;
            }

            message((body['errors'] as List?)?.firstOrNull['message']);
          }, onError: (e) => message('서버 통신 오류'));
        }

        //message('바코드 검색', g: true);
      },
      icon: Image.asset('assets/img.png', width: 24, fit: .cover),
    );
  }
}
