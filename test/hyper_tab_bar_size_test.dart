import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('标签栏尺寸按四端解析，局部覆盖与插值只改变明确字段', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.tabBar.height, 42);
    expect(sizes.phone.tabBar.itemSpacing, 9);
    expect(sizes.phone.tabBar.underlineThickness, 2);
    expect(sizes.tablet.tabBar.height, 44);
    expect(sizes.desktop.tabBar.height, 36);
    expect(sizes.watch.tabBar.height, 40);

    final changed = sizes.copyWith(
      phone: sizes.phone.copyWith(
        tabBar: sizes.phone.tabBar.copyWith(height: 49),
      ),
    );
    expect(changed.phone.tabBar.height, 49);
    expect(changed.phone.tabBar.segmentedRadius, 8);
    expect(changed.desktop, sizes.desktop);
    expect(
      HyperTabBarSize.lerp(sizes.phone.tabBar, changed.phone.tabBar, .5).height,
      45.5,
    );
  });
}
