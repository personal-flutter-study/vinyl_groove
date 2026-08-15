import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove_poc_7/main.dart' as app;
import 'package:vinyl_groove_poc_7/widgets/album_card.dart';
import 'package:vinyl_groove_poc_7/widgets/like_button.dart';

void main() {
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

  testWidgets('test', (tester) async {
    await sec('애플리케이션 실행', () async {
      app.main();

      await Future.delayed(Duration(seconds: 2));
    }, tester);
    await sec('잘못된 이메일 형식으로 로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);
      final f3 = find.byType(ElevatedButton).last;

      await vis(f1, tester);
      await tester.enterText(f1, 'invalid-email');
      await vis(f2, tester);
      await tester.enterText(f2, 'Test1234!');
      await vis(f3, tester);
      await tester.tap(f3);
    }, tester);

    await sec('입력 필드 초기화 후 짧은 비밀번호로 로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);
      final f3 = find.byType(ElevatedButton).last;

      await vis(f1, tester);
      await tester.enterText(f1, 'test@example.com');
      await vis(f2, tester);
      await tester.enterText(f2, '123');
      await vis(f3, tester);
      await tester.tap(f3);
    }, tester);

    await sec('입력 필드 초기화 후 정상 값으로 로그인 시도', () async {
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

    await sec('하단 네비게이션의 "탐색" 탭 클릭', () async {
      final f1 = find.text('탐색').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('장르 필터 순차 클릭', () async {
      final f1 = find.text('Rock').first;
      final f2 = find.text('Jazz').first;
      await vis(f1, tester);
      await tester.tap(f1);
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);

    await sec('음반 상태 필터 순차 클릭', () async {
      final f1 = find.text('NM').first;
      final f2 = find.text('VG+').first;
      await vis(f1, tester);
      await tester.tap(f1);
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);
    await sec('"접기" 버튼 클릭', () async {
      final f1 = find.text('접기').first;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('정렬 드롭다운 선택', () async {
      final f1 = find
          .byWidgetPredicate((widget) => widget is PopupMenuButton)
          .first;
      await vis(f1, tester);
      await tester.tap(f1);

      final f2 = find.text('인기 매물순').last;
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);
    await sec('아래로 스크롤하여 15번째 상품 아이템까지 이동', () async {
      final f1 = find.byType(AlbumCard, skipOffstage: false);
      final scroll = find.byType(SingleChildScrollView).first;
      await () async {
        while (f1.evaluate().length < 16) {
          await tester.drag(scroll, .new(0, -500));
          await Future.delayed(Duration(seconds: 1));
          await tester.pumpAndSettle();
        }
      }().timeout(Duration(seconds: 5));

      await tester.dragUntilVisible(f1.at(14), scroll, .new(0, -100));
    }, tester);

    await sec('15번째 상품 아이템 클릭', () async {
      final f1 = find.byType(AlbumCard, skipOffstage: false).at(14);

      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);
    await sec('앱바 우측 관심 아이콘 버튼 클릭', () async {
      final f1 = find.byType(LikeButton).at(0);

      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);
    await sec('뒤로가기 버튼 클릭 후 하단 네비게이션 “관심상품“ 탭 클릭', () async {
      final f1 = find.byIcon(Icons.arrow_back).first;

      await vis(f1, tester);
      await tester.tap(f1);

      await tester.pumpAndSettle();

      final f2 = find.text('관심상품').last;
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);

    await sec('등록된 관심 상품 아이템 리스트 표시 확인', () async {}, tester);

    await sec('첫 번째 아이템의 관심(하트) 아이콘 버튼 클릭', () async {
      final f1 = find.byType(LikeButton).first;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('비활성화 관심 상품 아이템 리스트 표시 확인', () async {}, tester);

    await sec('하단 네비게이션 "홈" 탭 클릭', () async {
      final f1 = find.text('홈').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);
    await sec('하단 네비게이션 "관심상품" 탭 클릭', () async {
      final f1 = find.text('관심상품').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);
    await sec('비활성화 관심 상품 아이템 리스트 제거 확인', () async {}, tester);
  });
}
