import 'dart:math' as math;
import 'package:flutter/painting.dart';

/// Constrains a native crop candidate without changing its aspect-ratio model.
Rect constrainCropRect(
  Rect current,
  Rect candidate,
  Rect bounds, {
  required bool preserveAspectRatio,
}) {
  if (bounds.isEmpty || candidate.isEmpty) {
    return current;
  }
  if (!preserveAspectRatio) {
    return candidate.intersect(bounds);
  }
  double fraction = 1;
  if (candidate.left < bounds.left && candidate.left < current.left) {
    fraction = math.min(
      fraction,
      (current.left - bounds.left) / (current.left - candidate.left),
    );
  }
  if (candidate.top < bounds.top && candidate.top < current.top) {
    fraction = math.min(
      fraction,
      (current.top - bounds.top) / (current.top - candidate.top),
    );
  }
  if (candidate.right > bounds.right && candidate.right > current.right) {
    fraction = math.min(
      fraction,
      (bounds.right - current.right) / (candidate.right - current.right),
    );
  }
  if (candidate.bottom > bounds.bottom && candidate.bottom > current.bottom) {
    fraction = math.min(
      fraction,
      (bounds.bottom - current.bottom) / (candidate.bottom - current.bottom),
    );
  }
  return Rect.lerp(current, candidate, fraction.clamp(0.0, 1.0))!;
}
