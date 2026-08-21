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
    cameras.firstWhere((element) => element.lensDirection == .back),
    .high,
    enableAudio: false,
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

          int index = 0;
          final rotates = Uint8List(width * height);

          for (int x = 0; x < width; x++) {
            for (int y = height - 1; y >= 0; y--) {
              rotates[index++] = bytes[y * width + x];
            }
          }

          final res = await channelM.invokeMethod('scan', {
            'bytes': rotates,
            'width': height,
            'height': width,
          });

          if (res != null) {
            camera.stopImageStream();
            context.back(res);
            return;
          }
          await Future.delayed(Duration(milliseconds: 600));
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
  void dispose() {
    camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            style: IconButton.styleFrom(),
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.close, color: Colors.white60, size: 32),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            '바코드 검색',
            style: TextStyle(
              color: Colors.white,
              fontWeight: .bold,
              fontSize: 20,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
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
                    Center(
                      child: ColorFiltered(
                        colorFilter: .mode(Colors.black54, .srcOut),
                        child: Container(
                          color: Colors.transparent,
                          alignment: .center,
                          child: Container(
                            color: Colors.black,
                            width: 280,
                            height: 160,
                          ),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Center(
                        child: Builder(
                          builder: (context) {
                            double w = 20;
                            double h = 3;
                            return ClipRRect(
                              borderRadius: .circular(4),
                              child: SizedBox(
                                width: 282,
                                height: 162,
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
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: w,
                                        height: h,
                                        color: yellow,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: h,
                                        height: w,
                                        color: yellow,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: w,
                                        height: h,
                                        color: yellow,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: h,
                                        height: w,
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
                        padding: const EdgeInsets.all(24.0),
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
                                fontSize: 24,
                              ),
                            ),
                            TextField(
                              controller: ba,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: black1,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: AppIcon.barcode.icon(
                                    color: Colors.white60,
                                  ),
                                ),
                                hintStyle: TextStyle(color: Colors.white60),
                                hintText: '바코드를 입력해주세요.',
                                border: OutlineInputBorder(
                                  borderRadius: .circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: .circular(12),
                                  borderSide: BorderSide(color: yellow),
                                ),
                              ),
                            ),

                            Row(
                              spacing: 24,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: yellow,
                                      foregroundColor: Colors.black,
                                      padding: .symmetric(vertical: 14),
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
                                      backgroundColor: yellow,
                                      foregroundColor: Colors.black,
                                      padding: .symmetric(vertical: 14),
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
                  mainAxisSize: .min,
                  spacing: 8,
                  children: [
                    AppIcon.barcode.icon(color: Colors.white60, size: 24),

                    Text(
                      '직접 입력',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        fontWeight: .w500,
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
