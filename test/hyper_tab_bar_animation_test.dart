import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('减少动画时直接定位目标，窗口宽度改变后重新对齐', (tester) async {
    final controller = TabController(length: 2, vsync: tester);
    Widget app(double width) => MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Center(
            child: SizedBox(
              width: width,
              child: HyperTabBar(
                controller: controller,
                tabs: const [
                  HyperTab(text: '第一项'),
                  HyperTab(text: '第二项'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(600));
    await tester.pumpAndSettle();
    controller.animateTo(1);
    await tester.pump();
    final selection = find.byKey(const ValueKey('hyper-tab-selection'));
    expect(
      tester.getCenter(selection).dx,
      closeTo(tester.getCenter(find.text('第二项')).dx, 1),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(app(320));
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(selection).dx,
      closeTo(tester.getCenter(find.text('第二项')).dx, 1),
    );
    expect(tester.getSize(selection).width, lessThan(160));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets('底槽选中块在点击中间帧连续移动，支持 RTL 与材质覆盖', (tester) async {
    for (final direction in TextDirection.values) {
      final controller = TabController(length: 3, vsync: tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Directionality(
              textDirection: direction,
              child: Center(
                child: SizedBox(
                  width: 600,
                  child: HyperTabBar(
                    controller: controller,
                    style: HyperTabBarStyle(
                      selectedItemStyle: HyperCardStyle(
                        material: const HyperSurfaceMaterial.frostedGlass(),
                        boxShadow: const [],
                        border: Border.all(color: Colors.red),
                      ),
                    ),
                    tabs: const [
                      HyperTab(text: '第一项'),
                      HyperTab(text: '第二项'),
                      HyperTab(text: '第三项'),
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
      final start = tester.getRect(selection);
      await tester.tap(find.text('第三项'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final middle = tester.getRect(selection);
      await tester.pumpAndSettle();
      final end = tester.getRect(selection);
      expect(
        middle.center.dx,
        greaterThan(
          start.center.dx < end.center.dx ? start.center.dx : end.center.dx,
        ),
      );
      expect(
        middle.center.dx,
        lessThan(
          start.center.dx > end.center.dx ? start.center.dx : end.center.dx,
        ),
      );
      expect(middle.width, closeTo(start.width, .01));
      expect(end.center.dx, closeTo(tester.getCenter(find.text('第三项')).dx, 1));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    }
  });

  testWidgets('滚动标签的指示器跟随拖动进度和滚动位置', (tester) async {
    final controller = TabController(length: 3, vsync: tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Center(
            child: SizedBox(
              width: 240,
              child: HyperTabBar(
                controller: controller,
                isScrollable: true,
                tabs: const [
                  HyperTab(text: '第一项比较长'),
                  HyperTab(text: '第二项更长一些'),
                  HyperTab(text: '第三项'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final selection = find.byKey(const ValueKey('hyper-tab-selection'));
    final start = tester.getRect(selection);
    controller.offset = .5;
    await tester.pump();
    final middle = tester.getRect(selection);
    expect(middle.left, greaterThan(start.left));
    expect(middle.width, greaterThan(start.width));
    controller.offset = 0;
    await tester.pumpAndSettle();
    await tester.drag(find.byType(TabBar), const Offset(-100, 0));
    await tester.pumpAndSettle();
    final label = tester.getRect(find.text('第一项比较长'));
    expect(tester.getCenter(selection).dx, closeTo(label.center.dx, 1));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
}
