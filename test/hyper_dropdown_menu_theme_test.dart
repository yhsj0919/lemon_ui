import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('四端下拉选择器尺寸独立，并可只覆盖桌面尺寸', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.dropdownMenu.arrowSize, 24);
    expect(sizes.tablet.dropdownMenu.arrowSize, 28);
    expect(sizes.desktop.dropdownMenu.arrowSize, 20);
    expect(sizes.watch.dropdownMenu.arrowSize, 24);
    expect(sizes.phone.overlaySpacing, 4);

    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        overlaySpacing: 12,
        dropdownMenu: sizes.desktop.dropdownMenu.copyWith(width: 224),
      ),
    );
    expect(changed.desktop.dropdownMenu.width, 224);
    expect(changed.desktop.overlaySpacing, 12);
    expect(changed.phone, sizes.phone);
    expect(changed.tablet, sizes.tablet);
    expect(changed.watch, sizes.watch);
  });

  test('全局主题 copyWith 保留未指定的下拉选择器字段', () {
    final base = HyperThemeData.light();
    final changed = base.copyWith(
      dropdownMenuTheme: base.dropdownMenuTheme.copyWith(
        style: const HyperDropdownMenuStyle(arrowColor: Colors.grey),
      ),
    );
    expect(changed.dropdownMenuTheme.style?.arrowColor, Colors.grey);
    expect(changed.sizes, base.sizes);
    expect(changed.menuTheme, base.menuTheme);
    expect(changed.buttonTheme, base.buttonTheme);

    final merged = changed.dropdownMenuTheme.copyWith(
      style: const HyperDropdownMenuStyle(width: 230, popupSpacing: 4),
    );
    expect(merged.style?.arrowColor, Colors.grey);
    expect(merged.style?.width, 230);
    expect(merged.style?.popupSpacing, 4);
  });

  test('样式和主题插值分别处理尺寸与颜色', () {
    const a = HyperDropdownMenuStyle(width: 192, arrowColor: Colors.black);
    const b = HyperDropdownMenuStyle(width: 224, arrowColor: Colors.white);
    final middle = HyperDropdownMenuStyle.lerp(a, b, .5);
    expect(middle.width, 208);
    expect(middle.arrowColor, Color.lerp(Colors.black, Colors.white, .5));
    expect(
      HyperDropdownMenuThemeData.lerp(
        const HyperDropdownMenuThemeData(style: a),
        const HyperDropdownMenuThemeData(style: b),
        .5,
      ).style,
      middle,
    );
  });
}
