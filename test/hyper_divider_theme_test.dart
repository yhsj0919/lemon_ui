import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('内容视觉支持三层覆盖和完整值语义', () {
    const base = HyperDividerStyle(
      color: Colors.grey,
      contentGap: 8,
      edgeExtent: 16,
      contentAlignment: HyperDividerContentAlignment.start,
      textStyle: TextStyle(fontSize: 12),
      iconSize: 16,
    );
    final local = base.merge(const HyperDividerStyle(contentGap: 12));
    final instance = local.copyWith(iconColor: Colors.blue);
    expect(instance.contentGap, 12);
    expect(instance.edgeExtent, 16);
    expect(instance.textStyle, base.textStyle);
    expect(instance.iconColor, Colors.blue);
    expect(instance, instance.copyWith());
    expect(instance.hashCode, instance.copyWith().hashCode);
    final data = HyperDividerThemeData(style: instance);
    expect(data, data.copyWith());
    final theme = HyperThemeData.light().copyWith(dividerTheme: data);
    expect(theme.dividerTheme, data);
    expect(theme, theme.copyWith());
    expect(HyperDividerStyle.lerp(base, instance, .5).contentGap, 10);
  });
  test('四端内容尺寸独立管理并支持插值', () {
    const schemes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    for (final scheme in schemes) {
      final size = scheme.divider;
      expect(size.contentGap, greaterThan(0));
      expect(size.iconSize, greaterThan(0));
      expect(size, size.copyWith());
      expect(size.hashCode, size.copyWith().hashCode);
      expect(HyperDividerSize.lerp(size, size, 0.5), size);
    }
  });
}
