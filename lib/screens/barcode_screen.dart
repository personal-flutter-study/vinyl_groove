import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  final cameraController = CameraController(
    cameras.where((element) => element.lensDirection == .back).first,
    .high,
  );

  final ba = TextEditingController();

  bool running = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await cameraController.initialize();
        setState(() {});

        cameraController.startImageStream((image) async {
          if (running) return;

          running = true;

          final bytes = image.planes[0].bytes;
          final width = image.width;
          final height = image.height;

          final rotates = Uint8List(width * height);
          int index = 0;

          for (var x = 0; x < width; ++x) {
            for (var y = height - 1; y >= 0; --y) {
              rotates[index++] = bytes[y * width + x];
            }
          }

          final res = await channelM.invokeMethod('scan', {
            'bytes': rotates,
            'width': image.width,
            'height': image.height,
          });

          if (res != null) {
            cameraController.stopImageStream();
            context.back(res);
            return;
          }

          await Future.delayed(Duration(milliseconds: 800));

          running = false;
        });
      } catch (e) {
        message('카메라 권한이 필요합니다');
        context.back();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            style: IconButton.styleFrom(foregroundColor: Colors.white60),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.close, size: 32),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            '바코드 검색',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        backgroundColor: black,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '상품의 바코드를 화면 중앙에 맞춰주세요',
                style: TextStyle(color: Colors.white60, fontWeight: .bold),
              ),
            ),

            Expanded(
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(child: CameraPreview(cameraController)),

                    Positioned.fill(
                      child: RepaintBoundary(
                        child: ColorFiltered(
                          colorFilter: .mode(black.withAlpha(180), .srcOut),
                          child: Container(
                            color: Colors.transparent,
                            alignment: .center,
                            child: Container(
                              width: 250,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: .circular(4),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Builder(
                        builder: (context) {
                          final double h = 3;
                          final double w = 18;

                          return ClipRRect(
                            borderRadius: .circular(4),
                            child: SizedBox(
                              width: 250,
                              height: 150,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Divider(
                                      color: yellow.withAlpha(100),
                                    ),
                                  ),

                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: w,
                                      height: h,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: h,
                                      height: w,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: w,
                                      height: h,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: h,
                                      height: w,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: w,
                                      height: h,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: h,
                                      height: w,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: h,
                                      height: w,
                                      color: yellow,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: w,
                                      height: h,
                                      color: yellow,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: black3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          spacing: 24,
                          children: [
                            Text(
                              '바코드 직접 입력',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: .bold,
                                fontSize: 18,
                              ),
                            ),
                            TextField(
                              controller: ba,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: .circular(12),
                                ),
                                hintStyle: TextStyle(color: Colors.white60),
                                hintText: '바코드를 입력해주세요.',
                                filled: true,
                                fillColor: black1,
                              ),
                            ),

                            Row(
                              spacing: 12,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: yellow,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      context.back();
                                    },
                                    child: Row(
                                      mainAxisAlignment: .center,
                                      children: [
                                        Text(
                                          '취소',
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: yellow,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      context.back();
                                      context.back(ba.text);
                                    },
                                    child: Row(
                                      mainAxisAlignment: .center,
                                      children: [
                                        Text(
                                          '검색',
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  spacing: 8,
                  mainAxisSize: .min,
                  children: [
                    AppIcon.barcode.icon(color: Colors.white60, size: 24),
                    Text(
                      '직접 입력',
                      style: TextStyle(
                        color: Colors.white60,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
