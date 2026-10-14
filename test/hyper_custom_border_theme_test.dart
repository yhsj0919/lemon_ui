import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('自定义线条边框主题动画中间帧安全', (tester) async {
    final border = const HyperLine(
      fill: HyperFill.color(Colors.red),
      thickness: 2,
      pattern: HyperLinePattern.dashed,
    ).toBorder();
    final base = HyperThemeData.light();
    Widget app(HyperThemeData theme) => MaterialApp(
      theme: ThemeData(extensions: [theme]),
      home: HyperTheme(
        data: theme,
        child: const HyperCollapsible(
          expanded: true,
          header: Text('header'),
          child: Text('body'),
        ),
      ),
    );
    await tester.pumpWidget(app(base));
    final changed = base.copyWith(
      collapsibleTheme: base.collapsibleTheme.copyWith(
        style: HyperCollapsibleStyle(border: border),
      ),
      containerTheme: base.containerTheme.copyWith(border: border),
      widgetGroupTheme: base.widgetGroupTheme.copyWith(
        style: HyperWidgetGroupStyle(border: border),
      ),
    );
    await tester.pumpWidget(app(changed));
    await tester.pump(const Duration(milliseconds: 80));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
