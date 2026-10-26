import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('desktop bottom navigation keeps compact minimum height', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: HyperNavigationBar<int>(
                selectedValue: 0,
                onSelected: (_) {},
                destinations: const [
                  HyperNavigationDestination(
                    value: 0,
                    label: '首页',
                    icon: Icon(Icons.home),
                  ),
                  HyperNavigationDestination(
                    value: 1,
                    label: '发现',
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(HyperNavigationBar<int>)).height,
      inInclusiveRange(62, 64),
    );
    final size = const HyperSizeThemeData().desktop.navigationBar;
    expect(size.itemSpacing, 2);
    expect(size.verticalPadding, 8);
    expect(size.iconSize, 24);
    expect(size.copyWith(), size);
    expect(HyperNavigationBarSize.lerp(size, size, .5), size);
    expect(tester.takeException(), isNull);

    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets('navigation selected color interpolates', (tester) async {
    var selected = 0;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: StatefulBuilder(
              builder: (_, set) {
                update = set;
                return HyperNavigationBar<int>(
                  labelVisibility: HyperNavigationLabelVisibility.selected,
                  selectedValue: selected,
                  onSelected: (_) {},
                  destinations: const [
                    HyperNavigationDestination(
                      value: 0,
                      label: 'First',
                      icon: Icon(Icons.home),
                    ),
                    HyperNavigationDestination(
                      value: 1,
                      label: 'Second',
                      icon: Icon(Icons.settings),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    Color? color() => tester.widget<Text>(find.text('Second')).style!.color;
    final start = color();
    final initialHeight = tester
        .getSize(find.byType(HyperNavigationBar<int>))
        .height;
    final initialY = tester.getCenter(find.byIcon(Icons.settings)).dy;
    update(() => selected = 1);
    await tester.pump();
    expect(color(), start);
    await tester.pump(const Duration(milliseconds: 60));
    final middle = color();
    final middleY = tester.getCenter(find.byIcon(Icons.settings).last).dy;
    expect(middleY, isNot(initialY));
    expect(
      tester.getSize(find.byType(HyperNavigationBar<int>)).height,
      initialHeight,
    );
    expect(middle, isNot(start));
    await tester.pumpAndSettle();
    expect(color(), isNot(middle));
    expect(tester.getCenter(find.byIcon(Icons.settings)).dy, isNot(middleY));
    expect(
      tester.getSize(find.byType(HyperNavigationBar<int>)).height,
      initialHeight,
    );
    expect(color(), HyperThemeData.light().colors.primary);
  });
}
