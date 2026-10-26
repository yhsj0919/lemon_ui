import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'default rating uses 24 icons and a 32 high target on every device',
    (t) async {
      for (final device in HyperDeviceType.values) {
        final theme = HyperThemeData.light();
        final size = theme.sizes.resolve(device);
        expect(size.rating.iconSize, 24);
        expect(size.rating.hitExtent, 32);
        final custom = size.copyWith(
          rating: size.rating.copyWith(iconSize: 28, hitExtent: 40),
        );
        expect(HyperSizeScheme.lerp(size, custom, 1).rating, custom.rating);
        expect(custom.copyWith(), custom);
        await t.pumpWidget(
          MaterialApp(
            home: HyperDeviceDetector(
              deviceType: device,
              builder: (_, device, child) => child!,
              child: HyperTheme(
                data: theme,
                child: Scaffold(
                  body: Align(
                    alignment: Alignment.topLeft,
                    child: HyperRating(value: 2, onChanged: (_) {}),
                  ),
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(t.getSize(find.byType(HyperRating)).height, 32);
        expect(
          t
              .widgetList<Icon>(find.byType(Icon))
              .every((icon) => icon.size == 24),
          isTrue,
        );
      }
    },
  );
  for (final axis in Axis.values) {
    testWidgets(
      '$axis visual gap stays independent of perpendicular hit extent',
      (t) async {
        await t.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: HyperRating(
                    value: 2,
                    direction: axis,
                    onChanged: (_) {},
                    style: const HyperRatingStyle(
                      iconSize: 20,
                      gap: 6,
                      hitExtent: 48,
                    ),
                    itemBuilder: (_, i, fraction) => SizedBox(
                      key: ValueKey('star-$i'),
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final first = t.getRect(find.byKey(const ValueKey('star-0')));
        final second = t.getRect(find.byKey(const ValueKey('star-1')));
        expect(
          axis == Axis.horizontal
              ? second.left - first.right
              : second.top - first.bottom,
          6,
        );
        final target = find
            .ancestor(
              of: find.byKey(const ValueKey('star-0')),
              matching: find.byType(GestureDetector),
            )
            .first;
        final size = t.getSize(target);
        expect(axis == Axis.horizontal ? size.width : size.height, 20);
        expect(axis == Axis.horizontal ? size.height : size.width, 48);
        expect(t.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'committed value survives pointer exit and keyboard clears stale preview',
    (t) async {
      double value = 1;
      final fractions = <int, double>{};
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: StatefulBuilder(
                builder: (_, set) => Align(
                  alignment: Alignment.topLeft,
                  child: HyperRating(
                    value: value,
                    onChanged: (v) => set(() => value = v),
                    style: const HyperRatingStyle(
                      iconSize: 20,
                      gap: 6,
                      hitExtent: 48,
                    ),
                    itemBuilder: (_, i, fraction) {
                      fractions[i] = fraction;
                      return SizedBox(
                        key: ValueKey('star-$i'),
                        width: 20,
                        height: 20,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(700, 400));
      addTearDown(mouse.removePointer);
      await mouse.moveTo(t.getCenter(find.byKey(const ValueKey('star-3'))));
      await t.pumpAndSettle();
      expect(value, 1); // Hover is a preview, not a saved change.
      expect(fractions[3], .5);
      await t.tapAt(t.getCenter(find.byKey(const ValueKey('star-1'))));
      await t.pumpAndSettle();
      expect(value, 1.5);
      await mouse.moveTo(const Offset(700, 400));
      await t.pumpAndSettle();
      expect(value, 1.5);
      expect(fractions[1], .5);
      await mouse.moveTo(t.getCenter(find.byKey(const ValueKey('star-4'))));
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pumpAndSettle();
      expect(value, 0);
      expect(fractions.values.every((v) => v == 0), isTrue);
      await mouse.moveTo(const Offset(700, 400));
      await t.pumpAndSettle();
      expect(value, 0);
      expect(t.takeException(), isNull);
    },
  );
}
