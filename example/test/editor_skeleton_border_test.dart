import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('骨架屏只调边框宽度即可看到主题描边，尺寸写入整数', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-skeleton');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-骨架屏'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    final field = find.byKey(const ValueKey('editor-number-边框宽度'));
    await tester.scrollUntilVisible(field, 300, scrollable: scroll);
    tester
        .widget<HyperSlider>(
          find.descendant(of: field, matching: find.byType(HyperSlider)),
        )
        .onChanged!(4.6);
    await tester.pumpAndSettle();
    final skeleton = find.byType(HyperSkeleton).first;
    final context = tester.element(skeleton);
    final theme = HyperTheme.of(context);
    expect(theme.skeletonTheme.style.borderWidth, 5);
    final borders = tester
        .widgetList<DecoratedBox>(
          find.descendant(of: skeleton, matching: find.byType(DecoratedBox)),
        )
        .map((d) => (d.decoration as BoxDecoration).border)
        .whereType<Border>();
    expect(borders.single.top.width, 5);
    expect(borders.single.top.color, theme.colors.outline);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
