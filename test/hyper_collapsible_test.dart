import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

HyperAccordionItem item(Object id, {bool enabled = true}) => HyperAccordionItem(
  id: id,
  header: const Text('标题'),
  child: const Text('内容'),
  enabled: enabled,
);

void main() {
  test('互斥模式切换并可全部收起，输入集合不被改写', () {
    final ids = <Object>{1};
    final selection = HyperAccordionSelection(
      items: [item(1), item(2)],
      expandedIds: ids,
      mode: HyperAccordionMode.single,
    );
    expect(selection.toggle(2), {2});
    expect(selection.toggle(1), isEmpty);
    expect(ids, {1});
    expect(() => selection.toggle(2).add(3), throwsUnsupportedError);
  });
  test('多项模式增删当前项，禁用和未知项不能触发变化', () {
    final selection = HyperAccordionSelection(
      items: [item(1), item(2), item(3, enabled: false)],
      expandedIds: {1},
      mode: HyperAccordionMode.multiple,
    );
    expect(selection.toggle(2), {1, 2});
    expect(selection.toggle(1), isEmpty);
    expect(selection.toggle(3), {1});
    expect(selection.toggle(99), {1});
  });
  test('重复 id 和非法互斥集合报错，删除项不保留有效展开状态', () {
    expect(
      () => HyperAccordionSelection(
        items: [item(1), item(1)],
        expandedIds: {},
        mode: HyperAccordionMode.single,
      ),
      throwsArgumentError,
    );
    expect(
      () => HyperAccordionSelection(
        items: [item(1), item(2)],
        expandedIds: {1, 2},
        mode: HyperAccordionMode.single,
      ),
      throwsArgumentError,
    );
    final selection = HyperAccordionSelection(
      items: [item(1)],
      expandedIds: {1, 99},
      mode: HyperAccordionMode.single,
    );
    expect(selection.expanded, {1});
    expect(
      HyperAccordionSelection(
        items: [],
        expandedIds: {1},
        mode: HyperAccordionMode.single,
      ).expanded,
      isEmpty,
    );
  });
  test('展开状态与禁用主题依次覆盖，实例仅替换显式字段', () {
    const theme = HyperCollapsibleThemeData(
      style: HyperCollapsibleStyle(
        headerStyle: TextStyle(fontSize: 18),
        iconSize: 16,
      ),
      expanded: HyperCollapsibleStyle(
        headerStyle: TextStyle(color: Colors.blue),
        iconSize: 20,
      ),
      collapsed: HyperCollapsibleStyle(iconSize: 18),
      disabled: HyperCollapsibleStyle(iconColor: Colors.grey),
    );
    final value = theme
        .resolve(isExpanded: true, enabled: false)
        .merge(const HyperCollapsibleStyle(iconSize: 22));
    expect(value.headerStyle!.fontSize, 18);
    expect(value.headerStyle!.color, Colors.blue);
    expect(value.iconSize, 22);
    expect(value.iconColor, Colors.grey);
    expect(theme.resolve(isExpanded: false, enabled: true).iconSize, 18);
    expect(
      theme
          .merge(
            const HyperCollapsibleThemeData(
              expanded: HyperCollapsibleStyle(spacing: 12),
            ),
          )
          .expanded!
          .iconSize,
      20,
    );
  });
  test('视觉与动画复制插值和值相等', () {
    const a = HyperCollapsibleStyle(
      headerPadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(12),
      iconSize: 16,
      headerMinHeight: 40,
      duration: Duration(milliseconds: 100),
      materialQuality: HyperMaterialQuality.standard,
    );
    final b = a.copyWith(
      iconSize: 24,
      headerMinHeight: 48,
      duration: const Duration(milliseconds: 200),
      materialQuality: HyperMaterialQuality.advanced,
    );
    final mid = HyperCollapsibleStyle.lerp(a, b, .5);
    expect(mid.iconSize, 20);
    expect(mid.headerMinHeight, 44);
    expect(mid.duration, const Duration(milliseconds: 150));
    expect(mid.materialQuality, HyperMaterialQuality.advanced);
    expect(a.copyWith(), a);
    expect(a.copyWith().hashCode, a.hashCode);
    expect(
      HyperCollapsibleThemeData.lerp(
        const HyperCollapsibleThemeData(style: a),
        HyperCollapsibleThemeData(style: b),
        .5,
      ).style,
      mid,
    );
    const group = HyperAccordionStyle(
      spacing: 8,
      itemTheme: HyperCollapsibleThemeData(style: a),
    );
    final other = group.copyWith(spacing: 16);
    expect(HyperAccordionStyle.lerp(group, other, .5).spacing, 12);
    expect(group.copyWith(), group);
    expect(group.copyWith().hashCode, group.hashCode);
  });
  test('四端规格和全局主题互相独立', () {
    final theme = HyperThemeData.light();
    for (final sizes in [
      theme.sizes.phone,
      theme.sizes.tablet,
      theme.sizes.desktop,
      theme.sizes.watch,
    ]) {
      final panel = sizes.collapsible;
      expect(panel.headerMinHeight, sizes.controlHeightMd);
      expect(panel.copyWith(), panel);
      expect(panel.copyWith().hashCode, panel.hashCode);
      expect(
        HyperCollapsibleSize.lerp(
          panel,
          panel.copyWith(iconSize: panel.iconSize + 4),
          .5,
        ).iconSize,
        panel.iconSize + 2,
      );
      final group = sizes.accordion;
      expect(group.copyWith(), group);
      expect(
        HyperAccordionSize.lerp(
          group,
          group.copyWith(spacing: group.spacing + 4),
          .5,
        ).spacing,
        group.spacing + 2,
      );
      expect(
        sizes.copyWith(accordion: group.copyWith(spacing: 19)).collapsible,
        panel,
      );
    }
    const group = HyperAccordionThemeData(
      style: HyperAccordionStyle(showDividers: true),
    );
    final updated = theme.copyWith(accordionTheme: group);
    expect(updated.collapsibleTheme, theme.collapsibleTheme);
    expect(updated.accordionTheme, group);
    expect(theme.lerp(updated, 1), updated);
  });
}
