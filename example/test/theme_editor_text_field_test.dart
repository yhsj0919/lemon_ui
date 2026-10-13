import 'package:lemon_ui_example/pages/selection/hyper_text_field_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('输入框工作区编辑尺寸并重置', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-text-field');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-组件工作区'));
    final scrollable = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    final property = find.byKey(const ValueKey('editor-number-操作区宽度'));
    await tester.scrollUntilVisible(property, 100, scrollable: scrollable);
    final slider = tester.widget<HyperSlider>(
      find.descendant(of: property, matching: find.byType(HyperSlider)),
    );
    slider.onChanged!(39);
    await tester.pumpAndSettle();
    final field = find
        .descendant(
          of: find.byType(HyperTextFieldPage),
          matching: find.byType(HyperTextField),
        )
        .first;
    expect(HyperTheme.sizesOf(tester.element(field)).textField.actionWidth, 39);
    tester.state<ScrollableState>(scrollable).position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: panel, matching: find.text('重置当前组件')));
    await tester.pumpAndSettle();
    expect(
      HyperTheme.sizesOf(tester.element(field)).textField.actionWidth,
      slider.value,
    );
    final colors = HyperTheme.of(tester.element(field)).colors;
    for (final entry in {
      '图标颜色': colors.textSecondary,
      '光标颜色': colors.primary,
      '占位文字颜色': colors.textTertiary,
      '标签颜色': colors.textSecondary,
      '计数颜色': colors.textSecondary,
      '错误图标颜色': colors.error,
      '禁用前景颜色': colors.disabled,
    }.entries) {
      tester.state<ScrollableState>(scrollable).position.jumpTo(0);
      await tester.pump();
      tester
          .widget<HyperSelect<String>>(
            find.descendant(
              of: find.byKey(const ValueKey('editor-field-state')),
              matching: find.byType(HyperSelect<String>),
            ),
          )
          .onChanged!(
        entry.key == '错误图标颜色'
            ? 'error'
            : entry.key == '禁用前景颜色'
            ? 'disabled'
            : 'common',
      );
      await tester.pumpAndSettle();
      final row = find.byKey(ValueKey('editor-color-${entry.key}'));
      await tester.scrollUntilVisible(row, 100, scrollable: scrollable);
      final picker = tester.widget<HyperColorPickerField>(
        find.descendant(of: row, matching: find.byType(HyperColorPickerField)),
      );
      expect(picker.value, entry.value, reason: entry.key);
    }
    tester.state<ScrollableState>(scrollable).position.jumpTo(0);
    await tester.pump();
    tester
        .widget<HyperSelect<String>>(
          find.descendant(
            of: find.byKey(const ValueKey('editor-field-state')),
            matching: find.byType(HyperSelect<String>),
          ),
        )
        .onChanged!('error');
    await tester.pumpAndSettle();
    final errorRow = find.byKey(const ValueKey('editor-color-错误图标颜色'));
    await tester.scrollUntilVisible(errorRow, -100, scrollable: scrollable);
    tester
        .widget<HyperColorPickerField>(
          find.descendant(
            of: errorRow,
            matching: find.byType(HyperColorPickerField),
          ),
        )
        .onChanged!(Colors.purple);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperColorPickerField>(
            find.descendant(
              of: errorRow,
              matching: find.byType(HyperColorPickerField),
            ),
          )
          .value,
      const Color(0xff9c27b0),
    );
    tester
        .widget<HyperIconButton>(
          find.descendant(of: errorRow, matching: find.byType(HyperIconButton)),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperColorPickerField>(
            find.descendant(
              of: errorRow,
              matching: find.byType(HyperColorPickerField),
            ),
          )
          .value,
      colors.error,
    );
    expect(tester.takeException(), isNull);
  });
}
