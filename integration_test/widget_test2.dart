import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vinyl_groove_poc_4/main.dart' as app;

class Mock extends ImagePickerPlatform with MockPlatformInterfaceMixin {
  @override
  Future<XFile> getImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    final bytes = (await rootBundle.load(
      'assets/vinyl_sample.png',
    )).buffer.asUint8List();

    return XFile.fromData(
      bytes,
      name: 'vinyl_sample.png',
      mimeType: 'image/png',
    );
  }
}

void main() async {
  int index = 0;
  sec(m, Future Function() act, WidgetTester tester) async {
    print('[STEP No.${++index}] ${m}');

    await tester.pumpAndSettle();
    await act();

    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
  }

  vis(Finder f, WidgetTester tester) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
  }

  ImagePickerPlatform.instance = Mock();

  testWidgets('test', (tester) async {
    await sec('애플리케이션 실행', () async {
      app.main();

      await Future.delayed(Duration(seconds: 2));
    }, tester);

    await sec('로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);

      final f3 = find.byType(ElevatedButton).last;

      await vis(f1, tester);
      await tester.enterText(f1, 'test@example.com');
      await vis(f2, tester);
      await tester.enterText(f2, 'Test1234!');

      await vis(f3, tester);
      await tester.tap(f3);
      await Future.delayed(Duration(seconds: 2));
    }, tester);

    await sec('하단 네비게이션 상품 등록 진입 버튼 클릭', () async {
      final f1 = find.byType(CircleAvatar).last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('"등록하기" 버튼 클릭', () async {
      final f1 = find.text('등록하기').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('이미지 영역 클릭 후 “갤러리에서 선택” 메뉴 선택하여 이미지 선택', () async {
      final f1 = find.byType(Container).first;
      await vis(f1, tester);
      await tester.tap(f1);

      await tester.pumpAndSettle();

      final f2 = find.text('갤러리에서 선택').last;
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);

    await sec('앨범명 입력상자 선택 후 앨범명 입력', () async {
      final f1 = find.byType(TextField).at(0);
      await vis(f1, tester);
      await tester.enterText(f1, 'Test Vinyl Album');
    }, tester);

    await sec('아티스트 입력상자 선택 후 아티스트 입력', () async {
      final f1 = find.byType(TextField).at(1);
      await vis(f1, tester);
      await tester.enterText(f1, 'Test Artist');
    }, tester);

    await sec('가격 입력 상자 선택 후 가격 입력', () async {
      final f1 = find.byType(TextField).at(2);
      await vis(f1, tester);
      await tester.enterText(f1, '500');
    }, tester);

    await sec('상품 설명 상자 선택 후 상품 설명 입력', () async {
      final f1 = find.byType(TextField).at(4);
      await vis(f1, tester);
      await tester.enterText(f1, '테스트용 바이닐 앨범입니다.');
    }, tester);

    await sec('"등록하기" 버튼 클릭', () async {
      final f1 = find.text('등록하기').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('가격 입력 상자 선택 후 새 가격 입력', () async {
      final f1 = find.byType(TextField).at(2);
      await vis(f1, tester);
      await tester.enterText(f1, '45000');
    }, tester);

    await sec('"등록하기" 버튼 클릭', () async {
      final f1 = find.text('등록하기').last;
      await vis(f1, tester);
      await tester.tap(f1);
      await Future.delayed(Duration(seconds: 4));
    }, tester);

    await sec('하단 네비게이션 "마이페이지" 탭 클릭', () async {
      final f1 = find.text('마이페이지').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('"내 등록 상품" 메뉴 클릭', () async {
      final f1 = find.text('내 등록 상품').first;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('등록된 첫 번째 상품 아이템 리스트에 표시 확인', () async {}, tester);
    await sec('첫 번째 상품 아이템 삭제 아이콘 버튼 클릭', () async {
      final f1 = find
          .descendant(
            of: find.byType(Material).first,
            matching: find.byType(IconButton).at(1),
          )
          .first;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('다이얼로그의 "삭제" 버튼 클릭', () async {
      final f1 = find.text('삭제').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('등록 상품 목록 빈 상태 확인', () async {}, tester);

    await sec('뒤로가기 버튼 클릭', () async {
      final f1 = find.byIcon(Icons.arrow_back).first;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('"로그아웃" 버튼 클릭', () async {
      final f1 = find.text('로그아웃').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);
    await sec('로그아웃 확인 다이얼로그의 "로그아웃" 버튼 클릭', () async {
      final f1 = find.text('로그아웃').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('로그인 화면 정상 표시 확인', () async {}, tester);
  });
}
