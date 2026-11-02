import 'package:flutter/material.dart';

import '../../theme/color/hyper_color_scheme.dart';
import '../../theme/color/hyper_contrast_theme.dart';
import '../../foundation/hyper_fill.dart';

// Derived from same-device semantic surfaces; these are not official grid specs.
Color tableStripeBackground(HyperColorScheme colors) =>
    Color.lerp(colors.surface, colors.surfaceMuted, .5)!;

Color tableHoverBackground(HyperColorScheme colors, Color hoverOverlay) =>
    Color.alphaBlend(
      colors.primary.withValues(alpha: hoverOverlay.a),
      colors.surface,
    );

Color tableSelectedForeground(
  HyperColorScheme colors,
  HyperContrastThemeData contrast, {
  required Color background,
  required Color canvasColor,
  required Color foreground,
}) => contrast.resolve(
  foreground: background == colors.primary
      ? colors.onPrimary
      : background == colors.primaryContainer
      ? colors.onPrimaryContainer
      : foreground,
  background: HyperFill.color(background),
  canvasColor: canvasColor,
);
