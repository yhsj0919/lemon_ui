import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/surface/hyper_navigation_surface.dart';

void main() {
  for (final inset in [0.0, 4.0]) {
    testWidgets('segmented padding is exactly $inset without hidden inset', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: DefaultTabController(
              length: 2,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: HyperTabBar(
                    padding: EdgeInsets.all(inset),
                    tabs: const [Text('First'), Text('Second')],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final track = tester.getRect(find.byType(HyperNavigationSurface).first);
      final selected = tester.getRect(
        find.byKey(const ValueKey('hyper-tab-selection')),
      );
      final selectedSurface = tester.widget<HyperNavigationSurface>(find.byKey(const ValueKey('hyper-tab-selection')));
      final theme = HyperTheme.of(tester.element(find.byType(HyperTabBar)));
      final expectedRadius =
          (theme.sizes
                      .resolve(
                        HyperTheme.sizesOf(
                          tester.element(find.byType(HyperTabBar)),
                        ).deviceType,
                      )
                      .tabBar
                      .segmentedRadius -
                  inset)
              .clamp(0, double.infinity);
      expect(
        selectedSurface.style.borderRadius,
        BorderRadius.circular(expectedRadius.toDouble()),
      );
      expect(selected.left - track.left, closeTo(inset, .01));
      expect(selected.top - track.top, closeTo(inset, .01));
      expect(track.bottom - selected.bottom, closeTo(inset, .01));
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('下划线保持内容宽度，独立标签保留相邻间距', (tester) async {
    for (final underline in [true, false]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: DefaultTabController(
              length: 2,
              child: Center(
                child: SizedBox(
                  width: 600,
                  child: HyperTabBar(
                    variant: underline
                        ? HyperTabBarVariant.underline
                        : HyperTabBarVariant.separated,
                    padding: EdgeInsets.zero,
                    tabs: const [
                      HyperTab(text: '短'),
                      HyperTab(text: '第二项'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final surfaces = find.byType(HyperNavigationSurface);
      final first = tester.getRect(surfaces.at(1));
      final second = tester.getRect(surfaces.at(2));
      if (underline) {
        expect(first.width, lessThan(100));
      } else {
        expect(first.width, greaterThan(260));
        expect(second.left - first.right, greaterThan(0));
      }
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('固定标签的选中表面铺满标签区域并包住图文', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const DefaultTabController(
            length: 2,
            child: Center(
              child: SizedBox(
                width: 600,
                child: HyperTabBar(
                  padding: EdgeInsets.zero,
                  tabs: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.grid_view), Text('完整 Demo')],
                    ),
                    Text('业务'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final selection = find.byKey(const ValueKey('hyper-tab-selection'));
    final selected = tester.getRect(selection);
    final label = tester.getRect(find.text('完整 Demo'));
    expect(selected.width, greaterThan(260));
    expect(selected.left, lessThan(label.left));
    expect(selected.right, greaterThan(label.right));
    await tester.tap(find.text('业务'));
    await tester.pumpAndSettle();
    expect(tester.getRect(selection).width, selected.width);
    expect(
      tester.getCenter(selection).dx,
      closeTo(tester.getCenter(find.text('业务')).dx, 1),
    );
    expect(tester.takeException(), isNull);
  });
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
    expect(sizes.phone.tabBar.itemSpacing, 4);
    for (final device in HyperDeviceType.values) {
      expect(sizes.resolve(device).tabBar.padding, const EdgeInsets.all(4));
      expect(sizes.resolve(device).tabBar.itemSpacing, 4);
    }
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
