import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/painting/hyper_box_decoration.dart';
import 'package:lemon_ui/src/painting/hyper_surface_border.dart';
import 'package:lemon_ui/src/painting/hyper_dashed_border.dart';

Future<int> nonWhitePixels(Decoration decoration) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..drawColor(const Color(0xFFFFFFFF), BlendMode.src);
  final painter = decoration.createBoxPainter(() {});
  painter.paint(
    canvas,
    const Offset(10, 10),
    const ImageConfiguration(
      size: Size(40, 40),
      textDirection: TextDirection.ltr,
    ),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(60, 60);
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  var count = 0;
  for (var i = 0; i < bytes.lengthInBytes; i += 4) {
    if (bytes.getUint8(i) != 255 ||
        bytes.getUint8(i + 1) != 255 ||
        bytes.getUint8(i + 2) != 255) {
      count++;
    }
  }
  painter.dispose();
  image.dispose();
  picture.dispose();
  return count;
}

void main() {
  test(
    'Hyper surfaces suppress zero-width borders instead of drawing hairlines',
    () async {
      final zero = Border.all(color: const Color(0xFFFF0000), width: 0);
      expect(
        await nonWhitePixels(BoxDecoration(border: zero)),
        greaterThan(0),
        reason: 'Native Flutter border reproduces the hairline',
      );
      expect(await nonWhitePixels(HyperBoxDecoration(border: zero)), 0);
    },
  );
  test(
    'zero-width sides are disabled without changing positive or custom sides',
    () {
      const positive = BorderSide(color: Color(0xFF0000FF), width: .25);
      const zero = BorderSide(
        color: Color(0xFFFF0000),
        width: 0,
        strokeAlign: BorderSide.strokeAlignOutside,
      );
      final disabled = normalizeHyperBorderSide(zero);
      expect(disabled.style, BorderStyle.none);
      expect(disabled.color, zero.color);
      expect(disabled.strokeAlign, zero.strokeAlign);
      expect(identical(normalizeHyperBorderSide(positive), positive), isTrue);
      final mixed =
          normalizeHyperBoxBorder(const Border(top: zero, bottom: positive))!
              as Border;
      expect(mixed.top.style, BorderStyle.none);
      expect(mixed.bottom, positive);
      final directional =
          normalizeHyperBoxBorder(
                const BorderDirectional(start: zero, end: positive),
              )!
              as BorderDirectional;
      expect(directional.start.style, BorderStyle.none);
      expect(directional.end, positive);
      const custom = HyperDashedBorder();
      expect(identical(normalizeHyperBoxBorder(custom), custom), isTrue);
      expect(normalizeHyperBoxBorder(null), isNull);
      final shape = normalizeHyperShapeBorder(
        const CircleBorder(side: zero),
      ) as CircleBorder;
      expect(shape.side.style, BorderStyle.none);
    },
  );
  test('rounded, circular, directional and interpolated zero borders leave no pixels', () async {
    final zero = Border.all(color: const Color(0xFFFF0000), width: 0);
    for (final decoration in [
      HyperBoxDecoration(border: zero, borderRadius: BorderRadius.circular(8)),
      HyperBoxDecoration(border: zero, shape: BoxShape.circle),
      const HyperBoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: Color(0xFFFF0000), width: 0),
        ),
      ),
    ]) {
      expect(await nonWhitePixels(decoration), 0);
    }
    expect(
      await nonWhitePixels(
        ShapeDecoration(
          shape: normalizeHyperShapeBorder(
            const CircleBorder(
              side: BorderSide(color: Color(0xFFFF0000), width: 0),
            ),
          ),
        ),
      ),
      0,
    );
    expect(
      await nonWhitePixels(
        hyperSurfaceBorderDecoration(zero, BorderRadius.circular(8))!,
      ),
      0,
    );
    final a = HyperBoxDecoration(
      border: Border.all(color: const Color(0xFFFF0000), width: 2),
    );
    final b = HyperBoxDecoration(border: zero);
    expect(await nonWhitePixels(a.lerpTo(b, .5)!), greaterThan(0));
    expect(await nonWhitePixels(a.lerpTo(b, 1)!), 0);
    expect(
      await nonWhitePixels(HyperBoxDecoration(border: Border.all(width: .25))),
      greaterThan(0),
    );
    final mixed = HyperBoxDecoration(
      border: const Border(
        top: BorderSide(color: Color(0xFFFF0000), width: 0),
        bottom: BorderSide(color: Color(0xFF0000FF), width: 2),
      ),
      borderRadius: BorderRadius.circular(8),
    );
    final reference = hyperSurfaceBorderDecoration(
      const Border(bottom: BorderSide(color: Color(0xFF0000FF), width: 2)),
      BorderRadius.circular(8),
    )!;
    expect(await nonWhitePixels(mixed), await nonWhitePixels(reference));
  });
}
