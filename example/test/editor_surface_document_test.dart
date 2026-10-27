import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('内外标题和操作文字独立保存与解析', () {
    final d = EditorThemeDocument();
    d.desktop.cardMetrics
      ..insideTitleFontSize = 22
      ..outsideTitleFontSize = 13
      ..insideActionFontSize = 16
      ..outsideActionFontSize = 12;
    final restored = EditorThemeDocument.decode(d.encode());
    final theme = restored.resolve(false).titledCardTheme;
    expect(theme.inside!.titleTextStyle!.fontSize, 22);
    expect(theme.outside!.titleTextStyle!.fontSize, 13);
    expect(theme.inside!.actionTextStyle!.fontSize, 16);
    expect(theme.outside!.actionTextStyle!.fontSize, 12);
  });
  testWidgets('材质工作区保留详细参数并移除设备切换', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-material-surface');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-select-配方')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('editor-heading-材质质量与降级')),
      findsOneWidget,
    );
    // The single selector belongs to the left global workspace.
    expect(find.byType(HyperSegmentedButton<HyperDeviceType>), findsOneWidget);
    expect(find.byKey(const Key('inherited-material-preview')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('容器分类各工作区渲染与设置入口', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    for (final id in [
      'hyper-container',
      'hyper-card',
      'hyper-collapsible',
      'hyper-widget-group',
    ]) {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(id);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('editor-number-内容内边距')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('基础能力页面显示对应全局设置', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-motion-theme');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-heading-快速动效')), findsWidgets);
    expect(find.byKey(const ValueKey('editor-heading-背景材质')), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Select 字号设置显示当前设备控件字阶', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-select-fields');
    await tester.pumpAndSettle();
    final slider = tester.widget<HyperSlider>(
      find.descendant(
        of: find.byKey(const ValueKey('editor-number-触发文字字号')),
        matching: find.byType(HyperSlider),
      ),
    );
    expect(slider.value, 14);
  });
  test('容器工作区四端与外观保存导入及主题应用', () {
    final d = EditorThemeDocument();
    d.desktop.cardMetrics.padding = 17;
    d.phone.cardMetrics.padding = 9;
    d.desktop.containerMetrics.radius = 18;
    d.desktop.collapsibleMetrics.iconSize = 21;
    d.light.collapsible.surface.iconColor = const EditorColor(
      semantic: 'primary',
    );
    d.light.group.surface.separatorColor = const EditorColor(
      semantic: 'primary',
    );
    d.dark.card.surface.pressedScale = .9;
    final restored = EditorThemeDocument.decode(d.encode());
    expect(restored.encode(), d.encode());
    final desktop = restored.resolve(false);
    expect(desktop.cardTheme.style!.padding, EdgeInsets.all(17));
    expect(
      restored
          .resolve(false, deviceType: HyperDeviceType.phone)
          .cardTheme
          .style!
          .padding,
      EdgeInsets.all(9),
    );
    expect(desktop.collapsibleTheme.style.iconColor, desktop.colors.primary);
    expect(
      desktop.widgetGroupTheme.style.separatorColor,
      desktop.colors.primary,
    );
  });
}
