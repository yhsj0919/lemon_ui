import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('边缘留白继承四端尺寸主题，实例可以关闭', (tester) async {
    for (final device in HyperDeviceType.values) {
      final base = HyperThemeData.light();
      final specs = base.sizes
          .resolve(device)
          .copyWith(
            tabBar: base.sizes
                .resolve(device)
                .tabBar
                .copyWith(
                  padding: const EdgeInsetsDirectional.only(start: 12, end: 20),
                ),
          );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: device,
            builder: (context, device, child) => HyperTheme(
              data: base.copyWith(
                sizes: base.sizes.copyWith(
                  phone: specs,
                  tablet: specs,
                  desktop: specs,
                  watch: specs,
                ),
              ),
              child: const DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    HyperTabBar(
                      tabs: [
                        HyperTab(text: '一'),
                        HyperTab(text: '二'),
                      ],
                    ),
                    HyperTabBar.separated(
                      padding: EdgeInsets.zero,
                      tabs: [
                        HyperTab(text: '一'),
                        HyperTab(text: '二'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final bars = tester.widgetList<TabBar>(find.byType(TabBar)).toList();
      expect(
        bars[0].padding,
        const EdgeInsetsDirectional.only(start: 12, end: 20),
      );
      expect(bars[1].padding, EdgeInsets.zero);
    }
  });
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
