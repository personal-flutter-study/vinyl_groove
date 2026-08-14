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
  final camera = CameraController(
    cameras.where((element) => element.lensDirection == .back).first,
    .high,
  );

  final ba = TextEditingController();

  bool running = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await camera.initialize();

        setState(() {});

        camera.startImageStream((image) async {
          if (running) return;

          running = true;

          final bytes = image.planes[0].bytes;
          final width = image.width;
          final height = image.height;

          final rotates = Uint8List(height * width);

          int index = 0;

          for (var w = 0; w < width; ++w) {
            for (var h = height - 1; h >= 0; --h) {
              rotates[index++] = bytes[h * width + w];
            }
          }

          final res = await channelM.invokeMethod('scan', {
            'bytes': rotates,
            'width': width,
            'height': height,
          });

          if (res != null) {
            camera.stopImageStream();
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
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.close, color: Colors.white60, size: 32),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            '바코드 검색',
            style: TextStyle(fontWeight: .bold, color: Colors.white),
          ),
        ),
        backgroundColor: black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '상품의 바코드를 화면 중앙에 맞춰주세요',
                style: TextStyle(color: Colors.white60, fontWeight: .w500),
              ),
            ),

            Expanded(
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(child: CameraPreview(camera)),
                    Positioned.fill(
                      child: ColorFiltered(
                        colorFilter: .mode(Colors.black54, .srcOut),
                        child: Container(
                          color: Colors.transparent,
                          alignment: .center,
                          child: Container(
                            width: 250,
                            height: 125,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Builder(
                        builder: (context) {
                          final double w = 18;
                          final double h = 2;

                          return SizedBox(
                            height: 125,
                            width: 250,
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Divider(
                                      color: yellow.withAlpha(100),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: w,
                                    height: h,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: h,
                                    height: w,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: w,
                                    height: h,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: h,
                                    height: w,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: w,
                                    height: h,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: h,
                                    height: w,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: w,
                                    height: h,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: h,
                                    height: w,
                                    decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: .circular(8),
                                    ),
                                  ),
                                ),
                              ],
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
                      backgroundColor: black2,
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
                                fontSize: 18,
                                fontWeight: .bold,
                              ),
                            ),

                            TextField(
                              controller: ba,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: .circular(12),
                                ),
                                filled: true,
                                fillColor: black1,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AppIcon.barcode.icon(
                                    color: Colors.white60,
                                  ),
                                ),
                                hintStyle: TextStyle(color: Colors.white60),
                                hintText: '바코드를 입력해주세요.',
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
                                      padding: .symmetric(vertical: 16),
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
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: yellow,
                                      padding: .symmetric(vertical: 16),
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
                    AppIcon.barcode.icon(size: 18, color: Colors.white60),
                    Text('직접 입력', style: TextStyle(color: Colors.white60)),
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
