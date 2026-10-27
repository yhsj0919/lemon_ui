import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/color_picker/hyper_color_swatch.dart';

void main() {
  for (final circle in [false, true]) {
    testWidgets(
      'color sample fills center without icon fonts, circle=$circle',
      (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: Center(
                child: RepaintBoundary(
                  key: key,
                  child: IconTheme(
                    data: const IconThemeData(size: 32),
                    child: HyperColorSwatch(
                      color: const Color(0xFF3482FF),
                      circle: circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.byType(Icon), findsNothing);
        expect(
          tester.getSize(find.byType(HyperColorSwatch)),
          const Size(32, 32),
        );
        await tester.runAsync(() async {
          final image =
              await (key.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage();
          final data = (await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!;
          final offset = (16 * image.width + 16) * 4;
          expect(
            [
              for (var channel = 0; channel < 4; channel++)
                data.getUint8(offset + channel),
            ],
            [52, 130, 255, 255],
          );
          image.dispose();
        });
      },
    );
  }
}
