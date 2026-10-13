import 'package:flutter/painting.dart';

import 'hyper_fill.dart';
import '../theme/color/hyper_color_scheme.dart';
import '../theme/color/hyper_contrast_theme.dart';

enum HyperLabelColorVariant { neutral, soft, filled, outlined, text }

enum HyperLabelForegroundMode { automatic, white }

({
  HyperFill background,
  Color? foregroundColor,
  Color borderColor,
  double borderWidth,
})?
resolveHyperLabelPalette({
  required HyperColorScheme colors,
  required HyperContrastThemeData contrast,
  HyperLabelColorVariant? colorVariant,
  Color? baseColor,
  HyperLabelForegroundMode? foregroundMode,
  double? backgroundFade,
  double? borderFade,
  double? foregroundFade,
}) {
  final variant = colorVariant ?? HyperLabelColorVariant.neutral;
  if (variant == HyperLabelColorVariant.neutral) return null;
  final base = baseColor ?? colors.primary;
  Color fade(double value) => value <= 0
      ? base
      : value >= 1
      ? colors.surface
      : Color.lerp(base, colors.surface, value)!;
  final fill = switch (variant) {
    HyperLabelColorVariant.soft => HyperFill.color(fade(backgroundFade ?? .88)),
    HyperLabelColorVariant.filled => HyperFill.color(fade(backgroundFade ?? 0)),
    _ => const HyperFill.none(),
  };
  final foreground = variant == HyperLabelColorVariant.filled
      ? foregroundMode == HyperLabelForegroundMode.white
            ? const Color(0xffffffff)
            : contrast.resolve(
                foreground: colors.onPrimary,
                background: fill,
                canvasColor: colors.surface,
              )
      : fade(foregroundFade ?? 0);
  return (
    background: fill,
    foregroundColor: variant == HyperLabelColorVariant.filled
        ? Color.lerp(
            foreground,
            colors.surface,
            (foregroundFade ?? 0).clamp(0, 1),
          )
        : foreground,
    borderColor: fade(
      borderFade ?? (variant == HyperLabelColorVariant.soft ? .65 : 0),
    ),
    borderWidth: variant == HyperLabelColorVariant.outlined ? 1 : 0,
  );
}
