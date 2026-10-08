import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

HyperTimelineItem item(Object id, {Widget? opposite}) =>
    HyperTimelineItem(id: id, title: const Text('记录'), opposite: opposite);
void main() {
  testWidgets('横向连线按阅读方向逐渐填充并保持布局稳定', (tester) async {
    Future<void> render(bool highlighted) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HyperTimeline(
            direction: Axis.horizontal,
            style: HyperTimelineStyle(
              highlightLine: highlighted,
              duration: const Duration(milliseconds: 400),
              curve: Curves.linear,
            ),
            items: const [
              HyperTimelineItem(
                id: 'a',
                title: Text('创建'),
                status: HyperTimelineStatus.active,
              ),
              HyperTimelineItem(id: 'b', title: Text('完成')),
            ],
          ),
        ),
      ),
    );
    await render(false);
    final fill = find.byType(FractionallySizedBox).first;
    expect(tester.widget<FractionallySizedBox>(fill).widthFactor, 0);
    await render(true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      tester.widget<FractionallySizedBox>(fill).widthFactor,
      closeTo(.5, .01),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<FractionallySizedBox>(fill).widthFactor, 1);
    expect(
      tester.getTopLeft(find.text('完成')).dx,
      greaterThan(tester.getTopLeft(find.text('创建')).dx),
    );
    for (final entry in [('a', '创建'), ('b', '完成')]) {
      final node = find.byKey(
        ValueKey<(String, Object)>(('timeline-node', entry.$1)),
      );
      expect(
        tester.getCenter(node).dx,
        closeTo(tester.getCenter(find.text(entry.$2)).dx, .01),
      );
    }
    expect(tester.takeException(), isNull);
  });
  test('点线间距与高亮配置参与复制、合并和插值', () {
    const a = HyperTimelineStyle(nodeLineGap: 4, highlightLine: false);
    final b = a.copyWith(nodeLineGap: 8, highlightLine: true);
    expect(a.copyWith(), a);
    expect(a.merge(b), b);
    expect(HyperTimelineStyle.lerp(a, b, .5).nodeLineGap, 6);
    expect(HyperTimelineStyle.lerp(a, b, 1), b);
    expect(a.hashCode, a.copyWith().hashCode);
    final size = HyperThemeData.light().sizes.desktop.timeline;
    expect(
      HyperTimelineSize.lerp(
        size,
        size.copyWith(nodeLineGap: 8),
        .5,
      ).nodeLineGap,
      6,
    );
  });
  testWidgets('材质下节点状态变色，连线可高亮且与两端节点分离', (tester) async {
    final theme = HyperThemeData.light();
    Future<void> render(HyperTimelineStatus status, bool highlight) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: Scaffold(
              body: HyperTimeline(
                style: HyperTimelineStyle(highlightLine: highlight),
                items: [
                  HyperTimelineItem(
                    id: 'a',
                    title: const Text('第一项'),
                    status: status,
                  ),
                  const HyperTimelineItem(id: 'b', title: Text('第二项')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    final node = find.byKey(
      const ValueKey<(String, Object)>(('timeline-node', 'a')),
    );
    final next = find.byKey(
      const ValueKey<(String, Object)>(('timeline-node', 'b')),
    );
    final line = find.byKey(
      const ValueKey<(String, Object)>(('timeline-line', 'a')),
    );
    await render(HyperTimelineStatus.active, false);
    expect(
      tester.getCenter(node).dy,
      closeTo(tester.getCenter(find.text('第一项')).dy, .5),
    );
    expect(
      (tester.widget<AnimatedContainer>(node).decoration as BoxDecoration)
          .color,
      theme.colors.primary,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.descendant(of: line, matching: find.byType(ColoredBox)).first,
          )
          .color,
      theme.colors.outline,
    );
    expect(tester.getRect(line).top - tester.getRect(node).bottom, 4);
    expect(tester.getRect(next).top - tester.getRect(line).bottom, 4);
    await render(HyperTimelineStatus.success, true);
    expect(
      (tester.widget<AnimatedContainer>(node).decoration as BoxDecoration)
          .color,
      theme.colors.success,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.descendant(of: line, matching: find.byType(ColoredBox)).last,
          )
          .color,
      theme.colors.success,
    );
    expect(tester.takeException(), isNull);
  });
  test('反转仅影响展示顺序，不修改输入或项目内容', () {
    final source = [item('a'), item('b'), item('c')];
    final model = HyperTimelineModel(source, reverse: true);
    expect(model.items.map((item) => item.id), ['c', 'b', 'a']);
    expect(source.map((item) => item.id), ['a', 'b', 'c']);
    expect(model.items.first, same(source.last));
    source.clear();
    expect(model.items.length, 3);
    expect(() => model.items.clear(), throwsUnsupportedError);
  });
  test('唯一 id 校验与空记录', () {
    expect(() => HyperTimelineModel([item(1), item(1)]), throwsArgumentError);
    expect(HyperTimelineModel([]).items, isEmpty);
    expect(
      HyperTimelineModel([]).hasOppositeColumn(HyperTimelineAlignment.start),
      false,
    );
  });
  test('逻辑起止方向与交错顺序，部分对侧内容保留整组列', () {
    final model = HyperTimelineModel([item(1), item(2)]);
    expect(model.contentAtStart(0, HyperTimelineAlignment.start), false);
    expect(model.contentAtStart(0, HyperTimelineAlignment.end), true);
    expect(model.contentAtStart(0, HyperTimelineAlignment.alternate), false);
    expect(model.contentAtStart(1, HyperTimelineAlignment.alternate), true);
    expect(model.hasOppositeColumn(HyperTimelineAlignment.alternate), true);
    final mixed = HyperTimelineModel([
      item(1, opposite: const Text('日期')),
      item(2),
    ]);
    expect(mixed.hasOppositeColumn(HyperTimelineAlignment.start), true);
    expect(mixed.hasOppositeColumn(HyperTimelineAlignment.end), true);
  });
  test('状态主题深合并和实例覆盖保留文字尺寸', () {
    const base = HyperTimelineThemeData(
      style: HyperTimelineStyle(
        titleStyle: TextStyle(fontSize: 18),
        lineThickness: 1,
      ),
      active: HyperTimelineStyle(
        titleStyle: TextStyle(color: Colors.blue),
        nodeSize: 12,
      ),
    );
    final active = base
        .resolve(HyperTimelineStatus.active)
        .merge(const HyperTimelineStyle(nodeSize: 16));
    expect(active.titleStyle!.fontSize, 18);
    expect(active.titleStyle!.color, Colors.blue);
    expect(active.nodeSize, 16);
    expect(active.lineThickness, 1);
    final merged = base.merge(
      const HyperTimelineThemeData(
        active: HyperTimelineStyle(lineColor: Colors.green),
      ),
    );
    expect(merged.active!.nodeSize, 12);
    expect(merged.active!.lineColor, Colors.green);
    expect(base.resolve(HyperTimelineStatus.normal).nodeSize, isNull);
  });
  test('视觉材质与动画配置支持复制插值和值相等', () {
    const a = HyperTimelineStyle(
      nodeSize: 8,
      lineThickness: 1,
      itemSpacing: 12,
      material: HyperSurfaceMaterial.frostedGlass(),
      materialQuality: HyperMaterialQuality.standard,
      duration: Duration(milliseconds: 100),
    );
    final b = a.copyWith(
      nodeSize: 16,
      itemSpacing: 20,
      duration: const Duration(milliseconds: 200),
      materialQuality: HyperMaterialQuality.advanced,
      reduceTransparency: true,
    );
    final mid = HyperTimelineStyle.lerp(a, b, .5);
    expect(mid.nodeSize, 12);
    expect(mid.itemSpacing, 16);
    expect(mid.duration, const Duration(milliseconds: 150));
    expect(mid.materialQuality, HyperMaterialQuality.advanced);
    expect(mid.reduceTransparency, true);
    expect(a.copyWith(), a);
    expect(a.copyWith().hashCode, a.hashCode);
    expect(
      HyperTimelineThemeData.lerp(
        const HyperTimelineThemeData(style: a),
        HyperTimelineThemeData(style: b),
        .5,
      ).style,
      mid,
    );
  });
  test('四端尺寸与全局时间线主题独立覆盖', () {
    final theme = HyperThemeData.light();
    for (final sizes in [
      theme.sizes.phone,
      theme.sizes.tablet,
      theme.sizes.desktop,
      theme.sizes.watch,
    ]) {
      final base = sizes.timeline;
      expect(base.copyWith(), base);
      expect(base.copyWith().hashCode, base.hashCode);
      final updated = base.copyWith(nodeSize: base.nodeSize + 4);
      expect(
        HyperTimelineSize.lerp(base, updated, .5).nodeSize,
        base.nodeSize + 2,
      );
      expect(
        sizes.copyWith(timeline: updated).stepIndicator,
        sizes.stepIndicator,
      );
    }
    const timeline = HyperTimelineThemeData(
      style: HyperTimelineStyle(itemSpacing: 19),
    );
    final updated = theme.copyWith(timelineTheme: timeline);
    expect(updated.timelineTheme, timeline);
    expect(updated.stepIndicatorTheme, theme.stepIndicatorTheme);
    expect(theme.lerp(updated, 1), updated);
  });
}
