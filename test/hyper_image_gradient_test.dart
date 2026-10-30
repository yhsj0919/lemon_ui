import 'dart:ui' as ui;
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

class _Stream extends ImageStreamCompleter {
  void succeed(ui.Image image) => setImage(ImageInfo(image: image.clone()));
  void fail() =>
      reportError(exception: StateError('unavailable'), silent: true);
}

class _Provider extends ImageProvider<_Provider> {
  final stream = _Stream();
  @override
  Future<_Provider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);
  @override
  ImageStreamCompleter loadImage(_Provider key, ImageDecoderCallback decode) =>
      stream;
}

class _RealHttp extends HttpOverrides {}

Future<ui.Image> picture(Color primary, {Color? secondary}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 8, 8), Paint()..color = primary);
  if (secondary != null) {
    canvas.drawRect(
      const Rect.fromLTWH(6, 0, 2, 8),
      Paint()..color = secondary,
    );
  }
  final drawing = recorder.endRecording();
  final image = await drawing.toImage(8, 8);
  drawing.dispose();
  return image;
}

Widget host(Widget child, {HyperThemeData? theme}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);
LinearGradient gradient(WidgetTester tester) =>
    tester
            .widget<HyperContainer>(find.byType(HyperContainer))
            .background!
            .gradient!
        as LinearGradient;

Future<void> waitForColor(WidgetTester tester, Completer<Color> ready) async {
  for (var attempt = 0; attempt < 100 && !ready.isCompleted; attempt++) {
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
  }
  expect(ready.isCompleted, isTrue);
}

void main() {
  test(
    'image color strength supports theme overrides, clearing and interpolation',
    () {
      final light = HyperContainerThemeData(imageColorStrength: .2);
      final strong = light.copyWith(imageColorStrength: .6);
      expect(light.merge(strong).imageColorStrength, .6);
      expect(
        strong.copyWith(imageColorStrength: null).imageColorStrength,
        isNull,
      );
      expect(
        HyperContainerThemeData.lerp(light, strong, .5).imageColorStrength,
        closeTo(.4, 1e-9),
      );
      expect(strong.copyWith(), strong);
      expect(strong.copyWith().hashCode, strong.hashCode);
      expect(
        () => HyperContainerThemeData(imageColorStrength: 1.1),
        throwsArgumentError,
      );
      expect(
        () => HyperContainer.imageGradient(
          image: _Provider(),
          startColor: Colors.white,
          colorStrength: -.1,
        ),
        throwsArgumentError,
      );
    },
  );
  testWidgets(
    'white and black backgrounds yield to a representative colored region',
    (tester) async {
      await tester.runAsync(() async {
        for (final background in [
          Colors.white,
          Colors.black,
          const Color(0xFFF5F5F5),
          const Color(0xFF101010),
        ]) {
          final image = await picture(
            background,
            secondary: const Color(0xFF308CD2),
          );
          final provider = _Provider();
          final preferred = HyperImageColors.dominant(provider);
          provider.stream.succeed(image);
          expect(await preferred, const Color(0xFF308CD2));
          expect(
            await HyperImageColors.dominant(
              provider,
              avoidBlackAndWhite: false,
            ),
            Color(background.toARGB32()),
          );
          image.dispose();
        }
      });
    },
  );
  testWidgets(
    'black white and grayscale images retain usable fallback colors',
    (tester) async {
      await tester.runAsync(() async {
        for (final color in [
          Colors.white,
          Colors.black,
          const Color(0xFFF5F5F5),
          const Color(0xFF808080),
        ]) {
          final image = await picture(color);
          final provider = _Provider();
          final result = HyperImageColors.dominant(provider);
          provider.stream.succeed(image);
          expect(await result, Color(color.toARGB32()));
          image.dispose();
        }
      });
    },
  );
  testWidgets('network image links use the same extraction pipeline', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final image = await picture(const Color(0xFF308CD2));
      final png = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final bytes = png.buffer.asUint8List(
        png.offsetInBytes,
        png.lengthInBytes,
      );
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.headers.contentType = ContentType('image', 'png');
        request.response.add(bytes);
        await request.response.close();
      });
      try {
        final color = await HttpOverrides.runWithHttpOverrides(
          () => HyperImageColors.dominant(
            NetworkImage('http://127.0.0.1:${server.port}/image.png'),
          ),
          _RealHttp(),
        );
        expect(color, const Color(0xFF308CD2));
      } finally {
        image.dispose();
        await server.close(force: true);
      }
    });
  });
  testWidgets(
    'encoded local file and memory images use the same extraction path',
    (tester) async {
      await tester.runAsync(() async {
        final image = await picture(const Color(0xFF308CD2));
        final png = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        final bytes = png.buffer.asUint8List(
          png.offsetInBytes,
          png.lengthInBytes,
        );
        final file = File(
          '${Directory.systemTemp.path}/hyper-gradient-${DateTime.now().microsecondsSinceEpoch}.png',
        );
        try {
          await file.writeAsBytes(bytes);
          expect(
            await HyperImageColors.dominant(MemoryImage(bytes)),
            const Color(0xFF308CD2),
          );
          expect(
            await HyperImageColors.dominant(FileImage(file)),
            const Color(0xFF308CD2),
          );
        } finally {
          image.dispose();
          if (await file.exists()) await file.delete();
        }
      });
    },
  );
  test('gradient stops validate range, ordering and count', () {
    for (final stops in <List<double>>[
      [],
      [0],
      [0, .5, 1],
      [-.1, 1],
      [.8, .2],
      [0, double.nan],
    ]) {
      expect(
        () => HyperContainer.imageGradient(
          image: _Provider(),
          startColor: Colors.white,
          stops: stops,
        ),
        throwsArgumentError,
      );
    }
  });
  testWidgets('dominant chooses frequent visible color instead of an average', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final image = await picture(
        const Color(0xFFF44336),
        secondary: const Color(0xFF2196F3),
      );
      final provider = _Provider();
      final color = HyperImageColors.dominant(provider);
      provider.stream.succeed(image);
      expect(await color, const Color(0xFFF44336));
      image.dispose();
    });
  });
  testWidgets(
    'transparent pixels and alpha weighting do not bias colors toward black',
    (tester) async {
      await tester.runAsync(() async {
        for (final primary in [Colors.transparent, const Color(0x10FF0000)]) {
          final image = await picture(
            primary,
            secondary: const Color(0xFF2196F3),
          );
          final provider = _Provider();
          final color = HyperImageColors.dominant(provider);
          provider.stream.succeed(image);
          expect(await color, const Color(0xFF2196F3));
          image.dispose();
        }
        final transparent = await picture(Colors.transparent);
        final provider = _Provider();
        final color = HyperImageColors.dominant(provider);
        provider.stream.succeed(transparent);
        expect(await color, isNull);
        transparent.dispose();
      });
    },
  );
  testWidgets(
    'container inherits theme and supports independent direction and start color',
    (tester) async {
      final provider = _Provider();
      Color? extracted;
      var ready = Completer<Color>();
      late ColorScheme scheme;
      final theme = HyperThemeData.light().copyWith(
        containerTheme: HyperContainerThemeData(
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.all(8),
        ),
      );
      await tester.pumpWidget(
        host(
          HyperContainer.imageGradient(
            image: provider,
            startColor: Colors.white,
            width: 200,
            height: 100,
            animationDuration: Duration.zero,
            onColorExtracted: (color) {
              extracted = color;
              ready.complete(color);
            },
            child: const Text('content'),
          ),
          theme: theme,
        ),
      );
      expect(gradient(tester).colors, [Colors.white, Colors.white]);
      await tester.runAsync(() async {
        final image = await picture(const Color(0xFFF44336));
        provider.stream.succeed(image);
        scheme = await ColorScheme.fromImageProvider(provider: provider);
        image.dispose();
      });
      await waitForColor(tester, ready);
      await tester.pumpAndSettle();
      expect(extracted, scheme.primary);
      expect(gradient(tester).colors, [
        Colors.white,
        Color.lerp(Colors.white, scheme.primary, .2),
      ]);
      expect(gradient(tester).begin, Alignment.topCenter);
      expect(gradient(tester).end, Alignment.bottomCenter);
      expect(tester.getSize(find.byType(HyperContainer)), const Size(200, 100));
      final surface = tester.widget<HyperMaterialSurface>(
        find.byType(HyperMaterialSurface),
      );
      expect(surface.borderRadius, BorderRadius.circular(12));
      await tester.pumpWidget(
        host(
          HyperContainer.imageGradient(
            image: provider,
            startColor: Colors.white,
            animationDuration: Duration.zero,
            child: const Text('content'),
          ),
          theme: theme.copyWith(
            containerTheme: theme.containerTheme.copyWith(
              imageColorStrength: .6,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        gradient(tester).colors.last,
        Color.lerp(Colors.white, scheme.primary, .6),
      );
      ready = Completer<Color>();
      await tester.pumpWidget(
        host(
          HyperContainer.imageGradient(
            image: provider,
            startColor: const Color(0xFF4CAF50),
            colorRole: HyperImageColorRole.primaryContainer,
            colorStrength: 1,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [.2, .8],
            animationDuration: Duration.zero,
            onColorExtracted: ready.complete,
            child: const Text('content'),
          ),
          theme: theme,
        ),
      );
      await waitForColor(tester, ready);
      await tester.pumpAndSettle();
      expect(gradient(tester).begin, Alignment.centerLeft);
      expect(gradient(tester).end, Alignment.centerRight);
      expect(gradient(tester).stops, [.2, .8]);
      expect(gradient(tester).colors, [
        const Color(0xFF4CAF50),
        scheme.primaryContainer,
      ]);
    },
  );
  testWidgets(
    'image failures keep an explicit fallback without an uncaught error',
    (tester) async {
      final provider = _Provider();
      Object? failure;
      await tester.pumpWidget(
        host(
          HyperContainer.imageGradient(
            image: provider,
            startColor: Colors.white,
            fallbackColor: const Color(0xFF9E9E9E),
            onImageError: (error) => failure = error,
          ),
        ),
      );
      provider.stream.fail();
      await tester.pumpAndSettle();
      expect(gradient(tester).colors, [Colors.white, const Color(0xFF9E9E9E)]);
      expect(failure, isA<Exception>());
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'late colors from a replaced image cannot overwrite its replacement',
    (tester) async {
      final first = _Provider(), second = _Provider();
      final colors = <Color>[];
      final ready = Completer<Color>();
      late Color expected;
      Widget view(ImageProvider provider) => host(
        HyperContainer.imageGradient(
          image: provider,
          startColor: Colors.white,
          animationDuration: Duration.zero,
          onColorExtracted: (color) {
            colors.add(color);
            ready.complete(color);
          },
        ),
      );
      await tester.pumpWidget(view(first));
      await tester.pumpWidget(view(second));
      await tester.runAsync(() async {
        final red = await picture(const Color(0xFFF44336)),
            blue = await picture(const Color(0xFF2196F3));
        second.stream.succeed(blue);
        first.stream.succeed(red);
        expected = (await ColorScheme.fromImageProvider(provider: second))
            .primary;
        red.dispose();
        blue.dispose();
      });
      await waitForColor(tester, ready);
      await tester.pumpAndSettle();
      expect(gradient(tester).colors, [
        Colors.white,
        Color.lerp(Colors.white, expected, .2),
      ]);
      expect(colors, [expected]);
      expect(tester.takeException(), isNull);
    },
  );
}
