import 'package:flutter/gestures.dart' show PointerScrollEvent;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/vendor/extended_image/extended_image.dart';
// These tests target the dependency code that owns crop-handle geometry.
// ignore: implementation_imports
import 'package:lemon_ui/src/vendor/extended_image/src/editor/crop_layer.dart';
// ignore: implementation_imports
import 'package:lemon_ui/src/vendor/extended_image/src/editor/crop_rect_boundary.dart';

import 'hyper_image_tools_test.dart' as support;

void main() {
  for (final vertical in [false, true]) {
    testWidgets(
      'public flip paints successive intermediate frames: $vertical',
      (tester) async {
        final image = await support.source(tester);
        final bytes = await support.png(tester, image);
        image.dispose();
        final controller = HyperImageEditorController();
        final boundaryKey = GlobalKey();
        await tester.pumpWidget(
          support.host(
            RepaintBoundary(
              key: boundaryKey,
              child: SizedBox(
                width: 500,
                height: 500,
                child: HyperImageEditor(bytes: bytes, controller: controller),
              ),
            ),
            reduced: false,
          ),
        );
        await support.decoded(tester);
        Future<int> redPixels() async {
          final boundary =
              boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          return (await tester.runAsync(() async {
            final frame = await boundary.toImage();
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
          }))!;
        }

        final initial = await redPixels();
        if (vertical) {
          controller.flipVertical();
        } else {
          controller.flipHorizontal();
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        final first = await redPixels();
        await tester.pump(const Duration(milliseconds: 30));
        final second = await redPixels();
        expect(first, greaterThan(100));
        expect(first, lessThan(initial));
        expect(second, greaterThan(100));
        expect(second, lessThan(first));
        final painter = tester
            .widgetList<CustomPaint>(find.byType(CustomPaint))
            .map((w) => w.painter)
            .whereType<ExtendedImageCropLayerPainter>()
            .single;
        expect(painter.pointerDown, isFalse);
        final cropFinder = find.byType(ExtendedImageCropLayer);
        final cropLayer = tester.widget<ExtendedImageCropLayer>(cropFinder);
        final sourceCrop = cropLayer.editActionDetails.cropRect!;
        final painted = painter.cropRect;
        expect(
          vertical ? painted.height : painted.width,
          lessThan(vertical ? sourceCrop.height : sourceCrop.width),
        );
        expect(
          vertical ? painted.width : painted.height,
          closeTo(vertical ? sourceCrop.width : sourceCrop.height, 1e-6),
        );
        final gap = vertical
            ? Offset(sourceCrop.center.dx, (sourceCrop.top + painted.top) / 2)
            : Offset(
                (sourceCrop.left + painted.left) / 2,
                sourceCrop.center.dy,
              );
        final offset =
            tester.getTopLeft(cropFinder) -
            tester.getTopLeft(find.byKey(boundaryKey));
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final maskPixels = await tester.runAsync(() async {
          final frame = await boundary.toImage();
          final data = (await frame.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!;
          List<int> pixel(Offset point) {
            final index =
                (point.dy.floor() * frame.width + point.dx.floor()) * 4;
            return List.generate(
              4,
              (channel) => data.getUint8(index + channel),
            );
          }

          final result = [
            pixel(offset + gap),
            pixel(offset + const Offset(2, 2)),
          ];
          frame.dispose();
          return result;
        });
        expect(
          maskPixels![0],
          maskPixels[1],
          reason: 'The uncovered strip must use the outside mask, not a white crop opening.',
        );
        await tester.pumpAndSettle();
        controller.rotateClockwise();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        final rotating = tester
            .widgetList<CustomPaint>(find.byType(CustomPaint))
            .map((w) => w.painter)
            .whereType<ExtendedImageCropLayerPainter>()
            .single;
        expect(rotating.pointerDown, isFalse);
        await tester.pumpAndSettle();
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final vertical in [false, true]) {
    testWidgets('flip animation uses the requested axis: vertical=$vertical', (
      tester,
    ) async {
      final image = await support.source(tester);
      final bytes = await support.png(tester, image);
      image.dispose();
      await tester.pumpWidget(
        support.host(
          SizedBox(
            width: 500,
            height: 500,
            child: HyperImageEditor(bytes: bytes),
          ),
          reduced: false,
        ),
      );
      await support.decoded(tester);
      final layer = tester.widget<ExtendedImageCropLayer>(
        find.byType(ExtendedImageCropLayer),
      );
      final backend = layer.editorConfig.controller!;
      final before = backend.getCropRect()!;
      backend.flip(
        vertical: vertical,
        animation: true,
        duration: const Duration(milliseconds: 400),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final details = backend.editActionDetails!;
      final transform = details.flipAnimationTransform!;
      expect(transform.entry(vertical ? 0 : 1, vertical ? 0 : 1), 1);
      expect(
        transform.entry(vertical ? 1 : 0, vertical ? 1 : 0),
        inExclusiveRange(0.0, 1.0),
      );
      expect(backend.getCropRect(), before);
      expect(details.rotateDegrees, 0);
      await tester.pump(const Duration(milliseconds: 301));
      expect(details.flipAnimationTransform, isNull);
      expect(details.flipY, isTrue);
      expect(details.rotateDegrees, vertical ? 180 : 0);
      backend.undo();
      await tester.pump();
      expect(backend.editActionDetails!.hasEditAction, isFalse);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  }
  test('free crop clips only the moved axes at each boundary', () {
    const current = Rect.fromLTRB(20, 20, 80, 80),
        bounds = Rect.fromLTRB(0, 0, 100, 100);
    for (final pair in [
      (
        const Rect.fromLTRB(-20, 20, 80, 80),
        const Rect.fromLTRB(0, 20, 80, 80),
      ),
      (
        const Rect.fromLTRB(20, 20, 120, 80),
        const Rect.fromLTRB(20, 20, 100, 80),
      ),
      (
        const Rect.fromLTRB(20, -20, 80, 80),
        const Rect.fromLTRB(20, 0, 80, 80),
      ),
      (
        const Rect.fromLTRB(20, 20, 80, 120),
        const Rect.fromLTRB(20, 20, 80, 100),
      ),
      (
        const Rect.fromLTRB(-20, -20, 80, 80),
        const Rect.fromLTRB(0, 0, 80, 80),
      ),
    ]) {
      expect(
        constrainCropRect(current, pair.$1, bounds, preserveAspectRatio: false),
        pair.$2,
      );
    }
  });
  test(
    'fixed-ratio crop stops at first boundary with the same ratio and anchor',
    () {
      const current = Rect.fromLTRB(20, 20, 80, 80),
          bounds = Rect.fromLTRB(0, 0, 100, 100);
      for (final candidate in [
        const Rect.fromLTRB(-40, -40, 80, 80),
        const Rect.fromLTRB(20, 20, 160, 160),
        const Rect.fromLTRB(-30, 20, 80, 130),
      ]) {
        final rect = constrainCropRect(
          current,
          candidate,
          bounds,
          preserveAspectRatio: true,
        );
        expect(rect.width / rect.height, closeTo(1, 1e-9));
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.top, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(100));
        expect(rect.bottom, lessThanOrEqualTo(100));
      }
      const wide = Rect.fromLTRB(20, 30, 80, 60),
          candidate = Rect.fromLTRB(20, 0, 200, 90);
      final rect = constrainCropRect(
        wide,
        candidate,
        bounds,
        preserveAspectRatio: true,
      );
      expect(rect.width / rect.height, closeTo(2, 1e-9));
      expect(rect.left, 20);
      expect(rect.center.dy, 45);
    },
  );
  test('bounded crop setting copies, interpolates configuration equality and defaults off upstream', () {
    final original = EditorConfig(),
        bounded = EditorConfig(constrainCropRect: true);
    expect(original.constrainCropRect, isFalse);
    expect(bounded.copyWith(), bounded);
    expect(bounded.copyWith().hashCode, bounded.hashCode);
    expect(bounded, isNot(original));
    expect(bounded.copyWith(constrainCropRect: false), original);
  });
  for (final side in ['left', 'right', 'top', 'bottom']) {
    testWidgets(
      'mouse $side edge overshoot preserves the perpendicular crop extent',
      (tester) async {
        final image = await support.source(tester);
        final bytes = await support.png(tester, image);
        image.dispose();
        await tester.pumpWidget(
          support.host(
            SizedBox(
              width: 500,
              height: 500,
              child: HyperImageEditor(bytes: bytes),
            ),
          ),
        );
        await support.decoded(tester);
        final finder = find.byType(ExtendedImageCropLayer);
        final layer = tester.widget<ExtendedImageCropLayer>(finder);
        final original = layer.editActionDetails.cropRect!;
        final point = switch (side) {
          'left' => original.centerLeft,
          'right' => original.centerRight,
          'top' => original.topCenter,
          _ => original.bottomCenter,
        };
        final delta = switch (side) {
          'left' => const Offset(-15, 0),
          'right' => const Offset(15, 0),
          'top' => const Offset(0, -15),
          _ => const Offset(0, 15),
        };
        final pointer = await tester.startGesture(
          tester.getTopLeft(finder) + point,
          kind: ui.PointerDeviceKind.mouse,
        );
        for (var i = 0; i < 20; i++) {
          await pointer.moveBy(delta);
          await tester.pump(const Duration(milliseconds: 16));
          final crop = tester
              .widget<ExtendedImageCropLayer>(finder)
              .editActionDetails
              .cropRect!;
          if (side == 'left' || side == 'right') {
            expect(crop.top, closeTo(original.top, .001));
            expect(crop.bottom, closeTo(original.bottom, .001));
          } else {
            expect(crop.left, closeTo(original.left, .001));
            expect(crop.right, closeTo(original.right, .001));
          }
        }
        await pointer.up();
        await tester.pumpAndSettle();
        await tester.pumpWidget(const SizedBox());
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('fixed-ratio mouse overshoot stops resizing at the boundary', (
    tester,
  ) async {
    final image = await support.source(tester);
    final bytes = await support.png(tester, image);
    image.dispose();
    await tester.pumpWidget(
      support.host(
        SizedBox(
          width: 500,
          height: 500,
          child: HyperImageEditor(bytes: bytes, cropAspectRatio: 1),
        ),
      ),
    );
    await support.decoded(tester);
    final finder = find.byType(ExtendedImageCropLayer);
    final original = tester
        .widget<ExtendedImageCropLayer>(finder)
        .editActionDetails
        .cropRect!;
    final pointer = await tester.startGesture(
      tester.getTopLeft(finder) + original.centerRight,
      kind: ui.PointerDeviceKind.mouse,
    );
    Rect? last;
    for (var i = 0; i < 20; i++) {
      await pointer.moveBy(const Offset(15, 0));
      await tester.pump(const Duration(milliseconds: 16));
      final crop = tester
          .widget<ExtendedImageCropLayer>(finder)
          .editActionDetails
          .cropRect!;
      expect(crop.width / crop.height, closeTo(1, .001));
      if (i > 10) {
        expect(crop.left, closeTo(last!.left, 1e-6));
        expect(crop.top, closeTo(last.top, 1e-6));
        expect(crop.right, closeTo(last.right, 1e-6));
        expect(crop.bottom, closeTo(last.bottom, 1e-6));
      }
      last = crop;
    }
    await pointer.up();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'free crop shrinks, expands to the edge and reverses immediately after overshoot',
    (tester) async {
      final image = await support.source(tester);
      final bytes = await support.png(tester, image);
      image.dispose();
      await tester.pumpWidget(
        support.host(
          SizedBox(
            width: 500,
            height: 500,
            child: HyperImageEditor(bytes: bytes),
          ),
        ),
      );
      await support.decoded(tester);
      final finder = find.byType(ExtendedImageCropLayer);
      final initial = tester
          .widget<ExtendedImageCropLayer>(finder)
          .editActionDetails
          .cropRect!;
      Rect crop() => tester
          .widget<ExtendedImageCropLayer>(finder)
          .editActionDetails
          .cropRect!;
      final pointer = await tester.startGesture(
        tester.getTopLeft(finder) + initial.centerRight,
        kind: ui.PointerDeviceKind.mouse,
      );
      for (var i = 0; i < 8; i++) {
        await pointer.moveBy(const Offset(-10, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(crop().width, lessThan(initial.width));
      expect(crop().height, closeTo(initial.height, 1e-6));
      for (var i = 0; i < 20; i++) {
        await pointer.moveBy(const Offset(10, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(crop().right, closeTo(initial.right, 1e-6));
      final edge = crop();
      await pointer.moveBy(const Offset(-10, 0));
      await tester.pump(const Duration(milliseconds: 16));
      expect(crop().right, lessThan(edge.right));
      expect(crop().height, closeTo(initial.height, 1e-6));
      await pointer.up();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('rotated free crop mouse overshoot keeps the other axis stable', (
    tester,
  ) async {
    final image = await support.source(tester);
    final bytes = await support.png(tester, image);
    image.dispose();
    final controller = HyperImageEditorController();
    await tester.pumpWidget(
      support.host(
        SizedBox(
          width: 500,
          height: 500,
          child: HyperImageEditor(bytes: bytes, controller: controller),
        ),
      ),
    );
    await support.decoded(tester);
    controller.rotateClockwise();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final finder = find.byType(ExtendedImageCropLayer);
    final initial = tester
        .widget<ExtendedImageCropLayer>(finder)
        .editActionDetails
        .cropRect!;
    final pointer = await tester.startGesture(
      tester.getTopLeft(finder) + initial.centerRight,
      kind: ui.PointerDeviceKind.mouse,
    );
    for (var i = 0; i < 20; i++) {
      await pointer.moveBy(const Offset(15, 0));
      await tester.pump(const Duration(milliseconds: 16));
      final crop = tester
          .widget<ExtendedImageCropLayer>(finder)
          .editActionDetails
          .cropRect!;
      expect(crop.top, closeTo(initial.top, 1e-6));
      expect(crop.height, closeTo(initial.height, 1e-6));
    }
    await pointer.up();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    expect(tester.takeException(), isNull);
  });
  testWidgets('zoomed horizontal expansion preserves source vertical extent', (
    tester,
  ) async {
    final image = await support.source(tester);
    final bytes = await support.png(tester, image);
    image.dispose();
    await tester.pumpWidget(
      support.host(
        SizedBox(
          width: 500,
          height: 500,
          child: HyperImageEditor(bytes: bytes),
        ),
      ),
    );
    await support.decoded(tester);
    final finder = find.byType(ExtendedImageCropLayer);
    await tester.sendEventToBinding(
      PointerScrollEvent(
        position: tester.getCenter(finder),
        scrollDelta: const Offset(0, 1000),
        kind: ui.PointerDeviceKind.mouse,
      ),
    );
    await tester.pump();
    final layer = tester.widget<ExtendedImageCropLayer>(finder);
    final backend = layer.editorConfig.controller!;
    final initial = backend.getCropRect()!;
    final pointer = await tester.startGesture(
      tester.getTopLeft(finder) + layer.editActionDetails.cropRect!.centerRight,
      kind: ui.PointerDeviceKind.mouse,
    );
    for (var i = 0; i < 35; i++) {
      await pointer.moveBy(const Offset(20, 0));
      await tester.pump(const Duration(milliseconds: 16));
      final crop = backend.getCropRect()!;
      expect(crop.top, closeTo(initial.top, 1e-4));
      expect(crop.height, closeTo(initial.height, 1e-4));
    }
    expect(backend.getCropRect()!.width, greaterThan(initial.width));
    expect(backend.getCropRect()!.right, closeTo(3, 1e-4));
    await pointer.up();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  for (final ratio in <double?>[null, 1.5]) {
    testWidgets('zoomed crop expands beyond viewport with ratio $ratio', (
      tester,
    ) async {
      final image = await support.source(tester);
      final bytes = await support.png(tester, image);
      image.dispose();
      final controller = HyperImageEditorController();
      await tester.pumpWidget(
        support.host(
          SizedBox(
            width: 500,
            height: 500,
            child: HyperImageEditor(
              bytes: bytes,
              controller: controller,
              cropAspectRatio: ratio,
            ),
          ),
        ),
      );
      await support.decoded(tester);
      final finder = find.byType(ExtendedImageCropLayer);
      final initialLayer = tester.widget<ExtendedImageCropLayer>(finder);
      final zoomCenter =
          tester.getTopLeft(finder) +
          initialLayer.editActionDetails.cropRect!.center;
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: zoomCenter,
          scrollDelta: const Offset(0, 1000),
          kind: ui.PointerDeviceKind.mouse,
        ),
      );
      await tester.pump();
      final backend = tester
          .widget<ExtendedImageCropLayer>(finder)
          .editorConfig
          .controller!;
      final start = backend.getCropRect()!;
      expect(start.width, lessThan(3));
      Future<void> expand(bool topLeft) async {
        final crop = tester
            .widget<ExtendedImageCropLayer>(finder)
            .editActionDetails
            .cropRect!;
        final pointer = await tester.startGesture(
          tester.getTopLeft(finder) +
              (topLeft ? crop.topLeft : crop.bottomRight),
          kind: ui.PointerDeviceKind.mouse,
        );
        for (var i = 0; i < 35; i++) {
          await pointer.moveBy(
            topLeft ? const Offset(-20, -20) : const Offset(20, 20),
          );
          await tester.pump(const Duration(milliseconds: 16));
        }
        await pointer.up();
        await tester.pumpAndSettle();
      }

      await expand(true);
      expect(backend.getCropRect()!.width, greaterThan(start.width));
      await expand(false);
      final full = backend.getCropRect()!;
      if (ratio != null) {
        expect(full.width, greaterThan(start.width));
        expect(full.width / full.height, closeTo(ratio, 1e-4));
        expect(full.top, closeTo(0, 1e-4));
        expect(full.right, closeTo(3, 1e-4));
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
        expect(tester.takeException(), isNull);
        return;
      }
      expect(full.left, closeTo(0, 1e-4));
      expect(full.top, closeTo(0, 1e-4));
      expect(full.width, closeTo(3, 1e-4));
      expect(full.height, closeTo(2, 1e-4));
      final result = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(result!.width, 3);
      expect(result.height, 2);
      expect(
        await support.colors(tester, result.bytes),
        await support.colors(tester, bytes),
      );
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    });
  }
}
