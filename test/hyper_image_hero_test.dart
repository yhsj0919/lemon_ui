import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'hyper_image_tools_test.dart' as support;

void main() {
  for (final config in [(false, true), (true, true), (false, false)]) {
    final (reduced, enableHero) = config;
    testWidgets(
      'preview Hero returns to current thumbnail; reduced=$reduced enabled=$enableHero',
      (tester) async {
        final image = await support.source(tester);
        final bytes = await support.png(tester, image);
        image.dispose();
        final provider = ResizeImage(
          MemoryImage(bytes),
          width: 80,
          height: 60,
          allowUpscaling: true,
        );
        final controller = HyperImagePreviewController();
        await tester.pumpWidget(
          support.host(
            Builder(
              builder: (context) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 2; i++)
                    GestureDetector(
                      key: ValueKey('thumbnail-$i'),
                      onTap: () => showHyperImagePreview(
                        context: context,
                        enableHero: enableHero,
                        controller: controller,
                        items: [
                          for (var j = 0; j < 2; j++)
                            HyperImagePreviewItem(
                              image: provider,
                              heroTag: 'photo-$j',
                            ),
                        ],
                      ),
                      child: RepaintBoundary(
                        key: ValueKey('thumbnail-paint-$i'),
                        child: HyperImage(
                          image: provider,
                          width: 80,
                          height: 60,
                          heroTag: 'photo-$i',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            reduced: reduced,
            theme: HyperThemeData.light().copyWith(
              materialTheme: const HyperMaterialThemeData(
                quality: HyperMaterialQuality.advanced,
                material: HyperSurfaceMaterial.frostedGlass(),
              ),
            ),
          ),
        );
        await support.decoded(tester);
        Future<void> expectThumbnailsPainted() async {
          for (var i = 0; i < 2; i++) {
            final boundary = tester.renderObject<RenderRepaintBoundary>(
              find.byKey(ValueKey('thumbnail-paint-$i')),
            );
            final count = await tester.runAsync(() async {
              final frame = await boundary.toImage();
              final data = (await frame.toByteData(
                format: ui.ImageByteFormat.rawRgba,
              ))!;
              var red = 0;
              for (var pixel = 0; pixel < data.lengthInBytes; pixel += 4) {
                if (data.getUint8(pixel) > 180 &&
                    data.getUint8(pixel + 1) < 110 &&
                    data.getUint8(pixel + 2) < 110) {
                  red++;
                }
              }
              frame.dispose();
              return red;
            });
            expect(
              count,
              greaterThan(50),
              reason: 'Thumbnail $i must stay painted behind the preview.',
            );
          }
        }

        await expectThumbnailsPainted();
        await tester.tap(find.byKey(const ValueKey('thumbnail-0')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        await expectThumbnailsPainted();
        void checkBackdropAncestors() {
          final elements = find
              .descendant(
                of: find.byType(HyperDialog),
                matching: find.byType(BackdropFilter),
              )
              .evaluate();
          for (final element in elements) {
            if (!(element.widget as BackdropFilter).enabled) {
              continue;
            }
            element.visitAncestorElements((ancestor) {
              final widget = ancestor.widget;
              if (widget is Opacity) expect(widget.opacity, anyOf(0, 1));
              if (widget is FadeTransition) {
                expect(widget.opacity.value, anyOf(0, 1));
              }
              return true;
            });
          }
        }

        checkBackdropAncestors();
        if (!reduced && enableHero) {
          expect(
            find.byType(Image),
            findsOneWidget,
            reason: 'A real Hero shuttle must fly in the Navigator overlay.',
          );
          expect(tester.getSize(find.byType(Image)).width, greaterThan(80));
        } else {
          expect(find.byType(Image), findsNothing);
        }
        await tester.pumpAndSettle();
        checkBackdropAncestors();
        await expectThumbnailsPainted();
        final pageBoundary = tester.renderObject<RenderRepaintBoundary>(
          find
              .descendant(
                of: find.byType(HyperImagePreview),
                matching: find.byType(RepaintBoundary),
              )
              .first,
        );
        final redCount = await tester.runAsync(() async {
          final frame = await pageBoundary.toImage();
          final data = (await frame.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!;
          var count = 0;
          for (var i = 0; i < data.lengthInBytes; i += 4) {
            if (data.getUint8(i) > 180 &&
                data.getUint8(i + 1) < 110 &&
                data.getUint8(i + 2) < 110) {
              count++;
            }
          }
          frame.dispose();
          return count;
        });
        expect(
          redCount,
          greaterThan(100),
          reason: 'The landed preview must still paint its decoded image.',
        );
        controller.next();
        await tester.pumpAndSettle();
        expect(controller.index, 1);
        await expectThumbnailsPainted();
        final previewContext = tester.element(find.byType(HyperImagePreview));
        Navigator.of(previewContext).pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        if (!reduced && enableHero) expect(find.byType(Image), findsOneWidget);
        await expectThumbnailsPainted();
        await tester.pumpAndSettle();
        expect(find.byType(HyperImagePreview), findsNothing);
        expect(find.byType(HyperImage), findsNWidgets(2));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
      },
    );
  }
}
