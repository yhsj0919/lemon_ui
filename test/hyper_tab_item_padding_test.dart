import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(
  HyperTabBarVariant variant,
  double padding, {
  double scale = 1,
  HyperTabBarStyle? style,
  HyperTabBarStyle? localStyle,
  bool scrollable = true,
}) {
  final base = HyperThemeData.light();
  return MaterialApp(
    home: HyperDeviceDetector(
      deviceType: HyperDeviceType.desktop,
      builder: (_, _, child) => HyperTheme(
        duration: Duration.zero,
        data: base.copyWith(
          sizes: base.sizes.copyWith(
            desktop: base.sizes.desktop.copyWith(
              tabBar: base.sizes.desktop.tabBar.copyWith(
                itemHorizontalPadding: padding,
              ),
            ),
          ),
        ),
        child: child!,
      ),
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: DefaultTabController(
                length: 2,
                child: HyperTabBarTheme(
                  data: HyperTabBarThemeData(
                    style: localStyle ?? const HyperTabBarStyle(),
                  ),
                  child: HyperTabBar(
                    variant: variant,
                    style: style,
                    isScrollable: scrollable,
                    padding: EdgeInsets.zero,
                    tabs: const [
                      HyperTab(text: 'A'),
                      HyperTab(text: 'B'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Rect tapRect(WidgetTester tester, String label) => tester.getRect(
  find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first,
);

void main() {
  test(
    'item padding has independent device values and complete value operations',
    () {
      const sizes = HyperSizeThemeData();
      expect(
        HyperDeviceType.values
            .map((d) => sizes.resolve(d).tabBar.itemHorizontalPadding)
            .toSet(),
        {16, 20, 22},
      );
      for (final d in HyperDeviceType.values) {
        final scheme = sizes.resolve(d);
        expect(
          scheme.tabBar.itemHorizontalPadding,
          scheme.controlPadding.horizontal / 2,
        );
      }
      final a = sizes.desktop.tabBar.copyWith(itemHorizontalPadding: 2);
      final b = a.copyWith(itemHorizontalPadding: 10);
      expect(a.copyWith(), a);
      expect(a.copyWith().hashCode, a.hashCode);
      expect(a, isNot(b));
      expect(HyperTabBarSize.lerp(a, b, .5).itemHorizontalPadding, 6);
      expect(b.padding, a.padding);
      expect(b.itemSpacing, a.itemSpacing);
      const style = HyperTabBarStyle(itemHorizontalPadding: 2);
      expect(style.copyWith(), style);
      expect(style.copyWith().hashCode, style.hashCode);
      expect(
        style
            .merge(const HyperTabBarStyle(itemHorizontalPadding: 0))
            .itemHorizontalPadding,
        0,
      );
      expect(
        HyperTabBarStyle.lerp(
          style,
          style.copyWith(itemHorizontalPadding: 10),
          .5,
        ).itemHorizontalPadding,
        6,
      );
    },
  );
  for (final variant in HyperTabBarVariant.values) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$variant item inset occurs once at scale $scale', (
        tester,
      ) async {
        for (final padding in [0.0, 4.0, 12.0]) {
          await tester.pumpWidget(host(variant, padding, scale: scale));
          await tester.pumpAndSettle();
          final label = tester.getRect(find.text('A'));
          final target = tapRect(tester, 'A');
          final margin = variant == HyperTabBarVariant.separated ? 4.0 : 0.0;
          expect(
            target.width - label.width,
            closeTo(padding * 2 + margin, .01),
          );
          expect(label.center.dx, closeTo(target.center.dx, .01));
          expect(tester.takeException(), isNull);
        }
      });
    }
    testWidgets(
      '$variant local and instance overrides replace the size inset',
      (tester) async {
        await tester.pumpWidget(
          host(
            variant,
            12,
            localStyle: const HyperTabBarStyle(itemHorizontalPadding: 7),
          ),
        );
        await tester.pumpAndSettle();
        final margin = variant == HyperTabBarVariant.separated ? 4.0 : 0.0;
        expect(
          tapRect(tester, 'A').width - tester.getSize(find.text('A')).width,
          closeTo(14 + margin, .01),
        );
        await tester.pumpWidget(
          host(
            variant,
            12,
            localStyle: const HyperTabBarStyle(itemHorizontalPadding: 7),
            style: const HyperTabBarStyle(itemHorizontalPadding: 0),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tapRect(tester, 'A').width - tester.getSize(find.text('A')).width,
          closeTo(margin, .01),
        );
        await tester.pumpWidget(
          host(
            variant,
            12,
            style: HyperTabBarStyle(
              itemStyle: HyperCardStyle(
                padding: const EdgeInsets.symmetric(horizontal: 3),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tapRect(tester, 'A').width - tester.getSize(find.text('A')).width,
          closeTo(6 + margin, .01),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
