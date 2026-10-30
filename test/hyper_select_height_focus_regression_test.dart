import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const opts = [
  HyperSelectOption(value: 'a', label: '选项甲'),
  HyperSelectOption(value: 'b', label: '选项乙'),
];
void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('Select trigger inherits button text metrics at scale $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (context, device, child) =>
                HyperTheme(data: HyperThemeData.light(), child: child!),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: Column(
                  children: [
                    HyperSelect<String>(
                      value: 'TOP10',
                      onChanged: (_) {},
                      size: HyperButtonSizeVariant.small,
                      buttonStyle: HyperButtonStyle(
                        minimumTapTargetSize: Size.zero,
                      ),
                      options: const [
                        HyperSelectOption(value: 'TOP10', label: 'TOP10'),
                      ],
                    ),
                    HyperButton.outlined(
                      size: HyperButtonSizeVariant.small,
                      style: HyperButtonStyle(minimumTapTargetSize: Size.zero),
                      onPressed: () {},
                      label: const Text('TOP10'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final texts = find.text('TOP10');
      expect(texts, findsNWidgets(2));
      for (final text in [texts.first, texts.last]) {
        final visual = find
            .ancestor(
              of: text,
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is AnimatedContainer &&
                    widget.decoration is BoxDecoration,
              ),
            )
            .first;
        expect(
          tester.getCenter(text).dy,
          closeTo(tester.getCenter(visual).dy, .01),
        );
      }
      expect(
        tester.getSize(texts.first).height,
        closeTo(tester.getSize(texts.last).height, .01),
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('默认 Select 和 Autocomplete 的可视表面高度一致', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.desktop,
          builder: (context, device, child) =>
              HyperTheme(data: HyperThemeData.light(), child: child!),
          child: Scaffold(
            body: Column(
              children: [
                HyperSelect<String>(
                  key: const ValueKey('select'),
                  options: opts,
                  value: null,
                  onChanged: (_) {},
                ),
                HyperAutocomplete<String>(
                  key: const ValueKey('auto'),
                  options: opts,
                  value: null,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    Finder surface(String key) => find
        .descendant(
          of: find.byKey(ValueKey(key)),
          matching: find.byWidgetPredicate(
            (w) => w is AnimatedContainer && w.decoration is BoxDecoration,
          ),
        )
        .first;
    expect(
      tester.getCenter(find.text('输入搜索')).dy,
      closeTo(tester.getCenter(surface('auto')).dy, .1),
    );
    final autoSurface = tester.widget<AnimatedContainer>(surface('auto'));
    expect((autoSurface.decoration! as BoxDecoration).color, Colors.white);
    expect(
      tester.getSize(surface('auto')).height,
      closeTo(tester.getSize(surface('select')).height, .01),
    );
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('输入文字与占位垂直居中，倍率 $scale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 180,
                    child: HyperTextField(hintText: '占位文字'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final surface = find
          .descendant(
            of: find.byType(HyperTextField),
            matching: find.byWidgetPredicate(
              (w) => w is AnimatedContainer && w.decoration is BoxDecoration,
            ),
          )
          .first;
      expect(
        tester.getCenter(find.text('占位文字')).dy,
        closeTo(tester.getCenter(surface).dy, .1),
      );
      await tester.enterText(find.byType(TextField), '输入文字');
      await tester.pumpAndSettle();
      expect(
        tester.getCenter(find.byType(EditableText)).dy,
        closeTo(tester.getCenter(surface).dy, .1),
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('桌面鼠标选择后释放触发焦点，键盘关闭仍返回触发器', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperSelect<String>(
              options: opts,
              value: null,
              presentation: HyperSelectPresentation.anchored,
              searchable: true,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(HyperButton).first));
    await mouse.down(tester.getCenter(find.byType(HyperButton).first));
    await mouse.up();
    await tester.pumpAndSettle();
    await mouse.moveTo(tester.getCenter(find.text('选项乙')));
    await mouse.down(tester.getCenter(find.text('选项乙')));
    await mouse.up();
    await tester.pumpAndSettle();
    final anchor = tester.widget<HyperButton>(find.byType(HyperButton).first);
    expect(anchor.focusHighlight, isNull);
    expect(anchor.focusNode!.hasFocus, isFalse);
    anchor.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(anchor.focusNode!.hasFocus, isTrue);
    await mouse.removePointer();
  });
  testWidgets('自动填充关闭后移动光标不重新打开面板', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperAutocomplete<String>(
              options: opts,
              value: null,
              presentation: HyperSelectPresentation.anchored,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), '选');
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(find.byType(TextField).first);
    field.controller!.selection = const TextSelection.collapsed(offset: 0);
    await tester.pumpAndSettle();
    expect(find.text('选项甲'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
