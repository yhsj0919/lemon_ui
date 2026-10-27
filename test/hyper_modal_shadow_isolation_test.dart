import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final sheet in [true, false]) {
    for (final glass in [false, true]) {
      for (final disableShadow in [false, true]) {
        testWidgets(
          'modal sheet=$sheet glass=$glass disabled=$disableShadow keeps shadow outside',
          (tester) async {
            final key = GlobalKey();
            const fill = HyperFill.color(Color(0x33FFFFFF));
            final shadows = disableShadow
                ? const <BoxShadow>[]
                : const [
                    BoxShadow(
                      color: Color(0xA0FF0000),
                      blurRadius: 12,
                      spreadRadius: 8,
                    ),
                  ];
            const material = HyperSurfaceMaterial.frostedGlass(
              background: fill,
              blurSigmaX: 8,
              blurSigmaY: 8,
            );
            await tester.pumpWidget(
              MaterialApp(
                home: HyperTheme(
                  data: HyperThemeData.light().copyWith(
                    materialTheme: const HyperMaterialThemeData(
                      quality: HyperMaterialQuality.advanced,
                    ),
                  ),
                  duration: Duration.zero,
                  child: Center(
                    child: RepaintBoundary(
                      key: key,
                      child: ColoredBox(
                        color: Colors.white,
                        child: SizedBox(
                          width: 240,
                          height: 200,
                          child: Center(
                            child: sheet
                                ? HyperBottomSheet(
                                    showDragHandle: false,
                                    useBottomSafeArea: false,
                                    style: HyperBottomSheetStyle(
                                      width: 120,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      borderRadius: BorderRadius.circular(12),
                                      background: fill,
                                      material: glass ? material : null,
                                      boxShadow: shadows,
                                    ),
                                    content: const SizedBox(height: 80),
                                  )
                                : HyperDialog(
                                    showCloseButton: false,
                                    style: HyperDialogStyle(
                                      width: 120,
                                      padding: EdgeInsets.zero,
                                      insetPadding: EdgeInsets.zero,
                                      borderRadius: BorderRadius.circular(12),
                                      background: fill,
                                      material: glass ? material : null,
                                      boxShadow: shadows,
                                    ),
                                    content: const SizedBox(height: 80),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            await tester.runAsync(() async {
              final image =
                  await (key.currentContext!.findRenderObject()!
                          as RenderRepaintBoundary)
                      .toImage();
              final data = (await image.toByteData(
                format: ui.ImageByteFormat.rawRgba,
              ))!;
              int green(int x, int y) =>
                  data.getUint8((y * image.width + x) * 4 + 1);
              expect(
                green(65, 100),
                greaterThanOrEqualTo(253),
                reason: 'inside the translucent modal must not sample its own red shadow',
              );
              expect(green(120, 100), greaterThanOrEqualTo(253));
              expect(
                green(52, 100),
                disableShadow ? greaterThanOrEqualTo(253) : lessThan(250),
                reason: 'outside shadow is preserved',
              );
              image.dispose();
            });
          },
        );
      }
    }
  }
}
