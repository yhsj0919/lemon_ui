import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('旧选色回调修改当前渐变，不覆盖后来添加的节点', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-button');
    await tester.pumpAndSettle();
    tester
        .widget<HyperSelect<String>>(
          find.descendant(
            of: find.byKey(const ValueKey('editor-button-variant')),
            matching: find.byType(HyperSelect<String>),
          ),
        )
        .onChanged!('gradient');
    await tester.pumpAndSettle();
    final oldChanged = tester
        .widget<HyperColorPickerField>(
          find.descendant(
            of: find.byKey(const ValueKey('editor-color-渐变节点 1')),
            matching: find.byType(HyperColorPickerField),
          ),
        )
        .onChanged!;
    tester
        .widget<HyperIconButton>(
          find.byWidgetPredicate(
            (w) => w is HyperIconButton && w.tooltip == '添加颜色节点',
          ),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-color-渐变节点 3')), findsOneWidget);
    oldChanged(Colors.purple);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-color-渐变节点 3')), findsOneWidget);
  });

  testWidgets('添加节点后打开选色浮层，修改颜色保持节点数量和位置', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-divider');
    await tester.pumpAndSettle();
    tester
        .widget<HyperSelect<String>>(
          find.descendant(
            of: find.byKey(const ValueKey('editor-select-渐变类型')),
            matching: find.byType(HyperSelect<String>),
          ),
        )
        .onChanged!('linear');
    await tester.pumpAndSettle();
    tester
        .widget<HyperIconButton>(
          find.byWidgetPredicate(
            (w) => w is HyperIconButton && w.tooltip == '添加颜色节点',
          ),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-color-渐变节点 3')), findsOneWidget);
    final row = find.byKey(const ValueKey('editor-color-渐变节点 2'));
    await tester.tap(
      find.descendant(of: row, matching: find.byType(HyperButton)).first,
    );
    await tester.pumpAndSettle();
    final picker = find.byType(HyperColorPicker).last;
    final hex = find
        .descendant(of: picker, matching: find.byType(EditableText))
        .last;
    await tester.enterText(hex, '#FF9C27B0');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-color-渐变节点 3')), findsOneWidget);
    expect(
      tester
          .widget<HyperSlider>(
            find.descendant(
              of: find.byKey(const ValueKey('editor-number-节点 2 位置')),
              matching: find.byType(HyperSlider),
            ),
          )
          .value,
      .5,
    );
    expect(tester.takeException(), isNull);
  });
}
