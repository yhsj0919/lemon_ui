import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('按钮、分段按钮、输入框和标签栏适应大字体', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  body: SizedBox(
                    width: 320,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HyperButton.filled(
                          label: const Text('按钮文字'),
                          onPressed: () {},
                        ),
                        HyperSegmentedButton<int>(
                          segments: const [
                            HyperSegment(value: 1, label: '选项一'),
                            HyperSegment(value: 2, label: '选项二'),
                          ],
                          selected: const {1},
                          onSelectionChanged: (_) {},
                        ),
                        const HyperTextField(hintText: '输入文字'),
                        const HyperTabBar(
                          tabs: [
                            HyperTab(text: '标签一'),
                            HyperTab(text: '标签二'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in ['按钮文字', '选项一', '选项二']) {
        final text = find.text(label);
        final surface = find
            .ancestor(of: text, matching: find.byType(AnimatedContainer))
            .first;
        expect(
          tester.getRect(surface).bottom,
          greaterThanOrEqualTo(tester.getRect(text).bottom),
        );
        expect(
          tester.getRect(surface).top,
          lessThanOrEqualTo(tester.getRect(text).top),
        );
      }
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('子树缩放策略跟随、限制和禁用', (tester) async {
    for (final policy in HyperTextScalePolicy.values) {
      double? size;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: HyperTextScale(
            policy: policy,
            child: Builder(
              builder: (context) {
                size = MediaQuery.textScalerOf(context).scale(10);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(size, switch (policy) {
        HyperTextScalePolicy.system => 30,
        HyperTextScalePolicy.limited => 20,
        HyperTextScalePolicy.disabled => 10,
      });
    }
  });

  testWidgets('徽标文字放大时容器容纳完整文字，点大小不变', (tester) async {
    double? dotSize;
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: const Scaffold(
                body: Column(
                  children: [
                    HyperBadge(label: 'NEW'),
                    HyperBadge.number(count: 999),
                    HyperBadge(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in ['NEW', '99+']) {
        final text = find.text(label);
        final container = find
            .ancestor(of: text, matching: find.byType(AnimatedContainer))
            .first;
        expect(
          tester.getRect(container).top,
          lessThanOrEqualTo(tester.getRect(text).top),
        );
        expect(
          tester.getRect(container).bottom,
          greaterThanOrEqualTo(tester.getRect(text).bottom),
        );
      }
      final dot = find.byKey(const ValueKey('dot'));
      final current = tester.getSize(dot).height;
      dotSize ??= current;
      expect(current, dotSize);
      expect(tester.takeException(), isNull);
    }
  });
}
