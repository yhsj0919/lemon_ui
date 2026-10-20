import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget _app(Widget child, double scale) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: HyperDeviceType.desktop,
    builder: (context, device, child) =>
        HyperTheme(data: HyperThemeData.light(), child: child!),
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 180,
              child: SizedBox(key: const ValueKey('field'), child: child),
            ),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  const longLabel = '这是一个超出单行宽度的完整选择值和文件名称';
  final samples = <String, Widget Function(bool)>{
    'select': (long) => HyperSelect<int>(
      options: const [HyperSelectOption(value: 1, label: longLabel)],
      value: long ? 1 : null,
      placeholder: '短值',
      onChanged: (_) {},
    ),
    'datetime': (long) => HyperDateTimePicker(
      value: long ? DateTime(2026, 10, 20, 12, 45) : null,
      placeholder: '短值',
      onChanged: (_) {},
    ),
    'range': (long) => HyperDateTimeRangePicker(
      value: long
          ? DateTimeRange(
              start: DateTime(2026, 10, 20),
              end: DateTime(2026, 10, 22),
            )
          : null,
      onChanged: (_) {},
    ),
    'color': (long) => HyperColorPickerField(
      value: long ? Colors.orange : Colors.blue,
      onChanged: (_) {},
    ),
    'popup-list': (long) => HyperPopupListTile<int>(
      title: const Text('选项', maxLines: 1),
      placeholder: '短值',
      options: const [HyperSelectOption(value: 1, label: longLabel)],
      value: long ? 1 : null,
      onChanged: (_) {},
    ),
    'file': (long) => HyperFilePicker(
      files: [HyperFileSelection(name: long ? longLabel : 'a.txt')],
      variant: HyperFilePickerVariant.simple,
      onChanged: (_) {},
      pick: () => const [],
    ),
  };
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'default value summaries stay single-line across fields at scale $scale',
      (tester) async {
        for (final entry in samples.entries) {
          await tester.pumpWidget(_app(entry.value(false), scale));
          await tester.pumpAndSettle();
          final shortHeight = tester
              .getSize(find.byKey(const ValueKey('field')))
              .height;
          await tester.pumpWidget(_app(entry.value(true), scale));
          await tester.pumpAndSettle();
          expect(
            tester.getSize(find.byKey(const ValueKey('field'))).height,
            shortHeight,
            reason: entry.key,
          );
          final scrolling = find.byType(HyperScrollingText);
          expect(scrolling, findsOneWidget, reason: entry.key);
          expect(
            tester.widget<HyperScrollingText>(scrolling).trigger,
            HyperTextScrollTrigger.hover,
            reason: entry.key,
          );
          expect(tester.takeException(), isNull, reason: entry.key);
        }
      },
    );
  }

  testWidgets('explicit multiline dropdown content remains caller-controlled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        HyperDropdown(
          label: const Text('第一行\n第二行', maxLines: 2),
          panelBuilder: (_, close) => const Text('内容'),
        ),
        1,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperScrollingText), findsNothing);
    expect(tester.widget<Text>(find.text('第一行\n第二行')).maxLines, 2);
    expect(tester.takeException(), isNull);
  });
}
