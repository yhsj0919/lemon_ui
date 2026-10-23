import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/charts/hyper_chart_pointer_tooltip.dart';

void main() {
  testWidgets(
    'capture waits for pending layout and exports the latest full dimensions',
    (tester) async {
      final controller = HyperChartExportController();
      late StateSetter update;
      var changed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    update = setState;
                    return HyperChartExportBoundary(
                      controller: controller,
                      child: SizedBox(
                        width: changed ? 320 : 200,
                        height: changed ? 180 : 100,
                        child: ColoredBox(
                          color: changed ? Colors.red : Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      update(() => changed = true);
      final pending = controller.capturePng();
      await tester.pump();
      await tester.pump();
      final bytes = (await tester.runAsync(() => pending))!;
      await tester.runAsync(() async {
        final codec = await ui.instantiateImageCodec(bytes);
        final image = (await codec.getNextFrame()).image;
        expect(image.width, 640);
        expect(image.height, 360);
        final rgba = (await image.toByteData())!.buffer.asUint8List();
        expect(rgba.take(4), [244, 67, 54, 255]);
        image.dispose();
        codec.dispose();
      });
      expect(
        () => controller.captureImage(pixelRatio: double.nan),
        throwsArgumentError,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'export omits a visible tooltip and restores it without changing hover',
    (tester) async {
      final controller = HyperChartExportController();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: SizedBox(
                width: 400,
                height: 300,
                child: HyperChartExportBoundary(
                  controller: controller,
                  child: HyperPointerTooltipArea(
                    position: const Offset(100, 100),
                    message: '悬停提示',
                    onExit: () {},
                    child: const ColoredBox(color: Colors.cyan),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> verify(bool includeTooltip) async {
        final pending = controller.capturePng(
          pixelRatio: 1,
          includeTooltip: includeTooltip,
        );
        await tester.pump();
        await tester.pump();
        final bytes = (await tester.runAsync(() => pending))!;
        await tester.runAsync(() async {
          final codec = await ui.instantiateImageCodec(bytes);
          final image = (await codec.getNextFrame()).image;
          expect(image.width, 400);
          expect(image.height, 300);
          final rgba = (await image.toByteData())!.buffer.asUint8List();
          var different = 0;
          for (var i = 0; i < rgba.length; i += 4) {
            if (rgba[i] != 0 ||
                rgba[i + 1] != 188 ||
                rgba[i + 2] != 212 ||
                rgba[i + 3] != 255) {
              different++;
            }
          }
          expect(different > 0, includeTooltip);
          image.dispose();
          codec.dispose();
        });
        await tester.pumpAndSettle();
        expect(find.text('悬停提示'), findsOneWidget);
      }

      await verify(false);
      await verify(true);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'PNG exports full chart bounds while scrolled partially outside viewport',
    (tester) async {
      final controller = HyperChartExportController();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 400,
                  height: 180,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        HyperChartExportBoundary(
                          controller: controller,
                          child: SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(color: Colors.red),
                                      ),
                                      Expanded(
                                        child: Container(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(color: Colors.blue),
                                      ),
                                      Expanded(
                                        child: Container(color: Colors.yellow),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final pending = controller.capturePng(pixelRatio: 1);
      await tester.pump();
      await tester.pump();
      final bytes = (await tester.runAsync(() => pending))!;
      await tester.runAsync(() async {
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        expect(frame.image.width, 400);
        expect(frame.image.height, 300);
        final rgba = (await frame.image.toByteData())!.buffer.asUint8List();
        int pixel(int x, int y) {
          final offset = (y * 400 + x) * 4;
          return (rgba[offset + 3] << 24) |
              (rgba[offset] << 16) |
              (rgba[offset + 1] << 8) |
              rgba[offset + 2];
        }

        expect(pixel(20, 20), Colors.red.toARGB32());
        expect(pixel(380, 20), Colors.green.toARGB32());
        expect(pixel(20, 280), Colors.blue.toARGB32());
        expect(pixel(380, 280), Colors.yellow.toARGB32());
        frame.image.dispose();
        codec.dispose();
      });
    },
  );
}
