import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_progress_page.dart';

void main() {
  testWidgets('进度页默认线条可见，窄屏及文字缩放无溢出', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              disableAnimations: true,
              textScaler: TextScaler.linear(scale),
            ),
            child: const HyperProgressPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final line in find.byType(HyperLinearProgress).evaluate()) {
        expect(
          tester.getSize(find.byWidget(line.widget)).width,
          greaterThan(0),
        );
      }
      expect(find.text('细线进度'), findsOneWidget);
      expect(find.text('宽条进度'), findsOneWidget);
      expect(find.byType(HyperSwitch), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
