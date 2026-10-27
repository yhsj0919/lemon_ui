import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/menu/hyper_menu_surface.dart';

void main() {
  testWidgets('advanced menu retains white fill on a white backdrop', (
    tester,
  ) async {
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          duration: Duration.zero,
          data: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
            ),
          ),
          child: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: Center(
                    child: Builder(
                      builder: (context) => HyperCard(
                        width: 200,
                        height: 100,
                        style: resolveHyperMenuSurface(
                          context,
                          radius: 12,
                          padding: EdgeInsets.zero,
                        ),
                      ),
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
          await (boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary)
              .toImage();
      final data = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!;
      for (final point in [const Offset(150, 100), const Offset(65, 100)]) {
        final offset = (point.dy.toInt() * image.width + point.dx.toInt()) * 4;
        expect([
          for (var channel = 0; channel < 4; channel++)
            data.getUint8(offset + channel),
        ], everyElement(greaterThanOrEqualTo(253)));
      }
      image.dispose();
    });
  });
}
