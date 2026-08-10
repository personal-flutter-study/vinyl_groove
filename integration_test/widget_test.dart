import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove_poc_1/main.dart' as app;

void main() {
  int index = 0;

  Future section(m, Future Function() act, WidgetTester tester) async {
    index++;
    print('[STEP No.${index}] ${m}');
    await tester.pumpAndSettle();
    await act();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(milliseconds: 600));
  }

  testWidgets('test1', (tester) async {
    await section('애플리케이션 실행', () async {
      app.main();
    }, tester);
    await section('잘못된 이메일 형식으로 로그인 시도', () async {
      final f1 = find.byType(TextField).first;
      final f2 = find.byType(TextField).at(1);
      await tester.enterText(f1, 'invalid-email');
      await tester.enterText(f1, 'Test1234!');
      final b1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(b1);
      await tester.tap(b1);
    }, tester);
    await section('입력 필드 초기화 후 짧은 비밀번호로 로그인 시도', () async {
      final f1 = find.byType(TextField).first;
      final f2 = find.byType(TextField).at(1);
      await tester.enterText(f1, 'test@example.com');
      await tester.enterText(f1, '123');
      final b1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(b1);
      await tester.tap(b1);
    }, tester);
    await section('입력 필드 초기화 후 정상 값으로 로그인 시도', () async {
      final f1 = find.byType(TextField).first;
      final f2 = find.byType(TextField).at(1);
      await tester.enterText(f1, 'test@example.com');
      tester.enterText(f1, 'Test1234!');
      final b1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(b1);
      await tester.tap(b1);
    }, tester);

    await section('하단 네비게이션의 "탐색" 탭 클릭', () async {
      final f1 = find.byType(BottomNavigationBarItem).at(1);
      await tester.tap(f1);
    }, tester);

    await section('장르 필터 순차 클릭', () async {
      final f1 = find.text('Rock').first;
      final f2 = find.text('Jazz').first;
      await tester.tap(f1);
      await tester.tap(f2);
    }, tester);

    await section('음반 상태 필터 순차 클릭', () async {
      final f1 = find.text('NM').first;
      final f2 = find.text('VG+').first;
      await tester.tap(f1);
      await tester.tap(f2);
    }, tester);

    await section('"접기" 버튼 클릭', () async {
      final f1 = find.text('접기').first;
      await tester.tap(f1);
    }, tester);

    await section('정렬 드롭다운 선택', () async {
      final f1 = find.byType(PopupMenuButton).first;
      final f2 = find.text('인기 매물순').first;
      await tester.tap(f1);
      await tester.pumpAndSettle();
      await tester.tap(f2);
    }, tester);

    await section('아래로 스크롤하여 15번째 상품 아이템까지 이동', () async {
      final f1 = find.byType(Image).at(15);
      await tester.scrollUntilVisible(f1, 10, duration: Duration(seconds: 5));
    }, tester);
  });
}
