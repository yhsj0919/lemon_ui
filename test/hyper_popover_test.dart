import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/painting/hyper_box_decoration.dart';

Widget host(
  Widget child, {
  HyperThemeData? theme,
  double scale = 1,
  HyperDeviceType device = HyperDeviceType.desktop,
}) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: device,
    builder: (context, device, _) => HyperTheme(
      data: theme ?? HyperThemeData.light(),
      duration: Duration.zero,
      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(280, 600),
          textScaler: TextScaler.linear(scale),
        ),
        child: Scaffold(
          body: Align(alignment: Alignment.topLeft, child: child),
        ),
      ),
    ),
  ),
);

HyperPopover popover({HyperPopoverStyle? style, bool? isOpen}) => HyperPopover(
  anchor: const Text('anchor'),
  style: style,
  isOpen: isOpen,
  contentBuilder: (context, close) =>
      TextButton(onPressed: close, child: const Text('close panel')),
);

void main() {
  for (final device in HyperDeviceType.values) {
    testWidgets('surface dimensions inherit $device menu semantics', (
      tester,
    ) async {
      final base = HyperThemeData.light();
      final size = base.sizes.resolve(device);
      await tester.pumpWidget(
        host(popover(isOpen: true), theme: base, device: device),
      );
      await tester.pumpAndSettle();
      final style = tester.widget<HyperCard>(find.byType(HyperCard)).style!;
      expect(style.padding, EdgeInsets.all(size.menu.padding));
      expect(
        style.borderRadius,
        BorderRadius.circular(size.menu.surfaceRadius),
      );
      expect(tester.takeException(), isNull);
    });
  }
  for (final quality in HyperMaterialQuality.values) {
    testWidgets('shared material degrades at $quality and preserves shadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          popover(isOpen: true),
          theme: HyperThemeData.light().copyWith(
            materialTheme: HyperMaterialThemeData(quality: quality),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<BackdropFilter>(find.byType(BackdropFilter))
            .any((filter) => filter.enabled),
        quality == HyperMaterialQuality.advanced,
      );
      final decorations = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(HyperCard),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<HyperBoxDecoration>();
      expect(
        decorations.any(
          (decoration) => decoration.boxShadow?.isNotEmpty ?? false,
        ),
        isTrue,
      );
    });
  }
  test(
    'style merge, copy, lerp and global theme equality retain overrides',
    () {
      final a = HyperPopoverStyle(
        spacing: 4,
        surfaceStyle: HyperCardStyle(
          boxShadow: const [],
          padding: const EdgeInsets.all(8),
        ),
      );
      final b = a.merge(const HyperPopoverStyle(spacing: 12));
      expect(b.surfaceStyle!.boxShadow, isEmpty);
      expect(b.surfaceStyle!.padding, const EdgeInsets.all(8));
      expect(HyperPopoverStyle.lerp(a, b, .5).spacing, 8);
      final theme = HyperThemeData.light();
      final changed = theme.copyWith(
        popoverTheme: HyperPopoverThemeData(style: a),
      );
      expect(changed, isNot(theme));
      expect(changed.copyWith(), changed);
      expect(
        changed
            .lerp(
              theme.copyWith(popoverTheme: HyperPopoverThemeData(style: b)),
              .5,
            )
            .popoverTheme
            .style
            .spacing,
        8,
      );
    },
  );

  testWidgets(
    'default surface uses shared glass and shadow and closes by content and escape',
    (tester) async {
      await tester.pumpWidget(host(popover()));
      expect(find.text('close panel'), findsNothing);
      await tester.tap(find.text('anchor'));
      await tester.pumpAndSettle();
      final card = tester.widget<HyperCard>(find.byType(HyperCard));
      expect(
        card.style!.material!.kind,
        HyperSurfaceMaterialKind.softLightGlass,
      );
      expect(card.style!.material!.boxShadow, isNotEmpty);
      await tester.tap(find.text('close panel'));
      await tester.pumpAndSettle();
      expect(find.text('close panel'), findsNothing);
      await tester.tap(find.text('anchor'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('close panel'), findsNothing);
    },
  );

  testWidgets(
    'global and local style merge, instance empty shadow wins over material',
    (tester) async {
      final recipe = HyperSurfaceMaterial.frostedGlass(
        boxShadow: const [BoxShadow(blurRadius: 10)],
      );
      await tester.pumpWidget(
        host(
          HyperMaterialTheme(
            data: HyperMaterialThemeData(material: recipe),
            child: HyperPopoverTheme(
              data: HyperPopoverThemeData(
                style: HyperPopoverStyle(
                  surfaceStyle: HyperCardStyle(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              child: popover(
                isOpen: true,
                style: HyperPopoverStyle(
                  surfaceStyle: HyperCardStyle(boxShadow: const []),
                ),
              ),
            ),
          ),
          theme: HyperThemeData.light().copyWith(
            popoverTheme: HyperPopoverThemeData(
              style: HyperPopoverStyle(
                surfaceStyle: HyperCardStyle(padding: const EdgeInsets.all(13)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final style = tester.widget<HyperCard>(find.byType(HyperCard)).style!;
      expect(style.padding, const EdgeInsets.all(13));
      expect(style.borderRadius, BorderRadius.circular(9));
      expect(style.boxShadow, isEmpty);
      final shadows = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(HyperCard),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<HyperBoxDecoration>()
          .where((decoration) => decoration.boxShadow != null);
      expect(shadows, isNotEmpty);
      expect(
        shadows.every((decoration) => decoration.boxShadow!.isEmpty),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'advanced transition keeps background sampling safe and content mounted',
    (tester) async {
      await tester.pumpWidget(
        host(
          popover(),
          theme: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
            ),
          ),
        ),
      );
      await tester.tap(find.text('anchor'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 25));
      final content = tester.element(find.text('close panel'));
      for (final duration in [
        const Duration(milliseconds: 25),
        const Duration(milliseconds: 35),
        const Duration(milliseconds: 100),
      ]) {
        await tester.pump(duration);
        for (final filter in tester.widgetList<BackdropFilter>(
          find.byType(BackdropFilter),
        )) {
          if (filter.enabled) {
            final element = tester.element(find.byWidget(filter));
            element.visitAncestorElements((ancestor) {
              final widget = ancestor.widget;
              if (widget is Opacity) {
                expect(widget.opacity == 0 || widget.opacity == 1, isTrue);
              }
              if (widget is FadeTransition) {
                expect(
                  widget.opacity.value == 0 || widget.opacity.value == 1,
                  isTrue,
                );
              }
              return true;
            });
          }
        }
        expect(tester.element(find.text('close panel')), same(content));
      }
      expect(
        tester
            .widgetList<BackdropFilter>(find.byType(BackdropFilter))
            .any((f) => f.enabled),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('narrow panel at text scale $scale', (tester) async {
      tester.view.physicalSize = const Size(280, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(host(popover(isOpen: true), scale: scale));
      await tester.pumpAndSettle();
      expect(find.text('close panel'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
