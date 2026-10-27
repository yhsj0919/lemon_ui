import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/container/hyper_container_page.dart';

void main() {
  testWidgets('HyperContainer 演示显示主题、覆盖和动画', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HyperContainerPage()));
    await tester.pumpAndSettle();

    expect(find.text('继承当前主题：背景、圆角、边框、阴影、内边距与裁切'), findsOneWidget);
    expect(find.text('实例渐变覆盖'), findsOneWidget);
    expect(find.text('显式清除背景和阴影'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('themed-container'))),
      const Size(220, 120),
    );

    final filter = find.descendant(
      of: find.byKey(const Key('gradient-container')),
      matching: find.byType(BackdropFilter),
    );
    Gradient? gradient() =>
        (tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: filter,
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration)
            .gradient;
    final before = gradient();
    await tester.tap(find.text('切换动画效果'));
    await tester.pumpAndSettle();
    final after = gradient();
    expect(after, isNot(before));
  });
}
