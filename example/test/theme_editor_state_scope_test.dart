import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('输入框与选择器按对象和状态切换，重置保持范围隔离', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    Future<void> page(String id) async {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(id);
      await tester.pumpAndSettle();
    }

    HyperSelect<T> selector<T>(String key) => tester.widget<HyperSelect<T>>(
      find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(HyperSelect<T>),
      ),
    );
    Finder number(String label) => find.byKey(ValueKey('editor-number-$label'));
    Finder color(String label) => find.byKey(ValueKey('editor-color-$label'));
    HyperSlider slider(String label) => tester.widget<HyperSlider>(
      find.descendant(of: number(label), matching: find.byType(HyperSlider)),
    );
    await page('hyper-text-field');
    expect(color('错误图标颜色'), findsNothing);
    expect(find.byKey(const ValueKey('editor-select-聚焦边框类型')), findsNothing);
    selector<String>('editor-field-state').onChanged!('focused');
    await tester.pumpAndSettle();
    expect(number('最小高度'), findsNothing);
    expect(find.byKey(const ValueKey('editor-select-聚焦边框类型')), findsOneWidget);
    expect(find.byKey(const ValueKey('editor-select-悬停边框类型')), findsNothing);
    selector<String>('editor-field-state').onChanged!('error');
    await tester.pumpAndSettle();
    expect(color('错误图标颜色'), findsOneWidget);
    expect(color('禁用前景颜色'), findsNothing);
    slider('错误浮层最大宽度').onChanged!(400);
    await tester.pumpAndSettle();
    selector<String>('editor-field-state').onChanged!('common');
    await tester.pumpAndSettle();
    slider('最小高度').onChanged!(45);
    await tester.pumpAndSettle();
    selector<String>('editor-field-state').onChanged!('error');
    await tester.pumpAndSettle();
    expect(slider('错误浮层最大宽度').value, 400);
    tester
        .widget<HyperButton>(
          find.ancestor(
            of: find.text('重置当前状态'),
            matching: find.byType(HyperButton),
          ),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(slider('错误浮层最大宽度').value, isNot(400));
    selector<String>('editor-field-state').onChanged!('common');
    await tester.pumpAndSettle();
    expect(slider('最小高度').value, 45);

    await page('hyper-select-fields');
    slider('选择器宽度').onChanged!(250);
    await tester.pumpAndSettle();
    selector<String>('editor-select-state').onChanged!('hovered');
    await tester.pumpAndSettle();
    expect(number('触发悬停叠加'), findsOneWidget);
    expect(number('触发按下叠加'), findsNothing);
    expect(number('触发圆角'), findsNothing);
    selector<bool>('editor-select-surface').onChanged!(false);
    await tester.pumpAndSettle();
    expect(selector<String>('editor-select-state').value, 'common');
    expect(color('选中选项背景'), findsNothing);
    selector<String>('editor-select-state').onChanged!('selected');
    await tester.pumpAndSettle();
    expect(color('选中选项背景'), findsOneWidget);
    expect(color('活动选项背景'), findsNothing);
    expect(number('选项最小高度'), findsNothing);
    selector<String>('editor-select-state').onChanged!('active');
    await tester.pumpAndSettle();
    expect(color('活动选项背景'), findsOneWidget);
    expect(color('选中选项背景'), findsNothing);
    selector<String>('editor-select-state').onChanged!('common');
    await tester.pumpAndSettle();
    tester
        .widget<HyperButton>(
          find.ancestor(
            of: find.text('重置当前对象'),
            matching: find.byType(HyperButton),
          ),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    selector<bool>('editor-select-surface').onChanged!(true);
    await tester.pumpAndSettle();
    expect(selector<String>('editor-select-state').value, 'hovered');
    selector<String>('editor-select-state').onChanged!('common');
    await tester.pumpAndSettle();
    expect(slider('选择器宽度').value, 250);
    for (final id in ['hyper-card', 'hyper-menu']) {
      await page(id);
      expect(find.byKey(const ValueKey('editor-select-状态覆盖')), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
