import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('四端标签尺寸支持精确覆盖和插值', () {
    const defaults = HyperSizeThemeData();
    expect(defaults.phone.tag.height, 24);
    expect(defaults.desktop.tag.height, 22);
    final changed = defaults.copyWith(
      desktop: defaults.desktop.copyWith(
        tag: defaults.desktop.tag.copyWith(height: 30),
      ),
    );
    expect(changed.desktop.tag.height, 30);
    expect(changed.phone.tag.height, 24);
    expect(
      HyperTagSize.lerp(defaults.desktop.tag, changed.desktop.tag, .5).height,
      26,
    );
  });

  test('标签主题按公共、状态、实例顺序逐字段覆盖', () {
    const global = HyperTagThemeData(
      style: HyperTagStyle(height: 24, backgroundColor: Colors.grey),
      emphasized: HyperTagStyle(foregroundColor: Colors.blue),
    );
    final local = global.merge(
      const HyperTagThemeData(
        emphasized: HyperTagStyle(backgroundColor: Colors.orange),
      ),
    );
    final resolved = local.style
        .merge(local.emphasized)
        .merge(const HyperTagStyle(foregroundColor: Colors.white));
    expect(resolved.height, 24);
    expect(resolved.backgroundColor, Colors.orange);
    expect(resolved.foregroundColor, Colors.white);
    expect(
      local.copyWith(disabled: const HyperTagStyle(radius: 3)).disabled.radius,
      3,
    );
    expect(HyperTagThemeData.lerp(global, local, 1), local);
  });
}
