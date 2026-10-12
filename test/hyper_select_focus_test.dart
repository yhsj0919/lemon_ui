import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final searchable in [false, true]) {
    testWidgets('搜索 $searchable：鼠标选择关闭后不抢回焦点', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperSelect<int>(
                value: 1,
                onChanged: (_) {},
                searchable: searchable,
                presentation: HyperSelectPresentation.anchored,
                options: const [
                  HyperSelectOption(value: 1, label: '甲'),
                  HyperSelectOption(value: 2, label: '乙'),
                ],
              ),
            ),
          ),
        ),
      );
      final anchorFinder = find.byType(HyperButton).first;
      await tester.tap(anchorFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<HyperButton>(anchorFinder).focusHighlight, isTrue);
      await tester.tap(find.text('乙'));
      await tester.pumpAndSettle();
      final anchor = tester.widget<HyperButton>(anchorFinder);
      expect(anchor.focusHighlight, isNull);
      expect(anchor.focusNode!.hasFocus, isFalse);
      expect(find.text('乙'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('展开保持高亮，外部点击关闭释放焦点，键盘关闭恢复焦点', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperSelect<int>(
              value: 1,
              onChanged: (_) {},
              presentation: HyperSelectPresentation.anchored,
              options: const [
                HyperSelectOption(value: 1, label: '甲'),
                HyperSelectOption(value: 2, label: '乙'),
              ],
            ),
          ),
        ),
      ),
    );
    HyperButton anchor() =>
        tester.widget<HyperButton>(find.byType(HyperButton).first);
    await tester.tap(find.byType(HyperButton).first);
    await tester.pumpAndSettle();
    expect(anchor().focusHighlight, isTrue);
    await tester.tapAt(const Offset(700, 500));
    await tester.pumpAndSettle();
    expect(anchor().focusHighlight, isNull);
    expect(anchor().focusNode!.hasFocus, isFalse);
    anchor().focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(anchor().focusHighlight, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(anchor().focusHighlight, isNull);
    expect(anchor().focusNode!.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });
}
