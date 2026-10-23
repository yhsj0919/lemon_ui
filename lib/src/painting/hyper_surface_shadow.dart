import '../foundation/hyper_fill.dart';

/// A translucent or backdrop-filtered surface must not see its own shadow.
bool hyperSurfaceShadowNeedsIsolation({
  required HyperFill? background,
  required bool usesBackdrop,
  required bool outsideShadow,
}) =>
    outsideShadow ||
    usesBackdrop ||
    background == null ||
    (background.color != null && background.color!.a < 1) ||
    (background.gradient?.colors.any((color) => color.a < 1) ?? false);
