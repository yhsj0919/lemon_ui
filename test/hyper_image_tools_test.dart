// The regression targets the backend crop layer that owns drag geometry.
// ignore: implementation_imports
import 'package:lemon_ui/src/vendor/extended_image/src/editor/crop_layer.dart';
import 'package:flutter/gestures.dart' show PointerScrollEvent;
import 'package:lemon_ui/src/vendor/extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/image/hyper_image_export.dart';

Widget host(
  Widget child, {
  double scale = 1,
  HyperThemeData? theme,
  bool reduced = true,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(scale),
        disableAnimations: reduced,
      ),
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);
Future<ui.Image> source(WidgetTester tester) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.cyan,
    const Color(0xffff00ff),
  ];
  for (var y = 0; y < 2; y++) {
    for (var x = 0; x < 3; x++) {
      canvas.drawRect(
        Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1),
        Paint()..color = colors[y * 3 + x],
      );
    }
  }
  final picture = recorder.endRecording();
  final result = await tester.runAsync(() => picture.toImage(3, 2));
  picture.dispose();
  return result!;
}

Future<Uint8List> png(WidgetTester tester, ui.Image image) async =>
    (await tester.runAsync(
      () => image.toByteData(format: ui.ImageByteFormat.png),
    ))!.buffer.asUint8List();
Future<List<int>> colors(WidgetTester tester, Uint8List bytes) async {
  return (await tester.runAsync(() async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final data = (await frame.image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    ))!;
    final result = <int>[];
    for (var i = 0; i < data.lengthInBytes; i += 4) {
      result.add(
        Color.fromARGB(
          data.getUint8(i + 3),
          data.getUint8(i),
          data.getUint8(i + 1),
          data.getUint8(i + 2),
        ).toARGB32(),
      );
    }
    frame.image.dispose();
    codec.dispose();
    return result;
  }))!;
}

Future<void> decoded(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 40)),
    );
    await tester.pump(const Duration(milliseconds: 500));
  }
}

class _PreviewStream extends ImageStreamCompleter {
  void fail() => reportError(
    exception: StateError('preview image failed'),
    context: ErrorDescription('preview test'),
    silent: true,
  );
  void succeed(ui.Image image) => setImage(ImageInfo(image: image.clone()));
}

class _PreviewProvider extends ImageProvider<_PreviewProvider> {
  final attempts = <_PreviewStream>[];
  @override
  Future<_PreviewProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);
  @override
  ImageStreamCompleter loadImage(
    _PreviewProvider key,
    ImageDecoderCallback decode,
  ) {
    final stream = _PreviewStream();
    attempts.add(stream);
    return stream;
  }
}

void main() {
  testWidgets(
    'PNG export rotates then mirrors and crops the transformed coordinates',
    (tester) async {
      final image = await source(tester);
      final original = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.cyan,
        const Color(0xffff00ff),
      ].map((c) => c.toARGB32()).toList();
      var expected = original;
      for (var q = 0; q < 4; q++) {
        final w = q.isOdd ? 2 : 3, h = q.isOdd ? 3 : 2;
        if (q > 0) {
          final oldW = q.isOdd ? 3 : 2, oldH = q.isOdd ? 2 : 3;
          expected = [
            for (var y = 0; y < oldW; y++)
              for (var x = 0; x < oldH; x++)
                expected[(oldH - 1 - x) * oldW + y],
          ];
        }
        final result = await tester.runAsync(
          () => exportHyperImagePng(
            image,
            cropRect: Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
            quarterTurns: q,
          ),
        );
        expect(result!.width, w);
        expect(result.height, h);
        expect(await colors(tester, result.bytes), expected);
        final flipped = await tester.runAsync(
          () => exportHyperImagePng(
            image,
            cropRect: Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
            quarterTurns: q,
            flipHorizontal: true,
          ),
        );
        final mirrored = [
          for (var y = 0; y < h; y++)
            for (var x = 0; x < w; x++) expected[y * w + w - 1 - x],
        ];
        expect(await colors(tester, flipped!.bytes), mirrored);
        final crop = await tester.runAsync(
          () => exportHyperImagePng(
            image,
            cropRect: const Rect.fromLTWH(1, 0, 1, 1),
            quarterTurns: q,
            flipHorizontal: true,
          ),
        );
        expect(await colors(tester, crop!.bytes), [mirrored[1]]);
      }
      image.dispose();
    },
  );
  testWidgets(
    'preview controller and keyboard paging reset exited image transforms',
    (tester) async {
      final image = await source(tester),
          controller = HyperImagePreviewController();
      final bytes = await png(tester, image);
      image.dispose();
      final items = [
        for (var i = 0; i < 3; i++)
          HyperImagePreviewItem(
            image: MemoryImage(bytes),
            semanticLabel: 'image $i',
          ),
      ];
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(items: items, controller: controller),
          ),
        ),
      );
      await decoded(tester);
      controller.zoomIn();
      await tester.pump();
      expect(controller.scale, 1.5);
      for (var i = 0; i < 8; i++) {
        controller.zoomIn();
      }
      await tester.pump();
      expect(controller.scale, 5);
      expect(
        tester
            .widget<ExtendedImageGesturePageView>(
              find.byType(ExtendedImageGesturePageView),
            )
            .canScrollPage(null),
        isTrue,
      );
      controller.next();
      await tester.pump();
      expect(controller.index, 1);
      expect(controller.scale, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(controller.index, 2);
      controller.next();
      await tester.pump();
      expect(controller.index, 2);
      controller.jumpTo(0);
      await tester.pump();
      expect(controller.scale, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit0);
      await tester.pump();
      expect(controller.scale, 1);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'editor rotation, undo, redo, crop ratio, reset and exported pixels',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImageEditorController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 500,
            height: 400,
            child: HyperImageEditor(bytes: bytes, controller: controller),
          ),
        ),
      );
      await decoded(tester);
      expect(controller.ready, isTrue);
      final initial = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(initial!.width, 3);
      expect(initial.height, 2);
      controller.rotateClockwise();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      final rotated = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(rotated!.width, 2);
      expect(rotated.height, 3);
      expect(
        await colors(tester, rotated.bytes),
        [
          Colors.yellow,
          Colors.red,
          Colors.cyan,
          Colors.green,
          const Color(0xffff00ff),
          Colors.blue,
        ].map((c) => c.toARGB32()).toList(),
      );
      expect(controller.canUndo, isTrue);
      controller.undo();
      await tester.pump();
      expect(controller.canRedo, isTrue);
      controller.redo();
      await tester.pump();
      controller.reset();
      await tester.pump();
      controller.setCropAspectRatio(1);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(controller.cropAspectRatio, 1);
      final cropped = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(cropped!.width, cropped.height);
      await tester.pumpWidget(const SizedBox());
      expect(controller.ready, isFalse);
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('narrow image tools remain usable at text scale $scale', (
      tester,
    ) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 180,
            height: 260,
            child: HyperImagePreview(
              items: [HyperImagePreviewItem(image: MemoryImage(bytes))],
            ),
          ),
          scale: scale,
        ),
      );
      await decoded(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 180,
            height: 260,
            child: HyperImageEditor(bytes: bytes),
          ),
          scale: scale,
        ),
      );
      await decoded(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets(
    'dialog helpers keep shared surfaces and return editor cancellation',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showHyperImagePreview(
                context: context,
                items: [HyperImagePreviewItem(image: MemoryImage(bytes))],
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await decoded(tester);
      expect(find.byType(HyperDialog), findsOneWidget);
      expect(find.byType(HyperImagePreview), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is HyperIconButton && w.tooltip == '关闭预览',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HyperDialog), findsNothing);
      HyperImageEditResult? result;
      bool closed = false;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showHyperImageEditor(
                  context: context,
                  bytes: bytes,
                );
                closed = true;
              },
              child: const Text('edit'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('edit'));
      await decoded(tester);
      expect(find.byType(HyperImageEditor), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is HyperIconButton && w.tooltip == '取消编辑',
        ),
      );
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(result, isNull);
    },
  );
  testWidgets(
    'editor horizontal and vertical flip export match the visible transform',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImageEditorController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 500,
            height: 400,
            child: HyperImageEditor(bytes: bytes, controller: controller),
          ),
        ),
      );
      await decoded(tester);
      controller.flipHorizontal();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      var result = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(
        await colors(tester, result!.bytes),
        [
          Colors.blue,
          Colors.green,
          Colors.red,
          const Color(0xffff00ff),
          Colors.cyan,
          Colors.yellow,
        ].map((c) => c.toARGB32()).toList(),
      );
      controller.reset();
      await tester.pump();
      controller.flipVertical();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      result = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(
        await colors(tester, result!.bytes),
        [
          Colors.yellow,
          Colors.cyan,
          const Color(0xffff00ff),
          Colors.red,
          Colors.green,
          Colors.blue,
        ].map((c) => c.toARGB32()).toList(),
      );
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'preview pans within zoomed bounds and list shrink clamps index',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImagePreviewController();
      final items = [
        for (var i = 0; i < 3; i++)
          HyperImagePreviewItem(
            image: MemoryImage(bytes),
            semanticLabel: 'photo $i',
          ),
      ];
      Widget preview(List<HyperImagePreviewItem> items) => host(
        SizedBox(
          width: 360,
          height: 320,
          child: HyperImagePreview(items: items, controller: controller),
        ),
      );
      await tester.pumpWidget(preview(items));
      await decoded(tester);
      await tester.fling(
        find.byType(ExtendedImageGesturePageView),
        const Offset(-300, 0),
        1000,
      );
      await tester.pumpAndSettle();
      expect(controller.index, 1);
      controller.zoomIn();
      await tester.pump();
      await tester.drag(
        find
            .byWidgetPredicate((widget) => widget is ExtendedImageGesture)
            .first,
        const Offset(-30, 0),
      );
      await tester.pumpAndSettle();
      expect(controller.index, 1);
      controller.jumpTo(2);
      await tester.pump();
      await tester.pumpWidget(preview([items.first]));
      await tester.pump();
      expect(controller.index, 0);
      expect(controller.scale, 1);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'tool themes merge fields and preserve explicit surface disabling',
    (tester) async {
      final image = await source(tester);
      image.dispose();
      final theme = HyperThemeData.light().copyWith(
        imagePreviewTheme: const HyperImagePreviewThemeData(
          style: HyperImagePreviewStyle(
            spacing: 13,
            textStyle: TextStyle(fontSize: 19, color: Colors.red),
          ),
        ),
        imageEditorTheme: const HyperImageEditorThemeData(
          style: HyperImageEditorStyle(cropColor: Colors.green),
        ),
      );
      HyperImagePreviewStyle? preview;
      HyperImageEditorStyle? editor;
      await tester.pumpWidget(
        host(
          HyperImagePreviewTheme(
            data: const HyperImagePreviewThemeData(
              style: HyperImagePreviewStyle(
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            child: HyperImageEditorTheme(
              data: const HyperImageEditorThemeData(
                style: HyperImageEditorStyle(maskColor: Colors.orange),
              ),
              child: Builder(
                builder: (context) {
                  preview = resolveHyperImagePreviewStyle(
                    context,
                    HyperImagePreviewStyle(
                      surfaceStyle: HyperCardStyle(
                        boxShadow: const [],
                        border: const Border(),
                      ),
                    ),
                  );
                  editor = resolveHyperImageEditorStyle(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
          theme: theme,
        ),
      );
      expect(preview!.textStyle!.fontSize, 19);
      expect(preview!.textStyle!.color, Colors.red);
      expect(preview!.textStyle!.fontWeight, FontWeight.w600);
      expect(preview!.spacing, 13);
      expect(preview!.surfaceStyle!.boxShadow, isEmpty);
      expect(editor!.cropColor, Colors.green);
      expect(editor!.maskColor, Colors.orange);
      for (final device in HyperDeviceType.values) {
        final s = theme.sizes.resolve(device);
        expect(s.imagePreview.iconSize, s.image.iconSize);
        expect(s.imageEditor.handleHitSize, s.minimumInteractiveDimension);
        final changed = s.copyWith(
          imagePreview: s.imagePreview.copyWith(spacing: 21),
          imageEditor: s.imageEditor.copyWith(lineWidth: 7),
        );
        expect(HyperSizeScheme.lerp(s, changed, 1), changed);
      }
      expect(
        const HyperImagePreviewStyle().copyWith(),
        const HyperImagePreviewStyle(),
      );
      expect(
        const HyperImageEditorStyle().copyWith(),
        const HyperImageEditorStyle(),
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'editor export snapshots survive disposal and reject duplicate export',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImageEditorController();
      var callbacks = 0;
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 500,
            height: 400,
            child: HyperImageEditor(
              bytes: bytes,
              controller: controller,
              onExport: (_) => callbacks++,
            ),
          ),
        ),
      );
      await decoded(tester);
      final pending = controller.exportPng();
      expect(controller.exporting, isTrue);
      await expectLater(controller.exportPng(), throwsStateError);
      await tester.pumpWidget(const SizedBox());
      final result = await tester.runAsync(() => pending);
      expect(result!.width, 3);
      expect(result.height, 2);
      expect(callbacks, 0);
      expect(controller.ready, isFalse);
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'editor disables export during animated transforms and honors reduced motion',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImageEditorController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 500,
            height: 400,
            child: HyperImageEditor(bytes: bytes, controller: controller),
          ),
          reduced: false,
        ),
      );
      await decoded(tester);
      controller.rotateClockwise();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 30));
      expect(controller.ready, isFalse);
      await expectLater(controller.exportPng(), throwsStateError);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(controller.ready, isTrue);
      final result = await tester.runAsync(controller.exportPng);
      await tester.pump();
      expect(result!.width, 2);
      expect(result.height, 3);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'loading and failed preview controls never enter the image zoom layer',
    (tester) async {
      final provider = _PreviewProvider(),
          controller = HyperImagePreviewController();
      final image = await source(tester);
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(
              items: [HyperImagePreviewItem(image: provider)],
              controller: controller,
            ),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
        findsNothing,
      );
      controller.zoomIn();
      await tester.sendKeyEvent(LogicalKeyboardKey.equal);
      await tester.pump();
      expect(controller.scale, 1);
      HyperIconButton tool(String name) => tester.widget<HyperIconButton>(
        find.byWidgetPredicate(
          (widget) => widget is HyperIconButton && widget.tooltip == name,
        ),
      );
      expect(tool('放大').onPressed, isNull);
      expect(tool('重置缩放').onPressed, isNull);
      provider.attempts.last.fail();
      await tester.pump();
      await tester.pump();
      expect(find.text('图片加载失败'), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
        findsNothing,
      );
      final buttonSize = tester.getSize(find.text('重试'));
      controller.zoomIn();
      controller.zoomIn();
      await tester.sendKeyEvent(LogicalKeyboardKey.equal);
      await tester.pump();
      expect(controller.scale, 1);
      expect(tester.getSize(find.text('重试')), buttonSize);
      for (final element in find.text('重试').evaluate()) {
        element.visitAncestorElements((ancestor) {
          expect(ancestor.widget, isNot(isA<ExtendedImageGesture>()));
          return true;
        });
      }
      await tester.tap(find.text('重试'));
      await tester.pump();
      expect(provider.attempts, hasLength(2));
      expect(
        find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
        findsNothing,
      );
      provider.attempts.last.succeed(image);
      await tester.pump();
      await tester.pump();
      expect(
        find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
        findsOneWidget,
      );
      expect(tool('放大').onPressed, isNotNull);
      controller.zoomIn();
      await tester.pump();
      expect(controller.scale, 1.5);
      // Losing the image after success also removes zoom from the failed content.
      provider.attempts.last.fail();
      await tester.pump();
      await tester.pump();
      expect(controller.scale, 1);
      expect(
        find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
        findsNothing,
      );
      expect(tool('放大').onPressed, isNull);
      expect(tester.getSize(find.text('重试')), buttonSize);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      image.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'native paging recovers from vertical lead without a new pointer gesture',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImagePreviewController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(
              controller: controller,
              items: [
                for (var i = 0; i < 2; i++)
                  HyperImagePreviewItem(image: MemoryImage(bytes)),
              ],
            ),
          ),
        ),
      );
      await decoded(tester);
      final viewport = tester.getRect(
        find.byType(ExtendedImageGesturePageView),
      );
      final gesture = await tester.startGesture(viewport.center);
      await gesture.moveBy(const Offset(-3, 45));
      await tester.pump(const Duration(milliseconds: 40));
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(-25, 0));
        await tester.pump(const Duration(milliseconds: 35));
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(controller.index, 1);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets(
    'native pinch zooms the image without rebuilding gallery or toolbar during pan',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImagePreviewController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(
              controller: controller,
              items: [
                for (var i = 0; i < 2; i++)
                  HyperImagePreviewItem(image: MemoryImage(bytes)),
              ],
            ),
          ),
        ),
      );
      await decoded(tester);
      final gallery = tester.widget<ExtendedImageGesturePageView>(
        find.byType(ExtendedImageGesturePageView),
      );
      final rect = tester.getRect(find.byType(ExtendedImageGesturePageView));
      final first = await tester.startGesture(
        rect.center - const Offset(35, 0),
        pointer: 1,
      );
      final second = await tester.startGesture(
        rect.center + const Offset(35, 0),
        pointer: 2,
      );
      for (var i = 0; i < 5; i++) {
        await first.moveBy(const Offset(-10, 0));
        await second.moveBy(const Offset(10, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await first.up();
      await second.up();
      await tester.pumpAndSettle();
      expect(controller.scale, greaterThan(1));
      expect(controller.index, 0);
      expect(
        identical(
          tester.widget<ExtendedImageGesturePageView>(
            find.byType(ExtendedImageGesturePageView),
          ),
          gallery,
        ),
        isTrue,
      );
      final toolbarBefore = tester.widget<HyperIconButton>(
        find.byWidgetPredicate(
          (widget) => widget is HyperIconButton && widget.tooltip == '放大',
        ),
      );
      var notifications = 0;
      void onNotify() => notifications++;
      controller.addListener(onNotify);
      await tester.drag(
        find.byType(ExtendedImageGesturePageView),
        const Offset(-30, 15),
      );
      await tester.pumpAndSettle();
      expect(notifications, 0);
      expect(controller.index, 0);
      expect(
        identical(
          tester.widget<HyperIconButton>(
            find.byWidgetPredicate(
              (widget) => widget is HyperIconButton && widget.tooltip == '放大',
            ),
          ),
          toolbarBefore,
        ),
        isTrue,
      );
      controller.removeListener(onNotify);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('small diagonal swipe pages on the native gesture path', (
    tester,
  ) async {
    final image = await source(tester);
    final bytes = await png(tester, image);
    image.dispose();
    final controller = HyperImagePreviewController();
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 360,
          height: 320,
          child: HyperImagePreview(
            controller: controller,
            items: [
              for (var i = 0; i < 2; i++)
                HyperImagePreviewItem(image: MemoryImage(bytes)),
            ],
          ),
        ),
      ),
    );
    await decoded(tester);
    final rect = tester.getRect(find.byType(ExtendedImageGesturePageView));
    final gesture = await tester.startGesture(rect.center);
    await gesture.moveBy(const Offset(-3, 12));
    await tester.pump(const Duration(milliseconds: 30));
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(-25, 1));
      await tester.pump(const Duration(milliseconds: 30));
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(controller.index, 1);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets(
    'native zoomed edge drag hands off to paging and returning resets image',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImagePreviewController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(
              controller: controller,
              items: [
                for (var i = 0; i < 2; i++)
                  HyperImagePreviewItem(image: MemoryImage(bytes)),
              ],
            ),
          ),
        ),
      );
      await decoded(tester);
      controller.zoomIn();
      controller.zoomIn();
      await tester.pump();
      expect(controller.scale, 2.25);
      final rect = tester.getRect(find.byType(ExtendedImageGesturePageView));
      final gesture = await tester.startGesture(rect.center);
      for (var i = 0; i < 22; i++) {
        await gesture.moveBy(const Offset(-25, 0));
        await tester.pump(const Duration(milliseconds: 25));
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(controller.index, 1);
      expect(controller.scale, 1);
      controller.zoomIn();
      controller.zoomIn();
      await tester.pump();
      final reverse = await tester.startGesture(rect.center);
      for (var i = 0; i < 22; i++) {
        await reverse.moveBy(const Offset(25, 0));
        await tester.pump(const Duration(milliseconds: 25));
      }
      await reverse.up();
      await tester.pumpAndSettle();
      expect(controller.index, 0);
      expect(controller.scale, 1);
      final current = tester
          .stateList<ExtendedImageGestureState>(
            find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
          )
          .first;
      expect(current.gestureDetails!.totalScale, 1);
      expect(current.gestureDetails!.offset, Offset.zero);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  for (final kind in [ui.PointerDeviceKind.touch, ui.PointerDeviceKind.mouse]) {
    testWidgets(
      'immediate consecutive page drags remain responsive for $kind',
      (tester) async {
        final image = await source(tester);
        final bytes = await png(tester, image);
        image.dispose();
        final controller = HyperImagePreviewController();
        await tester.pumpWidget(
          host(
            SizedBox(
              width: 360,
              height: 320,
              child: HyperImagePreview(
                controller: controller,
                items: [
                  for (var i = 0; i < 4; i++)
                    HyperImagePreviewItem(image: MemoryImage(bytes)),
                ],
              ),
            ),
            reduced: false,
          ),
        );
        await decoded(tester);
        final viewport = find.byType(ExtendedImageGesturePageView);
        final rect = tester.getRect(viewport);
        Future<void> swipe() async {
          final pointer = await tester.startGesture(
            rect.center + const Offset(80, 0),
            kind: kind,
          );
          for (var i = 0; i < 8; i++) {
            await pointer.moveBy(const Offset(-30, 0));
            await tester.pump(const Duration(milliseconds: 16));
          }
          await pointer.up();
        }

        await swipe();
        final pages = tester
            .widget<ExtendedImageGesturePageView>(viewport)
            .controller;
        for (var i = 0; i < 90 && ((pages.page ?? 0) - 1).abs() > .002; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
        expect(controller.index, 1);
        // Start again as soon as the page is visually at rest, without settling all
        // animation ticks or waiting for a quiet-period timeout.
        await swipe();
        await tester.pumpAndSettle();
        expect(controller.index, 2);
        await swipe();
        await tester.pumpAndSettle();
        expect(controller.index, 3);
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'zoomed visible image wins drag even with a preloaded next page',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImagePreviewController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(
              controller: controller,
              items: [
                for (var i = 0; i < 3; i++)
                  HyperImagePreviewItem(image: MemoryImage(bytes)),
              ],
            ),
          ),
        ),
      );
      await decoded(tester);
      controller.zoomIn();
      controller.zoomIn();
      await tester.pump();
      final viewport = find.byType(ExtendedImageGesturePageView);
      final rect = tester.getRect(viewport);
      final gallery = tester.state<ExtendedImageGesturePageViewState>(viewport);
      final images = tester
          .stateList<ExtendedImageGestureState>(
            find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
          )
          .toList();
      final zoomed = images.singleWhere(
        (state) => (state.gestureDetails?.totalScale ?? 1) > 1,
      );
      final offset = zoomed.gestureDetails!.offset!;
      final pointer = await tester.startGesture(rect.center);
      for (var i = 0; i < 5; i++) {
        await pointer.moveBy(const Offset(-15, 0));
        await tester.pump(const Duration(milliseconds: 30));
      }
      expect(gallery.pageController.page, closeTo(0, .001));
      expect(zoomed.gestureDetails!.offset!.dx, lessThan(offset.dx));
      await pointer.up();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'wheel zoom uses local image focus and dragging follows the pointer',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final controller = HyperImagePreviewController();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 360,
            height: 320,
            child: HyperImagePreview(
              controller: controller,
              items: [
                for (var i = 0; i < 2; i++)
                  HyperImagePreviewItem(image: MemoryImage(bytes)),
              ],
            ),
          ),
        ),
      );
      await decoded(tester);
      final viewport = find.byType(ExtendedImageGesturePageView);
      final rect = tester.getRect(viewport);
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: rect.center,
          scrollDelta: const Offset(0, -1000),
          kind: ui.PointerDeviceKind.mouse,
        ),
      );
      await tester.pump();
      expect(controller.scale, 2);
      final current = tester
          .stateList<ExtendedImageGestureState>(
            find.byWidgetPredicate((widget) => widget is ExtendedImageGesture),
          )
          .singleWhere((state) => (state.gestureDetails?.totalScale ?? 1) > 1);
      expect(
        current.gestureDetails!.destinationRect!.center.dx,
        closeTo(current.gestureDetails!.layoutRect!.center.dx, .01),
      );
      final before = current.gestureDetails!.offset!.dx;
      final drag = await tester.startGesture(rect.center);
      for (var i = 0; i < 8; i++) {
        await drag.moveBy(const Offset(8, 0));
        await tester.pump(const Duration(milliseconds: 25));
      }
      await drag.up();
      await tester.pumpAndSettle();
      expect(controller.index, 0);
      expect(current.gestureDetails!.offset!.dx, greaterThan(before));
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: rect.center,
          scrollDelta: const Offset(0, 250),
          kind: ui.PointerDeviceKind.mouse,
        ),
      );
      await tester.pump();
      expect(controller.scale, lessThan(2));
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('default preview dialog uses one advanced backdrop surface', (
    tester,
  ) async {
    final image = await source(tester);
    final bytes = await png(tester, image);
    image.dispose();
    final theme = HyperThemeData.light().copyWith(
      materialTheme: const HyperMaterialThemeData(
        quality: HyperMaterialQuality.advanced,
        material: HyperSurfaceMaterial.frostedGlass(),
      ),
    );
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showHyperImagePreview(
              context: context,
              items: [
                for (var i = 0; i < 3; i++)
                  HyperImagePreviewItem(image: MemoryImage(bytes)),
              ],
            ),
            child: const Text('open material preview'),
          ),
        ),
        theme: theme,
      ),
    );
    await tester.tap(find.text('open material preview'));
    await decoded(tester);
    final filters = tester
        .widgetList<BackdropFilter>(
          find.descendant(
            of: find.byType(HyperDialog),
            matching: find.byType(BackdropFilter),
          ),
        )
        .where((filter) => filter.enabled);
    expect(filters, hasLength(1));
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'explicit preview surfaces and dialog shadow overrides remain effective',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      final theme = HyperThemeData.light().copyWith(
        materialTheme: const HyperMaterialThemeData(
          quality: HyperMaterialQuality.advanced,
          material: HyperSurfaceMaterial.frostedGlass(),
        ),
      );
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showHyperImagePreview(
                context: context,
                items: [HyperImagePreviewItem(image: MemoryImage(bytes))],
                style: HyperImagePreviewStyle(
                  surfaceStyle: HyperCardStyle(
                    material: const HyperSurfaceMaterial.frostedGlass(),
                    boxShadow: const [],
                  ),
                ),
                dialogStyle: const HyperDialogStyle(boxShadow: []),
              ),
              child: const Text('open explicit surface'),
            ),
          ),
          theme: theme,
        ),
      );
      await tester.tap(find.text('open explicit surface'));
      await decoded(tester);
      expect(
        tester
            .widget<HyperImagePreview>(find.byType(HyperImagePreview))
            .showSurface,
        isTrue,
      );
      final filters = tester
          .widgetList<BackdropFilter>(
            find.descendant(
              of: find.byType(HyperDialog),
              matching: find.byType(BackdropFilter),
            ),
          )
          .where((filter) => filter.enabled);
      expect(filters, hasLength(2));
      final surfaces = tester.widgetList<HyperMaterialSurface>(
        find.descendant(
          of: find.byType(HyperDialog),
          matching: find.byType(HyperMaterialSurface),
        ),
      );
      expect(
        surfaces.every((surface) => surface.boxShadow?.isEmpty ?? false),
        isTrue,
      );
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('explicit image material remains local within a default dialog', (
    tester,
  ) async {
    final image = await source(tester);
    final bytes = await png(tester, image);
    image.dispose();
    final theme = HyperThemeData.light().copyWith(
      materialTheme: const HyperMaterialThemeData(
        quality: HyperMaterialQuality.advanced,
        material: HyperSurfaceMaterial.frostedGlass(),
      ),
    );
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showHyperImagePreview(
              context: context,
              items: [HyperImagePreviewItem(image: MemoryImage(bytes))],
              style: HyperImagePreviewStyle(
                imageStyle: HyperImageStyle(
                  surfaceStyle: HyperCardStyle(
                    material: const HyperSurfaceMaterial.frostedGlass(),
                    boxShadow: const [],
                  ),
                ),
              ),
            ),
            child: const Text('open image material'),
          ),
        ),
        theme: theme,
      ),
    );
    await tester.tap(find.text('open image material'));
    await decoded(tester);
    expect(
      tester
          .widget<HyperImagePreview>(find.byType(HyperImagePreview))
          .showSurface,
      isFalse,
    );
    final filters = tester
        .widgetList<BackdropFilter>(
          find.descendant(
            of: find.byType(HyperDialog),
            matching: find.byType(BackdropFilter),
          ),
        )
        .where((filter) => filter.enabled);
    expect(filters, hasLength(2));
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'free crop horizontal mouse overshoot never changes vertical extent',
    (tester) async {
      final image = await source(tester);
      final bytes = await png(tester, image);
      image.dispose();
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 500,
            height: 500,
            child: HyperImageEditor(bytes: bytes),
          ),
        ),
      );
      await decoded(tester);
      final layerFinder = find.byType(ExtendedImageCropLayer);
      final initial = tester
          .widget<ExtendedImageCropLayer>(layerFinder)
          .editActionDetails
          .cropRect!;
      final origin = tester.getTopLeft(layerFinder);
      final drag = await tester.startGesture(
        origin + initial.centerRight,
        kind: ui.PointerDeviceKind.mouse,
      );
      for (var i = 0; i < 20; i++) {
        await drag.moveBy(const Offset(15, 0));
        await tester.pump(const Duration(milliseconds: 16));
        final crop = tester
            .widget<ExtendedImageCropLayer>(layerFinder)
            .editActionDetails
            .cropRect!;
        expect(crop.top, closeTo(initial.top, .001));
        expect(crop.height, closeTo(initial.height, .001));
      }
      await drag.up();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
