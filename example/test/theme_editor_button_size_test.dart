import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('尺寸区只保留一份，三档独立设置高度和宽度', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-button');
    await tester.pumpAndSettle();
    final sizeSelector = tester
        .widget<HyperSegmentedButton<HyperButtonSizeVariant>>(
          find.byKey(const ValueKey('editor-button-size')),
        );
    expect(sizeSelector.selected, {HyperButtonSizeVariant.medium});
    final sizeControl = find.byKey(const ValueKey('editor-button-size'));
    final segments = find.descendant(
      of: sizeControl,
      matching: find.byType(HyperButton),
    );
    expect(segments, findsNWidgets(3));
    expect(
      tester.getRect(segments.last).right,
      closeTo(tester.getRect(sizeControl).right, .01),
    );
    expect(
      tester.getRect(segments.first).width,
      closeTo(tester.getRect(segments.last).width, .01),
    );
    expect(find.text('真实尺寸属性 · 当前设备'), findsNothing);
    final scrollable = find
        .descendant(
          of: find.byKey(const ValueKey('editor-panel-组件工作区')),
          matching: find.byType(Scrollable),
        )
        .first;
    Future<HyperSlider> slider(String label) async {
      tester.state<ScrollableState>(scrollable).position.jumpTo(0);
      await tester.pump();
      final key = find.byKey(ValueKey('editor-number-$label'));
      await tester.scrollUntilVisible(key, 100, scrollable: scrollable);
      return tester.widget<HyperSlider>(
        find.descendant(of: key, matching: find.byType(HyperSlider)),
      );
    }

    sizeSelector.onSelectionChanged!({HyperButtonSizeVariant.small});
    await tester.pumpAndSettle();
    expect((await slider('最小高度')).value, 24);
    (await slider('最小高度')).onChanged!(30);
    await tester.pumpAndSettle();
    (await slider('最小宽度')).onChanged!(85);
    await tester.pumpAndSettle();
    sizeSelector.onSelectionChanged!({HyperButtonSizeVariant.large});
    await tester.pumpAndSettle();
    expect((await slider('最小高度')).value, 40);
    expect((await slider('最小宽度')).value, 72);
    sizeSelector.onSelectionChanged!({HyperButtonSizeVariant.small});
    await tester.pumpAndSettle();
    expect((await slider('最小高度')).value, 30);
    expect((await slider('最小宽度')).value, 85);
    final mode = find.byKey(const ValueKey('editor-select-宽度模式'));
    await tester.scrollUntilVisible(mode, 100, scrollable: scrollable);
    tester
        .widget<HyperSelect<String>>(
          find.descendant(of: mode, matching: find.byType(HyperSelect<String>)),
        )
        .onChanged!('fixed');
    await tester.pumpAndSettle();
    expect((await slider('固定宽度')).value, 85);
    (await slider('固定宽度')).onChanged!(110);
    await tester.pumpAndSettle();
    sizeSelector.onSelectionChanged!({HyperButtonSizeVariant.medium});
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-number-固定宽度')), findsNothing);
    tester.state<ScrollableState>(scrollable).position.jumpTo(0);
    await tester.pumpAndSettle();
    final variants = find.descendant(
      of: find.byKey(const ValueKey('editor-button-variant')),
      matching: find.byType(HyperSelect<String>),
    );
    for (final variant in HyperButtonVariant.values) {
      tester.widget<HyperSelect<String>>(variants).onChanged!(variant.name);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('editor-button-size')), findsNothing);
      expect(find.byKey(const ValueKey('editor-number-最小高度')), findsNothing);
      expect(find.byKey(const ValueKey('editor-number-最小宽度')), findsNothing);
      expect(
        find.byKey(const ValueKey('editor-number-iconSize')),
        findsNothing,
      );
      expect(find.text('尺寸'), findsNothing);
    }
    tester.widget<HyperSelect<String>>(variants).onChanged!('common');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-button-size')), findsOneWidget);
    sizeSelector.onSelectionChanged!({HyperButtonSizeVariant.small});
    await tester.pumpAndSettle();
    expect((await slider('最小高度')).value, 30);
    expect((await slider('最小宽度')).value, 85);
    expect((await slider('固定宽度')).value, 110);
    expect(tester.takeException(), isNull);
  });
}
