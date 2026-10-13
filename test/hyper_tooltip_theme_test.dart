import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('提示全局配置支持复制、插值和值相等', () {
    final base = HyperThemeData.light();
    const setting = HyperTooltipThemeData(
      appearance: HyperTooltipAppearance.theme,
      foregroundColor: Colors.red,
    );
    final configured = base.copyWith(tooltipTheme: setting);
    expect(configured.tooltipTheme, setting);
    expect(configured, isNot(base));
    expect(configured.copyWith(), configured);
    expect(configured.lerp(base, 0).tooltipTheme.foregroundColor, Colors.red);
    expect(configured.lerp(base, 0).tooltipTheme.appearance, HyperTooltipAppearance.theme);
    expect(
      setting
          .merge(const HyperTooltipThemeData(foregroundColor: Colors.blue))
          .appearance,
      HyperTooltipAppearance.theme,
    );
  });
}
