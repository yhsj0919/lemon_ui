import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import 'hyper_image_editor.dart';

// Operates on a decoded snapshot, avoiding another decode and EXIF mismatch.
Future<HyperImageEditResult> exportHyperImagePng(
  ui.Image source, {
  required Rect cropRect,
  int quarterTurns = 0,
  bool flipHorizontal = false,
}) async {
  final q = quarterTurns % 4;
  final width = q.isOdd ? source.height : source.width,
      height = q.isOdd ? source.width : source.height;
  if (!cropRect.isFinite || cropRect.isEmpty) {
    throw ArgumentError.value(cropRect, 'cropRect');
  }
  final clipped = cropRect.intersect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
  );
  if (clipped.isEmpty) {
    throw ArgumentError('Crop does not intersect the transformed image');
  }
  // Quantize extent separately from origin: rounding both edges outward would
  // distort a square selection by one pixel when its origin is fractional.
  final outWidth = clipped.width.round().clamp(1, width),
      outHeight = clipped.height.round().clamp(1, height);
  final left = clipped.left.round().clamp(0, width - outWidth),
      top = clipped.top.round().clamp(0, height - outHeight);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.translate(-left.toDouble(), -top.toDouble());
  // extended_image reports crops in the rotated, then mirrored coordinate space.
  if (flipHorizontal) {
    canvas.translate(width.toDouble(), 0);
    canvas.scale(-1, 1);
  }
  switch (q) {
    case 1:
      canvas.translate(source.height.toDouble(), 0);
      canvas.rotate(math.pi / 2);
    case 2:
      canvas.translate(source.width.toDouble(), source.height.toDouble());
      canvas.rotate(math.pi);
    case 3:
      canvas.translate(0, source.width.toDouble());
      canvas.rotate(3 * math.pi / 2);
  }
  canvas.drawImage(
    source,
    Offset.zero,
    Paint()..filterQuality = FilterQuality.none,
  );
  final picture = recorder.endRecording();
  ui.Image? output;
  try {
    output = await picture.toImage(outWidth, outHeight);
    final data = await output.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) throw StateError('PNG encoding returned no data');
    return HyperImageEditResult(
      bytes: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      width: outWidth,
      height: outHeight,
    );
  } finally {
    output?.dispose();
    picture.dispose();
  }
}
