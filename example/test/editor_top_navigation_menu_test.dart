import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/pages/framework/hyper_top_navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('顶部导航所有 Demo 的菜单颜色均跟随工作区主题', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final index in [0, 1]) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(index),
          home: HyperTheme(
            data: HyperThemeData.light().copyWith(
              topNavigationTheme: const HyperTopNavigationThemeData(
                style: HyperTopNavigationStyle(
                  menuStyle: HyperMenuStyle(
                    foregroundColor: Colors.green,
                    descriptionStyle: TextStyle(color: Colors.purple),
                  ),
                ),
              ),
            ),
            child: const Scaffold(body: HyperTopNavigationPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final nav = find.byType(HyperTopNavigation).at(index);
      final trigger = find.descendant(of: nav, matching: find.text('文件'));
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(find.text('打开一个独立工作区'), findsWidgets);
      for (final text in tester.widgetList<Text>(find.text('打开一个独立工作区'))) {
        expect(text.style?.color, Colors.purple);
      }
      for (final text in tester.widgetList<Text>(find.text('新建窗口'))) {
        expect(text.style?.color, Colors.green);
      }
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });
  test('顶部导航菜单面板与菜单项独立保存，亮暗和设备互不覆盖', () {
    final document = EditorThemeDocument();
    final metrics = document.device(HyperDeviceType.desktop).reviews;
    metrics.topNavigationPanel.width = 300;
    metrics.topNavigationPanel.horizontalPadding = 12;
    metrics.topNavigationMenu.paddingTop = 10;
    metrics.topNavigationMenu.itemHeight = 60;
    metrics.topNavigationMenu.descriptionGap = 7;
    document.light.reviews.topNavigationMenu.descriptionStyleColor =
        const EditorColor(argb: 0xFF112233);
    document.light.reviews.topNavigationMenu.selectedBackgroundColor =
        const EditorColor(argb: 0xFF334455);
    final copy = EditorThemeDocument.decode(document.encode());
    final menu = copy
        .resolve(false, deviceType: HyperDeviceType.desktop)
        .topNavigationTheme
        .style!
        .menuStyle!;
    expect(menu.width, 300);
    expect(menu.surfacePadding, 12);
    expect(menu.itemVerticalPadding, 10);
    expect(menu.itemHeight, 60);
    expect(menu.descriptionGap, 7);
    expect(menu.descriptionStyle?.color, const Color(0xFF112233));
    expect(menu.selectedBackgroundColor, const Color(0xFF334455));
    expect(
      copy
          .resolve(true, deviceType: HyperDeviceType.desktop)
          .topNavigationTheme
          .style!
          .menuStyle!
          .descriptionStyle
          ?.color,
      isNull,
    );
    expect(
      copy.device(HyperDeviceType.phone).reviews.topNavigationMenu.paddingTop,
      isNull,
    );
    expect(copy.encode(), document.encode());
    final fields = EditorReviewFields()
      ..itemHeight = 10
      ..itemRadius = 20;
    constrainEditorReviewDimensions(
      'topNavigationMenu',
      fields,
      HyperThemeData.light().sizes.desktop,
    );
    expect(fields.itemRadius, 5);
  });

  testWidgets('顶部导航菜单设置入口写入整数，菜单状态重置不清除布局', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-top-navigation');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-顶部导航'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    Future<Finder> field(String key) async {
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      final finder = find.byKey(ValueKey(key));
      await tester.scrollUntilVisible(finder, 200, scrollable: scroll);
      return finder;
    }

    Future<void> select(String label, String value) async {
      final finder = await field('editor-select-$label');
      tester
          .widget<HyperSelect<String>>(
            find.descendant(
              of: finder,
              matching: find.byType(HyperSelect<String>),
            ),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    await select('编辑对象', 'topNavigationMenu');
    final padding = await field('editor-number-菜单项垂直内边距');
    tester
        .widget<HyperSlider>(
          find.descendant(of: padding, matching: find.byType(HyperSlider)),
        )
        .onChanged!(9.6);
    await tester.pumpAndSettle();
    HyperMenuStyle resolved() =>
        HyperTheme.of(tester.element(find.byType(HyperTopNavigation).first))
            .topNavigationTheme
            .style!
            .menuStyle!;
    expect(resolved().itemVerticalPadding, 10);
    Future<void> color(String label, Color value) async {
      final entry = await field('editor-color-$label');
      tester
          .widget<HyperColorPickerField>(
            find.descendant(
              of: entry,
              matching: find.byType(HyperColorPickerField),
            ),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    await color('标题与图标颜色', Colors.green);
    await color('描述文字颜色', Colors.purple);
    expect(resolved().foregroundColor?.toARGB32(), Colors.green.toARGB32());
    expect(
      resolved().descriptionStyle?.color?.toARGB32(),
      Colors.purple.toARGB32(),
    );
    tester.state<ScrollableState>(scroll).position.jumpTo(0);
    await tester.pumpAndSettle();
    await select('交互状态', 'selected');
    expect(find.byKey(const ValueKey('editor-number-菜单项垂直内边距')), findsNothing);
    final reset = await field('editor-select-交互状态');
    expect(reset, findsOneWidget);
    await tester.tap(find.text('恢复当前对象 / 状态继承'));
    await tester.pumpAndSettle();
    expect(resolved().itemVerticalPadding, 10);
    expect(resolved().foregroundColor?.toARGB32(), Colors.green.toARGB32());
    expect(
      resolved().descriptionStyle?.color?.toARGB32(),
      Colors.purple.toARGB32(),
    );
    await select('编辑对象', 'topNavigationPanel');
    final width = await field('editor-number-面板宽度');
    tester
        .widget<HyperSlider>(
          find.descendant(of: width, matching: find.byType(HyperSlider)),
        )
        .onChanged!(299.7);
    await tester.pumpAndSettle();
    expect(resolved().width, 300);
    expect(resolved().itemVerticalPadding, 10);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
