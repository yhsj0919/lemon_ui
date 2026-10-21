import 'package:flutter/material.dart';

import '../../theme/color/hyper_color_scheme.dart';

// Derived from same-device semantic surfaces; these are not official grid specs.
Color tableStripeBackground(HyperColorScheme colors) =>
    Color.lerp(colors.surface, colors.surfaceMuted, .5)!;

Color tableHoverBackground(HyperColorScheme colors, Color hoverOverlay) =>
    Color.alphaBlend(
      colors.primary.withValues(alpha: hoverOverlay.a),
      colors.surface,
    );
