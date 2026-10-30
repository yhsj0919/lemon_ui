import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// The native Material color used as the image gradient's endpoint.
enum HyperImageColorRole { primary, primaryContainer }

/// Extracts representative colors through Flutter's image-provider pipeline.
abstract final class HyperImageColors {
  /// Returns a native Material color generated from [image].
  ///
  /// Defaults to primary with Flutter's light color scheme. No additional
  /// lightening or black/white filtering is applied to the generated color.
  static Future<Color> fromImageProvider(
    ImageProvider image, {
    HyperImageColorRole role = HyperImageColorRole.primary,
  }) async {
    final scheme = await ColorScheme.fromImageProvider(provider: image);
    return switch (role) {
      HyperImageColorRole.primary => scheme.primary,
      HyperImageColorRole.primaryContainer => scheme.primaryContainer,
    };
  }

  /// Returns a representative visible color of the first decoded frame.
  ///
  /// Samples at most 64 by 64 decoded pixels to bound CPU and memory costs.
  /// Nearby RGB values share a five-bit histogram bin, weighted by alpha;
  /// fully transparent pixels are ignored. Returns null for an empty image.
  /// By default, near-black and near-white bins are skipped when another color
  /// exists. Images containing only those colors retain their dominant color.
  /// Provider errors propagate to the returned future.
  static Future<Color?> dominant(
    ImageProvider image, {
    ImageConfiguration configuration = ImageConfiguration.empty,
    bool avoidBlackAndWhite = true,
  }) {
    final result = Completer<Color?>();
    final stream = ResizeImage(
      image,
      width: 64,
      height: 64,
      policy: ResizeImagePolicy.fit,
    ).resolve(configuration);
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, synchronous) {
        stream.removeListener(listener);
        unawaited(() async {
          try {
            final bytes = await info.image.toByteData(
              format: ui.ImageByteFormat.rawStraightRgba,
            );
            result.complete(
              bytes == null
                  ? null
                  : _dominant(
                      bytes.buffer.asUint8List(
                        bytes.offsetInBytes,
                        bytes.lengthInBytes,
                      ),
                      avoidBlackAndWhite: avoidBlackAndWhite,
                    ),
            );
          } catch (error, stack) {
            result.completeError(error, stack);
          } finally {
            info.dispose();
          }
        }());
      },
      onError: (Object error, StackTrace? stack) {
        stream.removeListener(listener);
        result.completeError(error, stack);
      },
    );
    stream.addListener(listener);
    return result.future;
  }

  static Color? _dominant(Uint8List bytes, {required bool avoidBlackAndWhite}) {
    final bins = <int, _ColorBin>{};
    _ColorBin? best;
    for (var i = 0; i + 3 < bytes.length; i += 4) {
      final a = bytes[i + 3];
      if (a == 0) continue;
      final r = bytes[i], g = bytes[i + 1], b = bytes[i + 2];
      final key = ((r >> 3) << 10) | ((g >> 3) << 5) | (b >> 3);
      final bin = bins.putIfAbsent(key, _ColorBin.new);
      bin.weight += a;
      bin.red += r * a;
      bin.green += g * a;
      bin.blue += b * a;
      if (best == null || bin.weight > best.weight) best = bin;
    }
    if (avoidBlackAndWhite) {
      _ColorBin? preferred;
      for (final bin in bins.values) {
        final r = bin.red / bin.weight,
            g = bin.green / bin.weight,
            b = bin.blue / bin.weight;
        // Sampling heuristic: avoid near-neutral extremes without filtering
        // saturated dark/bright colors or altering the extracted RGB values.
        final nearBlack = r <= 32 && g <= 32 && b <= 32;
        final nearWhite = r >= 224 && g >= 224 && b >= 224;
        if (nearBlack || nearWhite) continue;
        if (preferred == null || bin.weight > preferred.weight) preferred = bin;
      }
      best = preferred ?? best;
    }
    if (best == null) return null;
    return Color.fromARGB(
      255,
      (best.red / best.weight).round(),
      (best.green / best.weight).round(),
      (best.blue / best.weight).round(),
    );
  }
}

class _ColorBin {
  int weight = 0, red = 0, green = 0, blue = 0;
}
