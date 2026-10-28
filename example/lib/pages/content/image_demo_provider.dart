import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'image_demo_data.dart';

// Only example fixtures use this provider. Real image errors keep their normal
// framework reporting and are never filtered through a global error handler.
class DemoImageProvider extends ImageProvider<DemoImageProvider> {
  DemoImageProvider({this.failFirst = false});
  final bool failFirst;
  int _attempt = 0;
  @override
  Future<DemoImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);
  @override
  ImageStreamCompleter loadImage(
    DemoImageProvider key,
    ImageDecoderCallback decode,
  ) => _DemoImageStream(decode, shouldFail: () => failFirst && _attempt++ == 0);
}

class _DemoFailure implements Exception {
  const _DemoFailure();
  @override
  String toString() => '演示：模拟首次加载失败';
}

class _DemoImageStream extends ImageStreamCompleter {
  _DemoImageStream(this.decode, {required this.shouldFail}) {
    addOnLastListenerRemovedCallback(() => _abandoned = true);
    unawaited(_load());
  }
  final ImageDecoderCallback decode;
  final bool Function() shouldFail;
  bool _abandoned = false;
  Future<void> _load() async {
    ui.Codec? codec;
    try {
      for (var step = 1; step <= 4; step++) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        if (_abandoned) return;
        reportImageChunkEvent(
          ImageChunkEvent(cumulativeBytesLoaded: step, expectedTotalBytes: 4),
        );
      }
      if (shouldFail()) {
        // This is an expected fixture state, not a failed codec. The ephemeral
        // listener handles only this one intentional event if the widget/cache has
        // already detached; active image consumers still receive their failure state.
        addEphemeralErrorListener((error, stack) {});
        reportError(
          exception: const _DemoFailure(),
          context: ErrorDescription(
            'showing an intentional image demo failure',
          ),
          silent: true,
        );
        return;
      }
      final buffer = await ui.ImmutableBuffer.fromUint8List(imageDemoBytes);
      if (_abandoned) {
        buffer.dispose();
        return;
      }
      codec = await decode(buffer);
      if (_abandoned) return;
      final frame = await codec.getNextFrame();
      if (_abandoned) {
        frame.image.dispose();
        return;
      }
      setImage(ImageInfo(image: frame.image));
    } catch (error, stack) {
      if (!_abandoned) {
        reportError(
          exception: error,
          stack: stack,
          context: ErrorDescription('decoding the image demo fixture'),
        );
      }
    } finally {
      codec?.dispose();
    }
  }
}
