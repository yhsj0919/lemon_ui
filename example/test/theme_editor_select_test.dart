import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/pages/selection/hyper_select_fields_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Select 工作区编辑尺寸进入预览并重置', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-select-fields');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-组件工作区'));
    final scrollable = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    final row = find.byKey(const ValueKey('editor-number-选择器宽度'));
    await tester.scrollUntilVisible(row, 100, scrollable: scrollable);
    final slider = tester.widget<HyperSlider>(
      find.descendant(of: row, matching: find.byType(HyperSlider)),
    );
    slider.onChanged!(250);
    await tester.pumpAndSettle();
    final page = find.byType(HyperSelectFieldsPage);
    expect(HyperTheme.sizesOf(tester.element(page)).select.width, 250);
    tester.state<ScrollableState>(scrollable).position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: panel, matching: find.text('重置当前对象')));
    await tester.pumpAndSettle();
    expect(HyperTheme.sizesOf(tester.element(page)).select.width, slider.value);
    final selector = tester.widget<HyperSelect<bool>>(
      find.descendant(
        of: find.byKey(const ValueKey('editor-select-surface')),
        matching: find.byType(HyperSelect<bool>),
      ),
    );
    expect(selector.value, true);
    selector.onChanged!(false);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-number-选择器宽度')), findsNothing);
    expect(find.byKey(const ValueKey('editor-number-选项最小高度')), findsOneWidget);
    selector.onChanged!(true);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-number-选择器宽度')), findsOneWidget);
    expect(find.byKey(const ValueKey('editor-number-选项最小高度')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
