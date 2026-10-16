import '../card/hyper_card_style.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 滑块的实例视觉覆盖；空字段继承局部或全局主题。
@immutable
final class HyperSliderStyle {
  const HyperSliderStyle({
    this.activeTrackColor,
    this.bufferColor,
    this.bufferGradient,
    this.inactiveTrackColor,
    this.hoverInactiveTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.thumbColor,
    this.disabledThumbColor,
    this.overlayColor,
    this.valueIndicatorColor,
    this.valueIndicatorTextStyle,
    this.showValueIndicator,
    this.valueIndicatorSurface,
    this.valueIndicatorGap,
    this.trackHeight,
    this.thumbRadius,
    this.thumbWidth,
    this.thumbHeight,
    this.thumbShadows,
    this.overlayRadius,
    this.thumbOutlineColor,
    this.thumbOutlineWidth,
    this.pressedThumbScale,
    this.stepPointRadius,
    this.activeStepPointColor,
    this.inactiveStepPointColor,
    this.trackShape,
    this.rangeTrackShape,
    this.thumbShape,
    this.overlayShape,
    this.valueIndicatorShape,
    this.rangeThumbShape,
    this.rangeValueIndicatorShape,
    this.capsuleBackgroundColor,
    this.capsuleFillColor,
    this.capsuleBorderColor,
    this.capsuleBorderWidth,
    this.capsuleTopIconColor,
    this.capsuleBottomIconColor,
    this.capsuleAutoIconContrast,
    this.capsuleTopIconTurns,
    this.capsuleBottomIconTurns,
    this.capsuleWidth,
    this.capsuleCornerRadius,
    this.capsuleIconSize,
    this.capsuleIconInset,
    this.capsuleOverscrollExtent,
    this.capsuleOverscrollScale,
    this.capsuleOverscrollSpring,
    this.capsuleAnimationDuration,
    this.capsuleAnimationCurve,
  });

  final Color? activeTrackColor;
  final Color? bufferColor;
  final Gradient? bufferGradient;
  final Color? inactiveTrackColor;
  final Color? hoverInactiveTrackColor;
  final Color? disabledActiveTrackColor;
  final Color? disabledInactiveTrackColor;
  final Color? thumbColor;
  final Color? disabledThumbColor;
  final Color? overlayColor;
  final Color? valueIndicatorColor;
  final TextStyle? valueIndicatorTextStyle;
  final ShowValueIndicator? showValueIndicator;
  final HyperCardStyle? valueIndicatorSurface;
  final double? valueIndicatorGap;
  final double? trackHeight;
  final double? thumbRadius;
  final double? thumbWidth, thumbHeight;
  final List<BoxShadow>? thumbShadows;
  final double? overlayRadius;
  final Color? thumbOutlineColor;
  final double? thumbOutlineWidth;
  final double? pressedThumbScale;
  final double? stepPointRadius;
  final Color? activeStepPointColor;
  final Color? inactiveStepPointColor;
  final SliderTrackShape? trackShape;
  final RangeSliderTrackShape? rangeTrackShape;
  final SliderComponentShape? thumbShape;
  final SliderComponentShape? overlayShape;
  final SliderComponentShape? valueIndicatorShape;
  final RangeSliderThumbShape? rangeThumbShape;
  final RangeSliderValueIndicatorShape? rangeValueIndicatorShape;
  final Color? capsuleBackgroundColor;
  final Color? capsuleFillColor;
  final Color? capsuleBorderColor;
  final double? capsuleBorderWidth;
  final Color? capsuleTopIconColor;
  final Color? capsuleBottomIconColor;
  final bool? capsuleAutoIconContrast;
  final double? capsuleTopIconTurns;
  final double? capsuleBottomIconTurns;
  final double? capsuleWidth;
  final double? capsuleCornerRadius;
  final double? capsuleIconSize;
  final double? capsuleIconInset;
  final double? capsuleOverscrollExtent;
  final double? capsuleOverscrollScale;
  final SpringDescription? capsuleOverscrollSpring;
  final Duration? capsuleAnimationDuration;
  final Curve? capsuleAnimationCurve;

  HyperSliderStyle merge(HyperSliderStyle? other) => other == null
      ? this
      : HyperSliderStyle(
          activeTrackColor: other.activeTrackColor ?? activeTrackColor,
          bufferColor: other.bufferColor ?? bufferColor,
          bufferGradient:
              other.bufferGradient ??
              (other.bufferColor != null ? null : bufferGradient),
          inactiveTrackColor: other.inactiveTrackColor ?? inactiveTrackColor,
          hoverInactiveTrackColor:
              other.hoverInactiveTrackColor ?? hoverInactiveTrackColor,
          disabledActiveTrackColor:
              other.disabledActiveTrackColor ?? disabledActiveTrackColor,
          disabledInactiveTrackColor:
              other.disabledInactiveTrackColor ?? disabledInactiveTrackColor,
          thumbColor: other.thumbColor ?? thumbColor,
          disabledThumbColor: other.disabledThumbColor ?? disabledThumbColor,
          overlayColor: other.overlayColor ?? overlayColor,
          valueIndicatorColor: other.valueIndicatorColor ?? valueIndicatorColor,
          valueIndicatorTextStyle:
              other.valueIndicatorTextStyle ?? valueIndicatorTextStyle,
          trackHeight: other.trackHeight ?? trackHeight,
          thumbRadius: other.thumbRadius ?? thumbRadius,
          thumbWidth: other.thumbWidth ?? thumbWidth,
          thumbHeight: other.thumbHeight ?? thumbHeight,
          thumbShadows: other.thumbShadows ?? thumbShadows,
          overlayRadius: other.overlayRadius ?? overlayRadius,
          thumbOutlineColor: other.thumbOutlineColor ?? thumbOutlineColor,
          thumbOutlineWidth: other.thumbOutlineWidth ?? thumbOutlineWidth,
          pressedThumbScale: other.pressedThumbScale ?? pressedThumbScale,
          stepPointRadius: other.stepPointRadius ?? stepPointRadius,
          activeStepPointColor:
              other.activeStepPointColor ?? activeStepPointColor,
          inactiveStepPointColor:
              other.inactiveStepPointColor ?? inactiveStepPointColor,
          trackShape: other.trackShape ?? trackShape,
          rangeTrackShape: other.rangeTrackShape ?? rangeTrackShape,
          thumbShape: other.thumbShape ?? thumbShape,
          overlayShape: other.overlayShape ?? overlayShape,
          valueIndicatorSurface:
              valueIndicatorSurface?.merge(other.valueIndicatorSurface) ??
              other.valueIndicatorSurface,
          valueIndicatorGap: other.valueIndicatorGap ?? valueIndicatorGap,
          showValueIndicator: other.showValueIndicator ?? showValueIndicator,
          valueIndicatorShape: other.valueIndicatorShape ?? valueIndicatorShape,
          rangeThumbShape: other.rangeThumbShape ?? rangeThumbShape,
          rangeValueIndicatorShape:
              other.rangeValueIndicatorShape ?? rangeValueIndicatorShape,
          capsuleBackgroundColor:
              other.capsuleBackgroundColor ?? capsuleBackgroundColor,
          capsuleFillColor: other.capsuleFillColor ?? capsuleFillColor,
          capsuleBorderColor: other.capsuleBorderColor ?? capsuleBorderColor,
          capsuleBorderWidth: other.capsuleBorderWidth ?? capsuleBorderWidth,
          capsuleTopIconColor: other.capsuleTopIconColor ?? capsuleTopIconColor,
          capsuleBottomIconColor:
              other.capsuleBottomIconColor ?? capsuleBottomIconColor,
          capsuleAutoIconContrast:
              other.capsuleAutoIconContrast ?? capsuleAutoIconContrast,
          capsuleTopIconTurns: other.capsuleTopIconTurns ?? capsuleTopIconTurns,
          capsuleBottomIconTurns:
              other.capsuleBottomIconTurns ?? capsuleBottomIconTurns,
          capsuleWidth: other.capsuleWidth ?? capsuleWidth,
          capsuleCornerRadius: other.capsuleCornerRadius ?? capsuleCornerRadius,
          capsuleIconSize: other.capsuleIconSize ?? capsuleIconSize,
          capsuleIconInset: other.capsuleIconInset ?? capsuleIconInset,
          capsuleOverscrollExtent:
              other.capsuleOverscrollExtent ?? capsuleOverscrollExtent,
          capsuleOverscrollScale:
              other.capsuleOverscrollScale ?? capsuleOverscrollScale,
          capsuleOverscrollSpring:
              other.capsuleOverscrollSpring ?? capsuleOverscrollSpring,
          capsuleAnimationDuration:
              other.capsuleAnimationDuration ?? capsuleAnimationDuration,
          capsuleAnimationCurve:
              other.capsuleAnimationCurve ?? capsuleAnimationCurve,
        );

  static HyperSliderStyle lerp(
    HyperSliderStyle a,
    HyperSliderStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return HyperSliderStyle(
      bufferColor: Color.lerp(a.bufferColor, b.bufferColor, t),
      bufferGradient: Gradient.lerp(a.bufferGradient, b.bufferGradient, t),
      activeTrackColor: Color.lerp(a.activeTrackColor, b.activeTrackColor, t),
      inactiveTrackColor: Color.lerp(
        a.inactiveTrackColor,
        b.inactiveTrackColor,
        t,
      ),
      hoverInactiveTrackColor: Color.lerp(
        a.hoverInactiveTrackColor,
        b.hoverInactiveTrackColor,
        t,
      ),
      disabledActiveTrackColor: Color.lerp(
        a.disabledActiveTrackColor,
        b.disabledActiveTrackColor,
        t,
      ),
      disabledInactiveTrackColor: Color.lerp(
        a.disabledInactiveTrackColor,
        b.disabledInactiveTrackColor,
        t,
      ),
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
      disabledThumbColor: Color.lerp(
        a.disabledThumbColor,
        b.disabledThumbColor,
        t,
      ),
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      valueIndicatorColor: Color.lerp(
        a.valueIndicatorColor,
        b.valueIndicatorColor,
        t,
      ),
      valueIndicatorTextStyle: TextStyle.lerp(
        a.valueIndicatorTextStyle,
        b.valueIndicatorTextStyle,
        t,
      ),
      trackHeight: _lerpDouble(a.trackHeight, b.trackHeight, t),
      thumbRadius: _lerpDouble(a.thumbRadius, b.thumbRadius, t),
      thumbWidth: _lerpDouble(a.thumbWidth, b.thumbWidth, t),
      thumbHeight: _lerpDouble(a.thumbHeight, b.thumbHeight, t),
      thumbShadows: BoxShadow.lerpList(a.thumbShadows, b.thumbShadows, t),
      overlayRadius: _lerpDouble(a.overlayRadius, b.overlayRadius, t),
      thumbOutlineColor: Color.lerp(
        a.thumbOutlineColor,
        b.thumbOutlineColor,
        t,
      ),
      thumbOutlineWidth: _lerpDouble(
        a.thumbOutlineWidth,
        b.thumbOutlineWidth,
        t,
      ),
      pressedThumbScale: _lerpDouble(
        a.pressedThumbScale,
        b.pressedThumbScale,
        t,
      ),
      stepPointRadius: _lerpDouble(a.stepPointRadius, b.stepPointRadius, t),
      activeStepPointColor: Color.lerp(
        a.activeStepPointColor,
        b.activeStepPointColor,
        t,
      ),
      inactiveStepPointColor: Color.lerp(
        a.inactiveStepPointColor,
        b.inactiveStepPointColor,
        t,
      ),
      trackShape: t < .5 ? a.trackShape : b.trackShape,
      rangeTrackShape: t < .5 ? a.rangeTrackShape : b.rangeTrackShape,
      thumbShape: t < .5 ? a.thumbShape : b.thumbShape,
      overlayShape: t < .5 ? a.overlayShape : b.overlayShape,
      valueIndicatorSurface:
          a.valueIndicatorSurface == null || b.valueIndicatorSurface == null
          ? (t < .5 ? a.valueIndicatorSurface : b.valueIndicatorSurface)
          : HyperCardStyle.lerp(
              a.valueIndicatorSurface!,
              b.valueIndicatorSurface!,
              t,
            ),
      valueIndicatorGap: _lerpDouble(
        a.valueIndicatorGap,
        b.valueIndicatorGap,
        t,
      ),
      showValueIndicator: t < .5 ? a.showValueIndicator : b.showValueIndicator,
      valueIndicatorShape: t < .5
          ? a.valueIndicatorShape
          : b.valueIndicatorShape,
      rangeThumbShape: t < .5 ? a.rangeThumbShape : b.rangeThumbShape,
      rangeValueIndicatorShape: t < .5
          ? a.rangeValueIndicatorShape
          : b.rangeValueIndicatorShape,
      capsuleBackgroundColor: Color.lerp(
        a.capsuleBackgroundColor,
        b.capsuleBackgroundColor,
        t,
      ),
      capsuleFillColor: Color.lerp(a.capsuleFillColor, b.capsuleFillColor, t),
      capsuleBorderColor: Color.lerp(
        a.capsuleBorderColor,
        b.capsuleBorderColor,
        t,
      ),
      capsuleBorderWidth: _lerpDouble(
        a.capsuleBorderWidth,
        b.capsuleBorderWidth,
        t,
      ),
      capsuleTopIconColor: Color.lerp(
        a.capsuleTopIconColor,
        b.capsuleTopIconColor,
        t,
      ),
      capsuleBottomIconColor: Color.lerp(
        a.capsuleBottomIconColor,
        b.capsuleBottomIconColor,
        t,
      ),
      capsuleAutoIconContrast: t < .5
          ? a.capsuleAutoIconContrast
          : b.capsuleAutoIconContrast,
      capsuleTopIconTurns: _lerpDouble(
        a.capsuleTopIconTurns,
        b.capsuleTopIconTurns,
        t,
      ),
      capsuleBottomIconTurns: _lerpDouble(
        a.capsuleBottomIconTurns,
        b.capsuleBottomIconTurns,
        t,
      ),
      capsuleWidth: _lerpDouble(a.capsuleWidth, b.capsuleWidth, t),
      capsuleCornerRadius: _lerpDouble(
        a.capsuleCornerRadius,
        b.capsuleCornerRadius,
        t,
      ),
      capsuleIconSize: _lerpDouble(a.capsuleIconSize, b.capsuleIconSize, t),
      capsuleIconInset: _lerpDouble(a.capsuleIconInset, b.capsuleIconInset, t),
      capsuleOverscrollExtent: _lerpDouble(
        a.capsuleOverscrollExtent,
        b.capsuleOverscrollExtent,
        t,
      ),
      capsuleOverscrollScale: _lerpDouble(
        a.capsuleOverscrollScale,
        b.capsuleOverscrollScale,
        t,
      ),
      capsuleOverscrollSpring: _lerpSpring(
        a.capsuleOverscrollSpring,
        b.capsuleOverscrollSpring,
        t,
      ),
      capsuleAnimationDuration: t < .5
          ? a.capsuleAnimationDuration
          : b.capsuleAnimationDuration,
      capsuleAnimationCurve: t < .5
          ? a.capsuleAnimationCurve
          : b.capsuleAnimationCurve,
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) =>
      a == null || b == null ? (t < .5 ? a : b) : a + (b - a) * t;

  static SpringDescription? _lerpSpring(
    SpringDescription? a,
    SpringDescription? b,
    double t,
  ) => a == null || b == null
      ? (t < .5 ? a : b)
      : SpringDescription(
          mass: a.mass + (b.mass - a.mass) * t,
          stiffness: a.stiffness + (b.stiffness - a.stiffness) * t,
          damping: a.damping + (b.damping - a.damping) * t,
        );

  static bool _sameSpring(SpringDescription? a, SpringDescription? b) =>
      identical(a, b) ||
      (a != null &&
          b != null &&
          a.mass == b.mass &&
          a.stiffness == b.stiffness &&
          a.damping == b.damping);

  @override
  bool operator ==(Object other) =>
      other is HyperSliderStyle &&
      other.activeTrackColor == activeTrackColor &&
      other.bufferColor == bufferColor &&
      other.bufferGradient == bufferGradient &&
      other.inactiveTrackColor == inactiveTrackColor &&
      other.hoverInactiveTrackColor == hoverInactiveTrackColor &&
      other.disabledActiveTrackColor == disabledActiveTrackColor &&
      other.disabledInactiveTrackColor == disabledInactiveTrackColor &&
      other.thumbColor == thumbColor &&
      other.disabledThumbColor == disabledThumbColor &&
      other.overlayColor == overlayColor &&
      other.valueIndicatorColor == valueIndicatorColor &&
      other.valueIndicatorTextStyle == valueIndicatorTextStyle &&
      other.showValueIndicator == showValueIndicator &&
      other.valueIndicatorSurface == valueIndicatorSurface &&
      other.valueIndicatorGap == valueIndicatorGap &&
      other.trackHeight == trackHeight &&
      other.thumbRadius == thumbRadius &&
      other.thumbWidth == thumbWidth &&
      other.thumbHeight == thumbHeight &&
      listEquals(other.thumbShadows, thumbShadows) &&
      other.overlayRadius == overlayRadius &&
      other.thumbOutlineColor == thumbOutlineColor &&
      other.thumbOutlineWidth == thumbOutlineWidth &&
      other.pressedThumbScale == pressedThumbScale &&
      other.stepPointRadius == stepPointRadius &&
      other.activeStepPointColor == activeStepPointColor &&
      other.inactiveStepPointColor == inactiveStepPointColor &&
      other.trackShape == trackShape &&
      other.rangeTrackShape == rangeTrackShape &&
      other.thumbShape == thumbShape &&
      other.overlayShape == overlayShape &&
      other.valueIndicatorShape == valueIndicatorShape &&
      other.rangeThumbShape == rangeThumbShape &&
      other.rangeValueIndicatorShape == rangeValueIndicatorShape &&
      other.capsuleBackgroundColor == capsuleBackgroundColor &&
      other.capsuleFillColor == capsuleFillColor &&
      other.capsuleBorderColor == capsuleBorderColor &&
      other.capsuleBorderWidth == capsuleBorderWidth &&
      other.capsuleTopIconColor == capsuleTopIconColor &&
      other.capsuleBottomIconColor == capsuleBottomIconColor &&
      other.capsuleAutoIconContrast == capsuleAutoIconContrast &&
      other.capsuleTopIconTurns == capsuleTopIconTurns &&
      other.capsuleBottomIconTurns == capsuleBottomIconTurns &&
      other.capsuleWidth == capsuleWidth &&
      other.capsuleCornerRadius == capsuleCornerRadius &&
      other.capsuleIconSize == capsuleIconSize &&
      other.capsuleIconInset == capsuleIconInset &&
      other.capsuleOverscrollExtent == capsuleOverscrollExtent &&
      other.capsuleOverscrollScale == capsuleOverscrollScale &&
      _sameSpring(other.capsuleOverscrollSpring, capsuleOverscrollSpring) &&
      other.capsuleAnimationDuration == capsuleAnimationDuration &&
      other.capsuleAnimationCurve == capsuleAnimationCurve;

  @override
  int get hashCode => Object.hashAll([
    activeTrackColor,
    bufferColor,
    bufferGradient,
    inactiveTrackColor,
    hoverInactiveTrackColor,
    disabledActiveTrackColor,
    disabledInactiveTrackColor,
    thumbColor,
    disabledThumbColor,
    overlayColor,
    valueIndicatorColor,
    valueIndicatorTextStyle,
    showValueIndicator,
    valueIndicatorSurface,
    valueIndicatorGap,
    trackHeight,
    thumbRadius,
    thumbWidth,
    thumbHeight,
    Object.hashAll(thumbShadows ?? const <BoxShadow>[]),
    overlayRadius,
    thumbOutlineColor,
    thumbOutlineWidth,
    pressedThumbScale,
    stepPointRadius,
    activeStepPointColor,
    inactiveStepPointColor,
    trackShape,
    rangeTrackShape,
    thumbShape,
    overlayShape,
    valueIndicatorShape,
    rangeThumbShape,
    rangeValueIndicatorShape,
    capsuleBackgroundColor,
    capsuleFillColor,
    capsuleBorderColor,
    capsuleBorderWidth,
    capsuleTopIconColor,
    capsuleBottomIconColor,
    capsuleAutoIconContrast,
    capsuleTopIconTurns,
    capsuleBottomIconTurns,
    capsuleWidth,
    capsuleCornerRadius,
    capsuleIconSize,
    capsuleIconInset,
    capsuleOverscrollExtent,
    capsuleOverscrollScale,
    capsuleOverscrollSpring == null
        ? null
        : Object.hash(
            capsuleOverscrollSpring!.mass,
            capsuleOverscrollSpring!.stiffness,
            capsuleOverscrollSpring!.damping,
          ),
    capsuleAnimationDuration,
    capsuleAnimationCurve,
  ]);
}
