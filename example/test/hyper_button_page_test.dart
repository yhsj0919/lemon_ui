import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/button/hyper_button_page.dart';

void main() {
  testWidgets('展示六种按钮并运行异步渐变按钮', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperButtonPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final text in [
      'Filled',
      'Tonal',
      'Outlined',
      'Ghost',
      'Text',
      '异步渐变',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    for (final size in HyperButtonSizeVariant.values) {
      expect(find.byKey(Key('button-size-${size.name}')), findsOneWidget);
    }
    await tester.tap(find.text('异步渐变'));
    await tester.pump();
    int runningProgressCount() => tester
        .widgetList<TickerMode>(
          find.descendant(
            of: find.byType(HyperButton),
            matching: find.byType(TickerMode),
          ),
        )
        .where((ticker) => ticker.enabled)
        .length;
    expect(runningProgressCount(), 1);
    expect(find.text('最近事件：异步执行中'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    expect(runningProgressCount(), 0);
    expect(find.text('最近事件：异步完成'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('button-frosted-material')),
      300,
    );
    await tester.pumpAndSettle();
    final filters = [
      for (final key in [
        'button-frosted-material',
        'button-soft-light-material',
      ])
        find.descendant(
          of: find.byKey(Key(key)),
          matching: find.byType(BackdropFilter),
        ),
    ];
    for (final filter in filters) {
      expect(tester.widget<BackdropFilter>(filter).enabled, isTrue);
    }
    Finder glassVisual() => find.byKey(const Key('button-frosted-material'));
    final glassSize = tester.getSize(glassVisual());
    await tester.tap(find.text('普通材质'));
    await tester.pumpAndSettle();
    for (final filter in filters) {
      expect(
        tester
            .widgetList<BackdropFilter>(filter)
            .where((widget) => widget.enabled),
        isEmpty,
      );
    }
    expect(tester.getSize(glassVisual()), glassSize);
    await tester.tap(find.text('强制反色'));
    await tester.pumpAndSettle();
    expect(find.text('强制反色'), findsOneWidget);
  });
}
