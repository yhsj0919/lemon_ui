import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/gallery/demo_section.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_size_scheme_page.dart';

void main() {
  testWidgets('尺寸页卡片中的按钮组收紧且文字按布局垂直居中', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 1400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HyperSizeSchemePage()));
    await tester.pumpAndSettle();
    final group = find.byType(HyperWidgetGroup).first;
    expect(tester.getSize(group).width, lessThan(600));
    for (final label in ['手机', '平板', '桌面', '手表']) {
      final text = find.text(label);
      final button = find.ancestor(
        of: text,
        matching: find.byType(HyperButton),
      );
      expect(
        tester.getCenter(text).dy,
        closeTo(tester.getCenter(button).dy, .1),
      );
    }
    await tester.tap(find.text('平板'));
    await tester.pumpAndSettle();
    expect(tester.getSize(group).width, lessThan(600));
    expect(tester.takeException(), isNull);
  });
  testWidgets('展示卡片不强制撑开自然宽度的分段按钮', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DemoSection(
          title: '多选，可清空',
          child: HyperSegmentedButton(
            segments: const [
              HyperSegment(value: 0, label: '加粗'),
              HyperSegment(value: 1, label: '斜体'),
              HyperSegment(value: 2, label: '下划线'),
            ],
            selected: const {0},
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            onSelectionChanged: (_) {},
          ),
        ),
      ),
    );
    final group = tester.getRect(find.byType(HyperWidgetGroup));
    final lastButton = tester.getRect(find.byType(HyperButton).last);
    expect(
      group.width,
      lessThan(tester.getSize(find.byType(HyperCard)).width / 2),
    );
    expect(group.right - lastButton.right, lessThan(4));
    expect(tester.takeException(), isNull);
  });
}
