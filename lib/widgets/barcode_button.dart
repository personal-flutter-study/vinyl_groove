import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_5/main.dart';
import 'package:vinyl_groove_poc_5/screens/album_screen.dart';
import 'package:vinyl_groove_poc_5/screens/barcode_screen.dart';

class BarcodeButton extends StatefulWidget {
  const BarcodeButton({super.key});

  @override
  State<BarcodeButton> createState() => _BarcodeButtonState();
}

class _BarcodeButtonState extends State<BarcodeButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        String? res = await context.go(BarcodeScreen());

        if (res != null) {
          res = res.padLeft(13, "0");

          get(
            Uri.parse('http://${baseUrl}/products?barcode=${res}'),
            headers: baseHeader,
          ).then((value) {
            try {
              final body = jsonDecode(value.body);

              if (value.statusCode == 200) {
                final data = body['data'] as List;

                if (data.isEmpty) {
                  message('바코드 "${res}"에 해당하는 상품을 찾을 수 없습니다');
                  return;
                }
                context.go(AlbumScreen(id: data.first['id']));

                return body['data'];
              }
              message((body['errors'] as List).first['message']);
            } catch (e) {
              print(e);
            }
            return null;
          });
        }

        //message('바코드 검색은 준비중입니다.');
      },
      icon: AppIcon.barcode.icon(color: Colors.white60),
    );
  }
}
