import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final dialog in [false, true]) {
    testWidgets(
      'advanced color picker opening keeps the real backdrop: dialog=$dialog',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              duration: Duration.zero,
              data: HyperThemeData.light().copyWith(
                materialTheme: const HyperMaterialThemeData(
                  quality: HyperMaterialQuality.advanced,
                  material: HyperSurfaceMaterial.frostedGlass(
                    background: HyperFill.color(Color(0x70FFFFFF)),
                  ),
                ),
              ),
              child: Scaffold(
                body: Builder(
                  builder: (context) => dialog
                      ? HyperButton.outlined(
                          child: const Text('Open'),
                          onPressed: () {
                            showHyperColorPickerDialog(
                              context: context,
                              initialColor: const Color(0xFF3482FF),
                            );
                          },
                        )
                      : HyperColorPickerField(
                          presentation: HyperSelectPresentation.anchored,
                          value: const Color(0xFF3482FF),
                          onChanged: (_) {},
                        ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(HyperButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        void verify() {
          final filters = find.byType(BackdropFilter);
          expect(filters, findsWidgets);
          for (final filter in filters.evaluate()) {
            if (!(filter.widget as BackdropFilter).enabled) continue;
            final ancestors = find.ancestor(
              of: find.byWidget(filter.widget),
              matching: find.byType(Opacity),
            );
            for (final opacity in tester.widgetList<Opacity>(ancestors)) {
              expect(opacity.opacity == 0 || opacity.opacity == 1, isTrue);
            }
            final fades = find.ancestor(
              of: find.byWidget(filter.widget),
              matching: find.byType(FadeTransition),
            );
            for (final fade in tester.widgetList<FadeTransition>(fades)) {
              expect(
                fade.opacity.value == 0 || fade.opacity.value == 1,
                isTrue,
              );
            }
          }
          expect(tester.takeException(), isNull);
        }

        verify();
        final palette = tester.element(
          find.byKey(const ValueKey('hyper-color-picker-palette')),
        );
        await tester.pumpAndSettle();
        verify();
        expect(
          tester.element(
            find.byKey(const ValueKey('hyper-color-picker-palette')),
          ),
          same(palette),
        );
      },
    );
  }
}
