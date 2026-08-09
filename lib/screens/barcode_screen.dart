import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove_poc_1/app_ctrl.dart';
import 'package:vinyl_groove_poc_1/models/album_model.dart';
import 'package:vinyl_groove_poc_1/screens/album_screen.dart';

import '../main.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late final CameraController camera;

  final sr = TextEditingController();

  search(t) =>
      get(
        Uri.parse('http://${baseUrl}/products').replace(
          queryParameters: {'barcode': t?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: authHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);
        if (value.statusCode == 200) {
          final res = (body['data'] as List);

          sr.clear();

          if (res.isEmpty) {
            context.message('바코드 "$t"에 해당하는 상품을 찾을 수 없습니다');
            return false;
          }

          context.back(res);

          return true;
        }
      });

  bool scanning = false;

  @override
  void initState() {
    camera = CameraController(
      cameras.where((element) => element.lensDirection == .back).first,
      .high,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await camera.initialize();
        setState(() {});

        camera.startImageStream((image) async {
          if (scanning) return;
          scanning = true;

          try {
            final res = await channelM.invokeMethod('scan', {
              'bytes': image.planes[0].bytes,
              'width': image.width,
              'height': image.height,
              "rowStride": image.planes[0].bytesPerRow,
            });

            print(res);

            if (res != null) {
              camera.stopImageStream();
              await search(res);
            }
          } catch (e) {
            print(e);
          }

          await Future.delayed(Duration(milliseconds: 500));

          scanning = false;
        });
      } catch (e) {
        print(e);
        context.message('카메라 권한이 필요합니다');
        context.back();
        return;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.close, color: Colors.white60, size: 32),
          ),
          centerTitle: true,
          title: Text(
            '바코드 검색',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '상품의 바코드를 화면 중앙에 맞춰주세요',
                  style: TextStyle(fontWeight: .bold, color: Colors.white60),
                ),
              ),

              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: CameraPreview(camera)),

                    ColorFiltered(
                      colorFilter: .mode(Colors.black.withAlpha(200), .srcOut),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withAlpha(100),
                            ),
                          ),

                          Center(
                            child: Container(
                              color: Colors.white,
                              height: 150,
                              width: 250,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Center(child: barcodeBox()),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  spacing: 12,
                  mainAxisAlignment: .center,
                  children: [
                    AppIcon.barcodescan.icon(color: Colors.white60, width: 24),

                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: black,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontWeight: .bold,
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: .min,
                                  crossAxisAlignment: .start,
                                  spacing: 24,
                                  children: [
                                    Text(
                                      '바코드 직접 입력',
                                      style: TextStyle(fontSize: 18),
                                    ),

                                    TextField(
                                      controller: sr,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        fillColor: .lerp(
                                          Colors.black,
                                          Colors.white,
                                          .05,
                                        ),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: .circular(12),
                                        ),

                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                        ),
                                        hintText: '바코드를 입력해주세요.',
                                      ),
                                    ),

                                    Row(
                                      spacing: 12,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: yellow,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: .circular(12),
                                              ),
                                              padding: .symmetric(vertical: 16),
                                            ),
                                            onPressed: () async {
                                              if (await search(sr.text) ==
                                                  false) {
                                                context.back();
                                              }
                                            },
                                            child: Text(
                                              '검색',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: yellow,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: .circular(12),
                                              ),
                                              padding: .symmetric(vertical: 16),
                                            ),
                                            onPressed: () async {
                                              context.back();
                                            },
                                            child: Text(
                                              '취소',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '직접 입력',
                        style: TextStyle(
                          color: Colors.white60,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox barcodeBox() {
    return SizedBox(
      height: 150,
      width: 250,
      child: Stack(
        children: [
          Center(child: Divider(thickness: 1.5, color: yellow)),

          Positioned(
            top: 0,
            left: 0,
            child: Container(height: 12, width: 2, color: yellow),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(height: 2, width: 12, color: yellow),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(height: 12, width: 2, color: yellow),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(height: 2, width: 12, color: yellow),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(height: 12, width: 2, color: yellow),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(height: 2, width: 12, color: yellow),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(height: 12, width: 2, color: yellow),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(height: 2, width: 12, color: yellow),
          ),
        ],
      ),
    );
  }
}
