import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  const items = [
    HyperSegment(value: 1, label: '一'),
    HyperSegment(value: 2, label: '二'),
    HyperSegment(value: 3, label: '三', enabled: false),
  ];
  test('受控单选、禁用和不可清空', () {
    Set<int>? result;
    final selected = {1};
    final control = HyperSegmentedButton(
      segments: items,
      selected: selected,
      onSelectionChanged: (v) => result = v,
    );
    control.select(1);
    expect(result, isNull);
    control.select(3);
    expect(result, isNull);
    control.select(2);
    expect(result, {2});
    expect(selected, {1});
    expect(() => result!.add(3), throwsUnsupportedError);
  });
  test('多选和清空规则', () {
    Set<int>? result;
    final control = HyperSegmentedButton(
      segments: items,
      selected: {1},
      multiSelectionEnabled: true,
      onSelectionChanged: (v) => result = v,
    );
    control.select(1);
    expect(result, isNull);
    control.select(2);
    expect(result, {1, 2});
    final empty = HyperSegmentedButton(
      segments: items,
      selected: {1},
      emptySelectionAllowed: true,
      onSelectionChanged: (v) => result = v,
    );
    empty.select(1);
    expect(result, isEmpty);
  });
  test('实例只覆盖显式字段，全局主题值相等与插值', () {
    final base = HyperSegmentedButtonStyle(
      group: const HyperWidgetGroupStyle(itemHeight: 32),
      selectedButton: HyperButtonStyle(foregroundColor: Colors.blue),
    );
    final merged = base.merge(
      HyperSegmentedButtonStyle(
        selectedButton: HyperButtonStyle(
          background: const HyperFill.color(Colors.red),
        ),
      ),
    );
    expect(merged.group.itemHeight, 32);
    expect(merged.selectedButton!.foregroundColor, Colors.blue);
    expect(
      merged.selectedButton!.background,
      const HyperFill.color(Colors.red),
    );
    final data = HyperSegmentedButtonThemeData(style: merged);
    final theme = HyperThemeData.light().copyWith(segmentedButtonTheme: data);
    expect(theme.segmentedButtonTheme, data);
    expect(theme, theme.copyWith());
    expect(theme.hashCode, theme.copyWith().hashCode);
    expect(HyperSegmentedButtonStyle.lerp(base, merged, 0), base);
    expect(HyperSegmentedButtonStyle.lerp(base, merged, 1), merged);
  });
  test('非法选择配置拒绝', () {
    expect(
      () => HyperSegmentedButton(segments: items, selected: {1, 2}),
      throwsAssertionError,
    );
    expect(
      () => HyperSegmentedButton(segments: items, selected: <int>{}),
      throwsAssertionError,
    );
    expect(
      () => HyperSegmentedButton(segments: items, selected: {4}),
      throwsAssertionError,
    );
  });
}
