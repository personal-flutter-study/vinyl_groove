import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vinyl_groove_poc_5/main.dart' as app;

class MockImage extends ImagePickerPlatform with MockPlatformInterfaceMixin {
  @override
  Future<XFile> getImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    final data = await rootBundle.load('assets/vinyl_sample.png');

    return Future.value(
      XFile.fromData(
        data.buffer.asUint8List(),
        mimeType: 'image/png',
        name: 'vinyl_sample.png',
      ),
    );
  }
}

void main() async {
  int index = 0;

  Future section(m, Future Function() action, WidgetTester tester) async {
    print('[STEP No.${++index}] ${m}');

    await tester.pumpAndSettle();

    await action();

    await tester.pumpAndSettle();

    await Future.delayed(Duration(milliseconds: 200));
  }

  ImagePickerPlatform.instance = MockImage();

  testWidgets('t2', (tester) async {
    await section('애플리케이션 실행', () async {
      app.main();

      await Future.delayed(Duration(seconds: 1));
    }, tester);

    await section('로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);
      final f3 = find.byType(ElevatedButton).first;

      await tester.ensureVisible(f1);
      await tester.enterText(f1, 'test@example.com');
      await tester.ensureVisible(f2);
      await tester.enterText(f2, 'Test1234!');
      await tester.ensureVisible(f3);
      await tester.tap(f3);
    }, tester);
    await section('하단 네비게이션 상품 등록 진입 버튼 클릭', () async {
      final f1 = find.byType(CircleAvatar).last;

      await tester.tap(f1);

      await Future.delayed(Duration(seconds: 3));
    }, tester);

    await section('"등록하기" 버튼 클릭', () async {
      final f1 = find.text('등록하기').first;

      await tester.ensureVisible(f1);
      await tester.tap(f1);
    }, tester);

    await section('이미지 영역 클릭 후 “갤러리에서 선택” 메뉴 선택하여 이미지 선택', () async {
      final f1 = find.byType(Container).first;
      final f2 = find.text('갤러리에서 선택').first;

      await tester.ensureVisible(f1);
      await tester.tap(f1);
      await tester.pumpAndSettle();
      await tester.tap(f2);
    }, tester);

    await section('앨범명 입력상자 선택 후 앨범명 입력', () async {
      final f1 = find.byType(TextField).at(0);
      await tester.ensureVisible(f1);
      await tester.enterText(f1, 'Test Vinyl Album');
    }, tester);
    await section('아티스트 입력상자 선택 후 아티스트 입력', () async {
      final f1 = find.byType(TextField).at(1);
      await tester.ensureVisible(f1);
      await tester.enterText(f1, 'Test Artist');
    }, tester);
    await section('가격 입력 상자 선택 후 가격 입력', () async {
      final f1 = find.byType(TextField).at(2);
      await tester.ensureVisible(f1);
      await tester.enterText(f1, '500');
    }, tester);
    await section('상품 설명 상자 선택 후 상품 설명 입력', () async {
      final f1 = find.byType(TextField).at(3);
      await tester.ensureVisible(f1);
      await tester.enterText(f1, '테스트용 바이닐 앨범입니다.');
    }, tester);

    await section('"등록하기" 버튼 클릭', () async {
      final f1 = find.text('등록하기').first;

      await tester.ensureVisible(f1);
      await tester.tap(f1);
    }, tester);
    await section('가격 입력 상자 선택 후 새 가격 입력', () async {
      final f1 = find.byType(TextField).at(2);
      await tester.ensureVisible(f1);
      await tester.enterText(f1, '4500');
    }, tester);

    await section('"등록하기" 버튼 클릭', () async {
      final f1 = find.text('등록하기').first;

      await tester.ensureVisible(f1);
      await tester.tap(f1);

      await Future.delayed(Duration(seconds: 2));
    }, tester);

    await section('하단 네비게이션 "마이페이지" 탭 클릭', () async {
      final f1 = find.text('마이페이지');

      await tester.tap(f1);
    }, tester);

    await section('"내 등록 상품" 메뉴 클릭', () async {
      final f1 = find.text('내 등록 상품');

      await tester.tap(f1);
    }, tester);
    await section('등록된 첫 번째 상품 아이템 리스트에 표시 확인', () async {}, tester);
    await section('첫 번째 상품 아이템 삭제 아이콘 버튼 클릭', () async {
      final f1 = find
          .descendant(
            of: find.byType(Material).first,
            matching: find.byType(IconButton).at(1),
          )
          .first;

      await tester.tap(f1);
    }, tester);

    await section('다이얼로그의 "삭제" 버튼 클릭', () async {
      final f1 = find.text('삭제').last;
      await tester.tap(f1);
      await Future.delayed(Duration(seconds: 1));
    }, tester);

    await section('등록 상품 목록 빈 상태 확인', () async {
      await Future.delayed(Duration(seconds: 1));
    }, tester);

    await section('뒤로가기 버튼 클릭', () async {
      final f1 = find.byIcon(Icons.arrow_back).first;
      await tester.ensureVisible(f1);
      await tester.tap(f1);
    }, tester);

    await section('"로그아웃" 버튼 클릭', () async {
      final f1 = find.text('로그아웃').last;
      await tester.ensureVisible(f1);
      await tester.tap(f1);
    }, tester);

    await section('로그아웃 확인 다이얼로그의 "로그아웃" 버튼 클릭', () async {
      final f1 = find.text('로그아웃').last;
      await tester.ensureVisible(f1);
      await tester.tap(f1);
      await Future.delayed(Duration(seconds: 1));
    }, tester);

    await section('로그인 화면 정상 표시 확인', () async {}, tester);
  });
}
