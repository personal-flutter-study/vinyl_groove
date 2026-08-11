import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove_poc_1/main.dart' as app;
import 'package:vinyl_groove_poc_1/widgets/like_button.dart';

void main() {
  int index = 0;

  Future section(m, Future Function() act, WidgetTester tester) async {
    index++;
    print('[STEP No.${index}] ${m}');
    await tester.pumpAndSettle();
    await act();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));
  }

  testWidgets('test1', (tester) async {
    await section('애플리케이션 실행', () async {
      app.main();
    }, tester);
    await section('잘못된 이메일 형식으로 로그인 시도', () async {
      final f1 = find.byType(TextField).first;
      final f2 = find.byType(TextField).at(1);
      await tester.enterText(f1, 'invalid-email');
      await tester.enterText(f2, 'Test1234!');
      final b1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(b1);
      await tester.tap(b1);
    }, tester);
    await section('입력 필드 초기화 후 짧은 비밀번호로 로그인 시도', () async {
      final f1 = find.byType(TextField).first;
      final f2 = find.byType(TextField).at(1);
      await tester.enterText(f1, 'test@example.com');
      await tester.enterText(f2, '123');
      final b1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(b1);
      await tester.tap(b1);
    }, tester);
    await section('입력 필드 초기화 후 정상 값으로 로그인 시도', () async {
      final f1 = find.byType(TextField).first;
      final f2 = find.byType(TextField).at(1);
      await tester.enterText(f1, 'test@example.com');
      await tester.enterText(f2, 'Test1234!');
      final b1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(b1);
      await tester.tap(b1);
    }, tester);

    await section('하단 네비게이션의 "탐색" 탭 클릭', () async {
      final f1 = find.text('탐색').first;
      await tester.tap(f1);
    }, tester);

    await section('장르 필터 순차 클릭', () async {
      final f1 = find.text('Rock').first;
      final f2 = find.text('Jazz').first;

      await tester.ensureVisible(f1);
      await tester.ensureVisible(f2);
      await tester.tap(f1);
      await tester.tap(f2);
    }, tester);

    await section('음반 상태 필터 순차 클릭', () async {
      final scroll = find.byType(SingleChildScrollView).at(2);

      final f1 = find
          .descendant(
            of: find.byType(ElevatedButton),
            matching: find.text('NM'),
          )
          .first;
      final f2 = find
          .descendant(
            of: find.byType(ElevatedButton),
            matching: find.text('VG+'),
          )
          .first;

      await tester.dragUntilVisible(f1, scroll, .new(-100, 0));
      await tester.tap(f1);
      await tester.dragUntilVisible(f2, scroll, .new(-100, 0));
      await tester.tap(f2);
    }, tester);

    await section('"접기" 버튼 클릭', () async {
      final f1 = find.text('접기').first;
      await tester.ensureVisible(f1);
      await tester.tap(f1);
    }, tester);

    await section('정렬 드롭다운 선택', () async {
      final f1 = find
          .byWidgetPredicate((widget) => widget is PopupMenuButton)
          .first;

      await tester.ensureVisible(f1);
      await tester.tap(f1);
      await tester.pumpAndSettle();
      final f2 = find.text('인기 매물순').first;
      await tester.tap(f2);
    }, tester);

    await section('아래로 스크롤하여 15번째 상품 아이템까지 이동', () async {
      final scroll = find.byType(SingleChildScrollView).first;
      await tester.drag(scroll, .new(0, -1000));
      await Future.delayed(Duration(seconds: 3));
      await tester.pumpAndSettle();
      final f1 = find.byType(Image).at(15);
      await tester.dragUntilVisible(
        f1,
        scroll,
        .new(0, -100),
        duration: Duration(seconds: 5),
      );
    }, tester);

    await section('15번째 상품 아이템 클릭', () async {
      final f1 = find.byType(Image).at(15);
      await tester.tap(f1);
      await Future.delayed(Duration(seconds: 2));
    }, tester);

    await section('앱바 우측 관심 아이콘 버튼 클릭', () async {
      final f1 = find.byType(LikeButton).first;
      await tester.ensureVisible(f1);
      await tester.tap(f1);
    }, tester);
    await section('뒤로가기 버튼 클릭 후 하단 네비게이션 “관심상품“ 탭 클릭', () async {
      final f1 = find.byType(IconButton).at(0);
      await tester.tap(f1);

      await tester.pumpAndSettle();

      final f2 = find.text('관심상품');
      await tester.tap(f2);
    }, tester);
    await section('첫 번째 아이템의 관심(하트) 아이콘 버튼 클릭', () async {
      final f1 = find.byType(IconButton).at(0);
      await tester.tap(f1);
    }, tester);
    await section('비활성화 관심 상품 아이템 리스트 표시 확인', () async {}, tester);
    await section('하단 네비게이션 "홈" 탭 클릭', () async {
      final f1 = find.text('홈');
      await tester.tap(f1);
    }, tester);
    await section('하단 네비게이션 "관심상품" 탭 클릭', () async {
      final f1 = find.text('관심상품');
      await tester.tap(f1);
    }, tester);
    await section('비활성화 관심 상품 아이템 리스트 제거 확인', () async {}, tester);
  });
}
