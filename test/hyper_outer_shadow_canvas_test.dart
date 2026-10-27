import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/painting/hyper_box_decoration.dart';

void main() {
  test(
    'shadow clip excludes the surface without depending on canvas bounds',
    () {
      final canvas = _RecordingCanvas();
      final painter = HyperBoxDecoration(
        borderRadius: BorderRadius.circular(12),
        outerShadowsOnly: true,
        boxShadow: const [
          BoxShadow(color: Color(0xA0FF0000), blurRadius: 12, spreadRadius: 8),
          BoxShadow(offset: Offset(-30, 20), blurRadius: 6),
        ],
      ).createBoxPainter();
      painter.paint(
        canvas,
        const Offset(50, 50),
        const ImageConfiguration(
          size: Size(200, 100),
          textDirection: TextDirection.ltr,
        ),
      );
      final clip = canvas.clip!;
      expect(clip.contains(const Offset(150, 100)), isFalse);
      expect(clip.contains(const Offset(45, 100)), isTrue);
      expect(clip.contains(const Offset(25, 100)), isTrue);
      expect(clip.getBounds().width, lessThan(400));
      expect(clip.getBounds().height, lessThan(300));
      painter.dispose();
    },
  );
  test(
    'outer shadow excludes surface with an unbounded recording canvas',
    () async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawColor(const Color(0xFFFFFFFF), BlendMode.src);
      final painter = HyperBoxDecoration(
        borderRadius: BorderRadius.circular(12),
        outerShadowsOnly: true,
        boxShadow: const [
          BoxShadow(color: Color(0xA0FF0000), blurRadius: 12, spreadRadius: 8),
        ],
      ).createBoxPainter();
      painter.paint(
        canvas,
        const Offset(50, 50),
        const ImageConfiguration(
          size: Size(200, 100),
          textDirection: TextDirection.ltr,
        ),
      );
      final picture = recorder.endRecording();
      final image = await picture.toImage(300, 200);
      final data = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!;
      int green(int x, int y) => data.getUint8((y * image.width + x) * 4 + 1);
      expect(
        green(150, 100),
        255,
        reason: 'shadow must not paint over the center',
      );
      expect(green(65, 100), 255);
      expect(green(45, 100), lessThan(250));
      painter.dispose();
      image.dispose();
      picture.dispose();
    },
  );
}

class _RecordingCanvas implements Canvas {
  Path? clip;

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) => clip = path;

  @override
  Rect getLocalClipBounds() =>
      throw StateError('recording canvas has no finite clip bounds');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
