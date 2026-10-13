import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('尾部选择鼠标关闭不残留焦点，键盘打开关闭恢复焦点', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperPopupListTile<String>(
              focusNode: focus,
              title: const Text('布局'),
              value: null,
              onChanged: (_) {},
              presentation: HyperSelectPresentation.anchored,
              options: const [HyperSelectOption(value: 'a', label: '选项甲')],
            ),
          ),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    Future<void> click(Finder f) async {
      final p = tester.getCenter(f);
      await mouse.moveTo(p);
      await mouse.down(p);
      await mouse.up();
      await tester.pumpAndSettle();
    }

    await click(find.text('布局'));
    await click(find.text('选项甲'));
    expect(focus.hasFocus, isFalse);
    await click(find.text('布局'));
    await mouse.moveTo(const Offset(700, 500));
    await mouse.down(const Offset(700, 500));
    await mouse.up();
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
    await mouse.removePointer();
    expect(tester.takeException(), isNull);
  });
  testWidgets('底部弹窗触摸选择后不留下尾部行焦点', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperPopupListTile<String>(
              focusNode: focus,
              title: const Text('布局'),
              value: null,
              onChanged: (_) {},
              presentation: HyperSelectPresentation.bottomSheet,
              options: const [HyperSelectOption(value: 'a', label: '选项甲')],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('布局'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('选项甲'));
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
    expect(find.text('选项甲'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
