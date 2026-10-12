import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
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
