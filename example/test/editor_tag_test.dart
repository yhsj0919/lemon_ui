import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_button_fields.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('标签文档保存、四端和亮暗独立，旧文档兼容', () {
    final doc = EditorThemeDocument();
    doc.desktop.tagMetrics
      ..height = 32
      ..radius = 9;
    doc.light.tag.tagStyle
      ..colorVariant = 'soft'
      ..backgroundFade = .8
      ..borderFade = .4
      ..fontSize = 16;
    doc.light.tag.border
      ..kind = EditorBorderKind.dotted
      ..width = 2;
    doc.light.tagEmphasized.tagStyle
      ..colorVariant = 'filled'
      ..foregroundMode = 'white';
    doc.light.tagDisabled.shadows = [];
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(loaded.encode(), doc.encode());
    final theme = loaded.resolve(false);
    expect(theme.sizes.desktop.tag.height, 32);
    expect(theme.tagTheme.style.backgroundFade, .8);
    expect(theme.tagTheme.style.boxBorder, isA<HyperLineBorder>());
    expect(
      theme.tagTheme.emphasized.foregroundMode,
      HyperTagForegroundMode.white,
    );
    expect(theme.tagTheme.disabled.boxShadow, isEmpty);
    expect(
      loaded.resolve(true).tagTheme,
      EditorThemeDocument().resolve(true).tagTheme,
    );
    expect(
      theme.sizes.phone.tag,
      EditorThemeDocument().resolve(false).sizes.phone.tag,
    );
    expect(theme.chipTheme, EditorThemeDocument().resolve(false).chipTheme);
  });
  testWidgets('标签工作区有配色和边框，状态与变体独立', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-tag');
    await tester.pumpAndSettle();
    HyperSelect<String> select(String key) =>
        tester.widget<HyperSelect<String>>(
          find.descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(HyperSelect<String>),
          ),
        );
    expect(find.byKey(const ValueKey('editor-number-标签高度')), findsOneWidget);
    select('editor-select-外观配色').onChanged!('soft');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-number-背景减淡比例')), findsOneWidget);
    expect(find.byKey(const ValueKey('editor-select-标签边框类型')), findsOneWidget);
    select('editor-tag-state').onChanged!('disabled');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-number-标签高度')), findsNothing);
    expect(select('editor-select-外观配色').value, 'inherit');
    select('editor-tag-state').onChanged!('common');
    await tester.pumpAndSettle();
    expect(select('editor-select-外观配色').value, 'soft');
    select('editor-tag-variant').onChanged!('emphasized');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-number-标签高度')), findsNothing);
    expect(select('editor-select-外观配色').value, 'inherit');
    expect(tester.takeException(), isNull);
  });
}
