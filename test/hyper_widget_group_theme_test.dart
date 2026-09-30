import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('四端控件组尺寸可独立覆盖并插值', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.widgetGroup.spacing, 8);
    expect(sizes.desktop.widgetGroup.spacing, 6);
    expect(sizes.desktop.widgetGroup.radius, 6);
    expect(sizes.desktop.widgetGroup.innerRadius, 4);
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        widgetGroup: sizes.desktop.widgetGroup.copyWith(spacing: 10),
      ),
    );
    expect(changed.desktop.widgetGroup.spacing, 10);
    expect(changed.phone.widgetGroup.spacing, 8);
    expect(
      HyperWidgetGroupSize.lerp(
        sizes.desktop.widgetGroup,
        changed.desktop.widgetGroup,
        .5,
      ).spacing,
      8,
    );
  });

  test('全局、局部和实例样式逐字段合并', () {
    final global = HyperThemeData.light().copyWith(
      widgetGroupTheme: const HyperWidgetGroupThemeData(
        style: HyperWidgetGroupStyle(
          spacing: 8,
          backgroundColor: Colors.white,
          itemBorderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
    );
    final local = global.widgetGroupTheme.merge(
      const HyperWidgetGroupThemeData(
        style: HyperWidgetGroupStyle(separatorColor: Colors.grey),
      ),
    );
    final resolved = local.style.merge(
      const HyperWidgetGroupStyle(spacing: 12, width: 360, itemHeight: 40),
    );
    expect(resolved.spacing, 12);
    expect(resolved.width, 360);
    expect(resolved.itemHeight, 40);
    expect(resolved.backgroundColor, Colors.white);
    expect(
      resolved.itemBorderRadius,
      const BorderRadius.all(Radius.circular(6)),
    );
    expect(resolved.separatorColor, Colors.grey);
    expect(local.copyWith(), local);
    expect(HyperWidgetGroupThemeData.lerp(local, local, .5), local);
  });
}
