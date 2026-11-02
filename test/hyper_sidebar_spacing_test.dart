import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const leadingKey = ValueKey('spacing-leading');
const badgeKey = ValueKey('spacing-badge');

Widget view(
  HyperSidebarStyle style, {
  TextDirection direction = TextDirection.ltr,
  double scale = 1,
}) {
  final base = HyperThemeData.light();
  return MaterialApp(
    home: HyperDeviceDetector(
      deviceType: HyperDeviceType.desktop,
      builder: (_, _, child) => HyperTheme(
        data: base.copyWith(
          sidebarTheme: const HyperSidebarThemeData(
            style: HyperSidebarStyle(
              itemPadding: 8,
              itemSpacing: 10,
              trailingSpacing: 6,
              badgeSpacing: 4,
            ),
          ),
        ),
        duration: Duration.zero,
        child: child!,
      ),
      child: Directionality(
        textDirection: direction,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: HyperSidebarTheme(
              data: const HyperSidebarThemeData(
                style: HyperSidebarStyle(itemPadding: 14),
              ),
              child: HyperSidebar(
                style: style,
                groups: const [
                  HyperSidebarGroup(
                    title: '分组',
                    items: [
                      HyperSidebarItem(
                        id: 'root',
                        label: 'Root',
                        icon: Icon(Icons.folder, key: leadingKey),
                        badge: SizedBox(key: badgeKey, width: 10, height: 10),
                        children: [
                          HyperSidebarItem(id: 'child', label: 'Child'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

HyperListTile tile(WidgetTester tester) =>
    tester.widget<HyperListTile>(find.byType(HyperListTile).first);

void main() {
  test(
    'spacing fields support value operations and independent device sizes',
    () {
      const style = HyperSidebarStyle(
        itemPadding: 7,
        itemSpacing: 11,
        trailingSpacing: 13,
        badgeSpacing: 5,
      );
      expect(style.copyWith(), style);
      expect(style.copyWith().hashCode, style.hashCode);
      expect(const HyperSidebarStyle().merge(style), style);
      final changed = style.copyWith(
        itemPadding: 9,
        itemSpacing: 15,
        trailingSpacing: 17,
        badgeSpacing: 7,
      );
      final mid = HyperSidebarStyle.lerp(style, changed, .5);
      expect(mid.itemPadding, 8);
      expect(mid.itemSpacing, 13);
      expect(mid.trailingSpacing, 15);
      expect(mid.badgeSpacing, 6);
      for (final other in [
        style.copyWith(itemPadding: 0),
        style.copyWith(trailingSpacing: 0),
        style.copyWith(badgeSpacing: 0),
      ]) {
        expect(other, isNot(style));
        expect(style.merge(other), other);
      }
      const sizes = HyperSizeThemeData();
      for (final device in HyperDeviceType.values) {
        final size = sizes.resolve(device).sidebar;
        expect(size.itemPadding, size.itemSpacing);
        expect(size.trailingSpacing, size.itemSpacing);
        expect(size.badgeSpacing, size.itemSpacing);
        final next = size.copyWith(
          itemPadding: 2,
          trailingSpacing: 4,
          badgeSpacing: 6,
        );
        expect(next.copyWith(), next);
        expect(next.hashCode, next.copyWith().hashCode);
        expect(next, isNot(size));
        expect(HyperSidebarSize.lerp(size, next, 0), size);
        expect(HyperSidebarSize.lerp(size, next, 1), next);
        final mixed = HyperSidebarSize.lerp(size, next, .5);
        expect(mixed.itemPadding, (size.itemPadding! + 2) / 2);
        expect(mixed.trailingSpacing, (size.trailingSpacing! + 4) / 2);
        expect(mixed.badgeSpacing, (size.badgeSpacing! + 6) / 2);
      }
      final changedSizes = sizes.copyWith(
        desktop: sizes.desktop.copyWith(
          sidebar: sizes.desktop.sidebar.copyWith(itemSpacing: 20),
        ),
      );
      expect(
        changedSizes.desktop.sidebar.itemPadding,
        sizes.desktop.sidebar.itemPadding,
      );
      expect(changedSizes.phone.sidebar, sizes.phone.sidebar);
    },
  );

  for (final direction in TextDirection.values) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('independent spacing in $direction at scale $scale', (
        tester,
      ) async {
        Widget build(HyperSidebarStyle style) =>
            view(style, direction: direction, scale: scale);
        Future<void> check(
          double padding,
          double gap,
          double trailing,
          double badge,
        ) async {
          await tester.pumpAndSettle();
          final item = tile(tester);
          expect(item.style!.padding!.resolve(direction).left, padding);
          expect(item.style!.leadingSpacing, gap);
          expect(item.style!.trailingSpacing, trailing);
          final bounds = tester.getRect(find.byType(HyperListTile).first);
          final icon = tester.getRect(find.byKey(leadingKey));
          final title = tester.getRect(find.text('Root'));
          final mark = tester.getRect(find.byKey(badgeKey));
          final arrow = tester.getRect(
            find.byIcon(HyperIcons.chevronRight).first,
          );
          if (direction == TextDirection.ltr) {
            expect(icon.left - bounds.left, closeTo(padding, .01));
            expect(title.left - icon.right, closeTo(gap, .01));
            expect(arrow.left - mark.right, closeTo(badge, .01));
          } else {
            expect(bounds.right - icon.right, closeTo(padding, .01));
            expect(icon.left - title.right, closeTo(gap, .01));
            expect(mark.left - arrow.right, closeTo(badge, .01));
          }
          expect(tester.takeException(), isNull);
        }

        await tester.pumpWidget(build(const HyperSidebarStyle()));
        await check(14, 10, 6, 4);
        await tester.pumpWidget(
          build(const HyperSidebarStyle(itemSpacing: 24)),
        );
        await check(14, 24, 6, 4);
        await tester.pumpWidget(build(const HyperSidebarStyle(itemPadding: 0)));
        await check(0, 10, 6, 4);
        await tester.pumpWidget(
          build(const HyperSidebarStyle(trailingSpacing: 0, badgeSpacing: 0)),
        );
        await check(14, 10, 0, 0);
      });
    }
  }
}
