import 'dart:ui' as ui;

import 'package:lemon_ui/src/vendor/extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/surface/hyper_navigation_surface.dart';

class _Stream extends ImageStreamCompleter {
  void progress(int loaded, int? total) => reportImageChunkEvent(
    ImageChunkEvent(cumulativeBytesLoaded: loaded, expectedTotalBytes: total),
  );
  void fail() => reportError(
    exception: StateError('test image failed'),
    context: ErrorDescription('loading test image'),
    silent: true,
  );
  void succeed(ui.Image image) => setImage(ImageInfo(image: image.clone()));
}

class _Provider extends ImageProvider<_Provider> {
  final attempts = <_Stream>[];
  @override
  Future<_Provider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);
  @override
  ImageStreamCompleter loadImage(_Provider key, ImageDecoderCallback decode) {
    final stream = _Stream();
    attempts.add(stream);
    return stream;
  }
}

Widget host(
  Widget child, {
  HyperThemeData? theme,
  double scale = 1,
  bool reduced = false,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(scale),
        disableAnimations: reduced,
      ),
      child: Scaffold(
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  ),
);
Future<ui.Image> sample(WidgetTester tester) async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawColor(Colors.blue, BlendMode.src);
  final picture = recorder.endRecording();
  final image = await tester.runAsync(() => picture.toImage(20, 10));
  picture.dispose();
  return image!;
}

void main() {
  test('empty style copies preserve equality and nullable inheritance', () {
    const base = HyperImageStyle();
    expect(base.copyWith(), base);
    expect(base.copyWith().surfaceStyle, isNull);
    expect(base.merge(const HyperImageStyle()), base);
    expect(base.copyWith().hashCode, base.hashCode);
  });

  testWidgets(
    'default loading, determinate progress, failure, retry and success keep geometry',
    (tester) async {
      final provider = _Provider();
      final image = await sample(tester);
      await tester.pumpWidget(
        host(
          HyperImage(
            image: provider,
            width: 200,
            height: 160,
            semanticLabel: 'photo',
          ),
        ),
      );
      expect(find.byType(HyperProgress), findsOneWidget);
      expect(
        tester.widget<HyperProgress>(find.byType(HyperProgress)).value,
        isNull,
      );
      final before = tester.getSize(find.byType(HyperImage));
      provider.attempts.last.progress(40, 100);
      await tester.pump();
      expect(
        tester.widget<HyperProgress>(find.byType(HyperProgress)).value,
        .4,
      );
      provider.attempts.last.fail();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('图片加载失败'), findsOneWidget);
      expect(find.text('重试'), findsOneWidget);
      expect(tester.getSize(find.byType(HyperImage)), before);
      await tester.tap(find.text('重试'));
      await tester.pump();
      expect(provider.attempts, hasLength(2));
      expect(find.byType(HyperProgress), findsOneWidget);
      provider.attempts.last.succeed(image);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('图片加载失败'), findsNothing);
      expect(find.byType(HyperProgress), findsNothing);
      expect(tester.getSize(find.byType(HyperImage)), before);
      expect(find.bySemanticsLabel('photo'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      image.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'narrow failed image scrolls without clipping text scale $scale',
      (tester) async {
        final provider = _Provider();
        await tester.pumpWidget(
          host(
            HyperImage(image: provider, width: 90, height: 70),
            scale: scale,
          ),
        );
        provider.attempts.last.fail();
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('图片加载失败'), findsOneWidget);
        await tester.ensureVisible(find.text('重试'));
        await tester.pump();
        await tester.tap(find.text('重试'));
        await tester.pump();
        expect(provider.attempts, hasLength(2));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
  testWidgets('builders replace defaults and receive functional retry', (
    tester,
  ) async {
    final provider = _Provider();
    await tester.pumpWidget(
      host(
        HyperImage(
          image: provider,
          width: 200,
          height: 160,
          loadingBuilder: (context, progress) => const Text('custom loading'),
          errorBuilder: (context, error, retry) =>
              TextButton(onPressed: retry, child: const Text('custom retry')),
        ),
      ),
    );
    expect(find.text('custom loading'), findsOneWidget);
    provider.attempts.last.fail();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('custom retry'));
    await tester.pump();
    expect(provider.attempts, hasLength(2));
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'partial global, local, variant/state and instance themes compose',
    (tester) async {
      final provider = _Provider();
      final theme = HyperThemeData.light().copyWith(
        imageTheme: const HyperImageThemeData(
          appearance: HyperImageAppearance(
            style: HyperImageStyle(
              iconColor: Colors.green,
              textStyle: TextStyle(fontSize: 19),
            ),
          ),
          outlined: HyperImageAppearance(
            failed: HyperImageStyle(
              failureText: 'failed outlined',
              textStyle: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        host(
          HyperImageTheme(
            data: const HyperImageThemeData(
              appearance: HyperImageAppearance(
                style: HyperImageStyle(
                  failureText: 'local',
                  retryText: 'reload',
                ),
              ),
            ),
            child: HyperImage(
              image: provider,
              width: 200,
              height: 160,
              variant: HyperImageVariant.outlined,
              style: const HyperImageStyle(iconColor: Colors.orange),
            ),
          ),
          theme: theme,
        ),
      );
      provider.attempts.last.fail();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      final text = tester.widget<Text>(find.text('failed outlined'));
      expect(text.style!.fontSize, 19);
      expect(text.style!.color, Colors.red);
      expect(find.text('reload'), findsOneWidget);
      expect(
        tester.widget<HyperIcon>(find.byType(HyperIcon).first).color,
        Colors.orange,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'explicit empty shadow and no border override elevated appearance',
    (tester) async {
      final provider = _Provider();
      await tester.pumpWidget(
        host(
          HyperImage(
            image: provider,
            width: 200,
            height: 160,
            variant: HyperImageVariant.elevated,
            style: HyperImageStyle(
              surfaceStyle: HyperCardStyle(
                boxShadow: const [],
                border: const Border(),
              ),
            ),
          ),
        ),
      );
      final surface = tester.widget<HyperNavigationSurface>(
        find.byType(HyperNavigationSurface),
      );
      expect(surface.style.boxShadow, isEmpty);
      expect(surface.style.border, const Border());
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'advanced backdrop never has status fade ancestors; reduced motion disables switch',
    (tester) async {
      final provider = _Provider();
      final theme = HyperThemeData.light().copyWith(
        materialTheme: const HyperMaterialThemeData(
          quality: HyperMaterialQuality.advanced,
          material: HyperSurfaceMaterial.frostedGlass(),
        ),
      );
      await tester.pumpWidget(
        host(
          HyperImage(image: provider, width: 200, height: 160),
          theme: theme,
        ),
      );
      provider.attempts.last.fail();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      for (final e in find.byType(BackdropFilter).evaluate()) {
        e.visitAncestorElements((ancestor) {
          if (ancestor.widget is HyperImage) return false;
          expect(ancestor.widget, isNot(isA<FadeTransition>()));
          expect(ancestor.widget, isNot(isA<Opacity>()));
          return true;
        });
      }
      await tester.pumpWidget(
        host(
          HyperImage(image: provider, width: 200, height: 160),
          theme: theme,
          reduced: true,
        ),
      );
      expect(
        tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher)).duration,
        Duration.zero,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
  test(
    'network request configuration and decode size remain separate from style',
    () {
      final widget = HyperImage.network(
        'https://example.com/test.png',
        cache: false,
        retries: 2,
        timeout: const Duration(seconds: 5),
        cacheWidth: 80,
        headers: const {'X-Test': 'value'},
      );
      final provider = widget.image as ExtendedNetworkImageProvider;
      expect(provider.cache, false);
      expect(provider.retries, 2);
      expect(provider.timeLimit, const Duration(seconds: 5));
      expect(provider.headers!['X-Test'], 'value');
      expect(widget.cacheWidth, 80);
    },
  );
  test(
    'theme and per-device sizes support copy, equality and interpolation',
    () {
      final base = HyperThemeData.light();
      for (final device in HyperDeviceType.values) {
        final s = base.sizes.resolve(device);
        expect(s.image.iconSize, s.iconSize);
        expect(s.image.progressSize, s.progress.circularSize);
        final next = s.copyWith(image: s.image.copyWith(spacing: 18));
        expect(next, s.copyWith(image: s.image.copyWith(spacing: 18)));
        expect(
          next.hashCode,
          s.copyWith(image: s.image.copyWith(spacing: 18)).hashCode,
        );
        expect(
          HyperSizeScheme.lerp(s, next, .5).image.spacing,
          (s.image.spacing + 18) / 2,
        );
      }
      final next = base.copyWith(
        imageTheme: const HyperImageThemeData(
          appearance: HyperImageAppearance(style: HyperImageStyle(spacing: 20)),
        ),
      );
      expect(base, isNot(next));
      expect(base.lerp(next, 1).imageTheme, next.imageTheme);
    },
  );
}
