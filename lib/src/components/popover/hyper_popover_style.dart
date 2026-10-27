import 'package:flutter/widgets.dart';

import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';

@immutable
final class HyperPopoverStyle {
  const HyperPopoverStyle({this.surfaceStyle, this.spacing, this.transition});

  final HyperCardStyle? surfaceStyle;
  final double? spacing;
  final HyperOverlayTransition? transition;

  HyperPopoverStyle copyWith({
    HyperCardStyle? surfaceStyle,
    double? spacing,
    HyperOverlayTransition? transition,
  }) => HyperPopoverStyle(
    surfaceStyle: surfaceStyle ?? this.surfaceStyle,
    spacing: spacing ?? this.spacing,
    transition: transition ?? this.transition,
  );

  HyperPopoverStyle merge(HyperPopoverStyle? other) => other == null
      ? this
      : copyWith(
          surfaceStyle: (surfaceStyle ?? HyperCardStyle()).merge(
            other.surfaceStyle,
          ),
          spacing: other.spacing,
          transition: other.transition,
        );

  static HyperPopoverStyle lerp(
    HyperPopoverStyle a,
    HyperPopoverStyle b,
    double t,
  ) => HyperPopoverStyle(
    surfaceStyle: HyperCardStyle.lerp(
      a.surfaceStyle ?? HyperCardStyle(),
      b.surfaceStyle ?? HyperCardStyle(),
      t,
    ),
    spacing: a.spacing == null || b.spacing == null
        ? (t < .5 ? a.spacing : b.spacing)
        : a.spacing! + (b.spacing! - a.spacing!) * t,
    transition: t < .5 ? a.transition : b.transition,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperPopoverStyle &&
      other.surfaceStyle == surfaceStyle &&
      other.spacing == spacing &&
      other.transition == transition;
  @override
  int get hashCode => Object.hash(surfaceStyle, spacing, transition);
}
