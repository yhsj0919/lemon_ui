import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('侧栏图标尺寸、状态颜色保存导入及几何联动', () {
    final document = EditorThemeDocument();
    final m = document.device(HyperDeviceType.desktop).reviews.sidebar;
    m.iconSize = 29;
    m.collapsedIconSize = 24;
    m.expandIconSize = 10;
    document.light.reviews.sidebarItem.iconColor = const EditorColor(
      argb: 0xFF112233,
    );
    document.light.reviews.sidebarSelected.expandIconColor = const EditorColor(
      argb: 0xFF445566,
    );
    final copy = EditorThemeDocument.decode(document.encode());
    final theme = copy.resolve(false, deviceType: HyperDeviceType.desktop);
    expect(theme.sizes.desktop.sidebar.iconSize, 29);
    expect(theme.sizes.desktop.sidebar.collapsedIconSize, 24);
    expect(theme.sizes.desktop.sidebar.expandIconSize, 10);
    expect(theme.sidebarTheme.style!.iconColor, const Color(0xFF112233));
    expect(
      theme.sidebarTheme.style!.selectedExpandIconColor,
      const Color(0xFF445566),
    );
    expect(copy.resolve(true).sidebarTheme.style?.iconColor, isNull);
    expect(copy.encode(), document.encode());
    m.itemHeight = 8;
    constrainEditorReviewDimensions(
      'sidebar',
      m,
      HyperThemeData.light().sizes.desktop,
    );
    expect(m.iconSize, 8);
    expect(m.collapsedIconSize, 8);
    expect(m.expandIconSize, 8);
  });

  testWidgets('侧栏图标入口独立调整大小与颜色，状态重置保留通用尺寸', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-sidebar');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-侧边导航'));
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
      final f = await field('editor-select-$label');
      tester
          .widget<HyperSelect<String>>(
            find.descendant(of: f, matching: find.byType(HyperSelect<String>)),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    Future<void> number(String label, double value) async {
      final f = await field('editor-number-$label');
      tester
          .widget<HyperSlider>(
            find.descendant(of: f, matching: find.byType(HyperSlider)),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    Future<void> color(String label, Color value) async {
      final f = await field('editor-color-$label');
      tester
          .widget<HyperColorPickerField>(
            find.descendant(
              of: f,
              matching: find.byType(HyperColorPickerField),
            ),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    await select('编辑范围', 'item');
    await number('前置图标尺寸', 28.6);
    await number('展开收起图标尺寸', 10.2);
    await color('前置图标颜色', Colors.purple);
    await color('展开收起图标颜色', Colors.green);
    Icon home() => tester.widget<Icon>(find.byIcon(Icons.home_outlined).first);
    expect(home().size, 29);
    expect(home().color?.toARGB32(), Colors.purple.toARGB32());
    final arrow = tester.widget<Icon>(
      find
          .descendant(
            of: find.byKey(const ValueKey('hyper-sidebar-item-library')).first,
            matching: find.byIcon(HyperIcons.chevronRight),
          )
          .first,
    );
    expect(arrow.size, 10);
    expect(arrow.color?.toARGB32(), Colors.green.toARGB32());
    await select('交互状态', 'selected');
    await color('前置图标颜色', Colors.orange);
    expect(
      tester
          .widget<Icon>(find.byIcon(Icons.star_border).first)
          .color
          ?.toARGB32(),
      Colors.orange.toARGB32(),
    );
    await field('editor-select-交互状态');
    await tester.tap(find.text('恢复当前对象 / 状态继承'));
    await tester.pumpAndSettle();
    expect(home().size, 29);
    expect(home().color?.toARGB32(), Colors.purple.toARGB32());
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
