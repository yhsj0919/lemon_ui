import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('菜单选中图标支持主题继承、实例覆盖和离散过渡', () {
    const base = HyperMenuStyle(checkIcon: Icons.check);
    const override = HyperMenuStyle(checkIcon: Icons.done_all);
    expect(base.merge(const HyperMenuStyle()).checkIcon, Icons.check);
    expect(base.merge(override), override);
    expect(base.copyWith(checkIcon: Icons.done_all), override);
    expect(HyperMenuStyle.lerp(base, override, .25), base);
    expect(HyperMenuStyle.lerp(base, override, .75), override);
    expect(base, isNot(override));
    expect(
      base.hashCode,
      const HyperMenuStyle(checkIcon: Icons.check).hashCode,
    );
  });
}
