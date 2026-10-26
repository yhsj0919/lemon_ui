import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('独立操作不改变文字行高度和间距', (tester) async {
    Future<void> render(double height) => tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Center(
            child: SizedBox(
              width: 400,
              child: HyperDescriptionList(
                items: [
                  HyperDescriptionItem(
                    id: 'one',
                    label: const Text('标签', key: Key('stable-label')),
                    value: const Text('内容', key: Key('stable-value')),
                    action: SizedBox(width: 40, height: height),
                  ),
                  const HyperDescriptionItem(
                    id: 'two',
                    label: Text('下一行', key: Key('next-label')),
                    value: Text('内容'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await render(20);
    final first = tester.getTopLeft(find.byKey(const Key('stable-label')));
    final before =
        tester.getTopLeft(find.byKey(const Key('next-label'))).dy - first.dy;
    await render(40);
    await tester.pumpAndSettle();
    final after =
        tester.getTopLeft(find.byKey(const Key('next-label'))).dy -
        tester.getTopLeft(find.byKey(const Key('stable-label'))).dy;
    expect(after, before);
    expect(tester.takeException(), isNull);
  });
  test('分割线独占整行，任意内容参与跨列布局', () {
    final layout = HyperDescriptionListLayout(
      const [
        HyperDescriptionItem(id: 'a', label: Text('a')),
        HyperDescriptionItem.divider(id: 'divider'),
        HyperDescriptionItem.custom(
          id: 'custom',
          span: 2,
          child: Row(children: [Text('x'), Icon(Icons.check)]),
        ),
        HyperDescriptionItem(id: 'b', label: Text('b')),
      ],
      columns: 2,
      width: 400,
      minimumColumnWidth: 100,
      spacing: 10,
    );
    expect(layout.rows.length, 4);
    expect(layout.rows[1].single.width, 400);
    expect(layout.rows[2].single.span, 2);
  });
  testWidgets('内容高度限制且长内容可滚动', (tester) async {
    for (final mode in [
      HyperDescriptionContentHeightMode.maximum,
      HyperDescriptionContentHeightMode.fixed,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: SizedBox(
                width: 300,
                child: HyperDescriptionList(
                  style: HyperDescriptionListStyle(
                    contentHeightMode: mode,
                    contentHeight: 100,
                  ),
                  items: const [
                    HyperDescriptionItem(
                      id: 'a',
                      label: Text('标签'),
                      value: SizedBox(height: 300, child: Text('长内容')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final scroll = find.byType(SingleChildScrollView);
      expect(tester.getSize(scroll).height, 100);
      expect(tester.getSize(find.byType(HyperDescriptionList)).height, 100);
      await tester.drag(scroll, const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
  test('四端尺寸覆盖独立，主题插值包含描述列表', () {
    const sizes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    expect(sizes.map((s) => s.descriptionList.minimumColumnWidth), [
      200,
      220,
      160,
      160,
    ]);
    final changed = sizes[2].copyWith(
      descriptionList: sizes[2].descriptionList.copyWith(rowSpacing: 20),
    );
    expect(changed.deviceType, HyperDeviceType.desktop);
    expect(sizes[2].descriptionList.rowSpacing, 8);
    expect(
      HyperSizeScheme.lerp(sizes[2], changed, .5).descriptionList.rowSpacing,
      14,
    );
    final a = HyperThemeData.light();
    final b = a.copyWith(
      descriptionListTheme: const HyperDescriptionListThemeData(
        style: HyperDescriptionListStyle(rowSpacing: 20),
      ),
    );
    expect(a.lerp(b, 1).descriptionListTheme, b.descriptionListTheme);
    expect(b.copyWith(), b);
  });
  const items = [
    HyperDescriptionItem(id: 'a', label: Text('A'), span: 2),
    HyperDescriptionItem(id: 'b', label: Text('B'), span: 2),
    HyperDescriptionItem(id: 'c', label: Text('C')),
  ];
  HyperDescriptionListLayout layout(double width, {bool responsive = true}) =>
      HyperDescriptionListLayout(
        items,
        columns: 3,
        width: width,
        minimumColumnWidth: 160,
        spacing: 12,
        responsive: responsive,
      );
  test('跨列在剩余空间不足时换行，尾部列保持空白', () {
    final result = layout(600);
    expect(result.columnCount, 3);
    expect(result.rows.map((r) => r.map((p) => p.item.id).toList()).toList(), [
      ['a'],
      ['b', 'c'],
    ]);
    expect(
      result.rows[1].fold<double>(12, (w, p) => w + p.width),
      closeTo(600, .001),
    );
  });
  test('窄容器减少列数并限制 span，不改变输入', () {
    final result = layout(120);
    expect(result.columnCount, 1);
    expect(result.rows.length, 3);
    expect(result.rows.first.single.span, 1);
    expect(items.first.span, 2);
    expect(() => result.rows.clear(), throwsUnsupportedError);
    expect(layout(120, responsive: false).columnCount, 3);
  });
  test('宽度边界包含列间距，表格零间距另行计算', () {
    expect(layout(503).columnCount, 2);
    expect(layout(504).columnCount, 3);
    expect(
      HyperDescriptionListLayout(
        items,
        columns: 3,
        width: 480,
        minimumColumnWidth: 160,
      ).columnCount,
      3,
    );
  });
  test('拒绝重复标识、非法跨列与无限宽度', () {
    expect(
      () => HyperDescriptionListLayout(
        [items.first, items.first],
        columns: 1,
        width: 200,
        minimumColumnWidth: 160,
      ),
      throwsArgumentError,
    );
    expect(
      () => HyperDescriptionListLayout(
        const [HyperDescriptionItem(id: 'bad', label: Text(''), span: 0)],
        columns: 1,
        width: 200,
        minimumColumnWidth: 160,
      ),
      throwsArgumentError,
    );
    expect(() => layout(double.infinity), throwsArgumentError);
  });
  test('主题视觉覆盖深合并文字，插值保留端点和值相等', () {
    const base = HyperDescriptionListStyle(
      labelStyle: TextStyle(fontSize: 14),
      rowSpacing: 8,
      background: HyperFill.none(),
    );
    final merged = base.merge(
      const HyperDescriptionListStyle(
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        rowSpacing: 12,
      ),
    );
    expect(merged.labelStyle!.fontSize, 14);
    expect(merged.labelStyle!.fontWeight, FontWeight.bold);
    expect(HyperDescriptionListStyle.lerp(base, merged, .5).rowSpacing, 10);
    expect(HyperDescriptionListStyle.lerp(base, merged, 0), base);
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    final theme = HyperThemeData.light().copyWith(
      descriptionListTheme: HyperDescriptionListThemeData(style: merged),
    );
    expect(theme.descriptionListTheme.style, merged);
  });
}
