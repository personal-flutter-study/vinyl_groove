import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_2/screens/album_screen.dart';

import '../main.dart';
import '../screens/barcode_screen.dart';

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
        String? barcode = await context.go(BarcodeScreen());
        if (barcode == null) return;
        barcode = barcode.padLeft(13, '0');
        get(
          Uri.parse(
            'http://${baseUrl}/products',
          ).replace(queryParameters: {'barcode': barcode}),
          headers: baseHeader,
        ).then((value) {
          try {
            final body = jsonDecode(value.body);

            if (value.statusCode == 200) {
              final data = body['data'] as List;

              if (data.isEmpty) {
                message('"${barcode}"에 해당하는 상품을 찾을 수 없습니다');
                return;
              }

              context.go(AlbumScreen(id: data.first['id']));

              return;
            }
          } catch (e) {
            print(e);
          }
          return null;
        });
      },
      icon: Image.asset('assets/img.png', width: 24, fit: .cover),
    );
  }
}
