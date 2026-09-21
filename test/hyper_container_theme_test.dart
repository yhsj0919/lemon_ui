import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('单项覆盖保留其他属性，显式 null 恢复继承', () {
    final base = HyperContainerThemeData(
      background: const HyperFill.color(Colors.red),
      padding: const EdgeInsets.all(12),
    );
    final merged = base.merge(
      HyperContainerThemeData(borderRadius: BorderRadius.circular(24)),
    );
    expect(merged.background, base.background);
    expect(merged.padding, base.padding);
    expect(merged.copyWith().background, base.background);
    expect(merged.copyWith(background: null).background, isNull);
    expect(
      merged.copyWith(background: const HyperFill.none()).background!.isNone,
      isTrue,
    );
  });

  test('阴影防御性复制且可显式清除', () {
    final shadows = [const BoxShadow(blurRadius: 8)];
    final theme = HyperContainerThemeData(boxShadow: shadows);
    shadows.clear();
    expect(theme.boxShadow, hasLength(1));
    expect(() => theme.boxShadow!.clear(), throwsUnsupportedError);
    expect(
      theme.merge(HyperContainerThemeData(boxShadow: [])).boxShadow,
      isEmpty,
    );
  });

  test('插值保持端点、尺寸和未指定字段语义', () {
    final a = HyperContainerThemeData(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints.tightFor(width: 100),
    );
    final b = HyperContainerThemeData(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints.tightFor(width: 200),
      clipBehavior: Clip.hardEdge,
    );
    expect(HyperContainerThemeData.lerp(a, b, 0), same(a));
    expect(HyperContainerThemeData.lerp(a, b, 1), same(b));
    final middle = HyperContainerThemeData.lerp(a, b, .5);
    expect(middle.padding, const EdgeInsets.all(15));
    expect(middle.constraints!.minWidth, 150);
    expect(middle.background, isNull);
    expect(middle.clipBehavior, Clip.hardEdge);
  });
}
