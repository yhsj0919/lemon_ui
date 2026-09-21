import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_size_scheme_page.dart';

void main() {
  testWidgets('可切换四终端并显示明确高度', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HyperSizeSchemePage()));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byKey(const ValueKey('height-md'))).height, 48);
    expect(
      tester.getSize(find.byKey(const Key('hit-target-preview'))),
      const Size(48, 48),
    );

    await tester.tap(find.text('桌面'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const ValueKey('height-md'))).height, 44);
    expect(
      tester.getSize(find.byKey(const Key('hit-target-preview'))),
      const Size(36, 36),
    );

    await tester.tap(find.text('平板'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const ValueKey('height-md'))).height, 52);
  });
}
