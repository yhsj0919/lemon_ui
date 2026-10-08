import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';

/// 选中对勾位于文字前，或叠加在头像中心。
enum HyperChipCheckmarkPlacement { leading, avatarOverlay, avatarReplacement }

@immutable
final class HyperChipStyle {
  const HyperChipStyle({
    this.background,
    this.foregroundColor,
    this.overlayColor,
    this.borderColor,
    this.borderWidth,
    this.height,
    this.horizontalPadding,
    this.radius,
    this.iconSize,
    this.avatarSize,
    this.avatarOpacity,
    this.iconSpacing,
    this.deleteIconSize,
    this.deleteTargetWidth,
    this.minimumTapTargetSize,
    this.checkmarkIcon,
    this.checkmarkPlacement,
    this.checkmarkColor,
    this.selectedAvatarShape,
    this.selectedAvatarColor,
    this.checkmarkScale,
    this.deleteIcon,
    this.showCheckmark,
    this.textStyle,
    this.boxShadow,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final Color? foregroundColor;
  final Color? overlayColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final double? horizontalPadding;
  final double? radius;
  final double? iconSize;
  final double? avatarSize;
  final double? avatarOpacity;
  final double? iconSpacing;
  final double? deleteIconSize;
  final double? deleteTargetWidth;
  final double? minimumTapTargetSize;
  final IconData? checkmarkIcon;
  final HyperChipCheckmarkPlacement? checkmarkPlacement;
  final Color? checkmarkColor;
  final ShapeBorder? selectedAvatarShape;
  final Color? selectedAvatarColor;
  final double? checkmarkScale;
  final IconData? deleteIcon;
  final bool? showCheckmark;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperChipStyle copyWith({
    HyperFill? background,
    Color? foregroundColor,
    Color? overlayColor,
    Color? borderColor,
    double? borderWidth,
    double? height,
    double? horizontalPadding,
    double? radius,
    double? iconSize,
    double? avatarSize,
    double? avatarOpacity,
    double? iconSpacing,
    double? deleteIconSize,
    double? deleteTargetWidth,
    double? minimumTapTargetSize,
    IconData? checkmarkIcon,
    HyperChipCheckmarkPlacement? checkmarkPlacement,
    Color? checkmarkColor,
    ShapeBorder? selectedAvatarShape,
    Color? selectedAvatarColor,
    double? checkmarkScale,
    IconData? deleteIcon,
    bool? showCheckmark,
    TextStyle? textStyle,
    List<BoxShadow>? boxShadow,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => merge(
    HyperChipStyle(
      background: background,
      foregroundColor: foregroundColor,
      overlayColor: overlayColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      height: height,
      horizontalPadding: horizontalPadding,
      radius: radius,
      iconSize: iconSize,
      avatarSize: avatarSize,
      avatarOpacity: avatarOpacity,
      iconSpacing: iconSpacing,
      deleteIconSize: deleteIconSize,
      deleteTargetWidth: deleteTargetWidth,
      minimumTapTargetSize: minimumTapTargetSize,
      checkmarkIcon: checkmarkIcon,
      checkmarkPlacement: checkmarkPlacement,
      checkmarkColor: checkmarkColor,
      selectedAvatarShape: selectedAvatarShape,
      selectedAvatarColor: selectedAvatarColor,
      checkmarkScale: checkmarkScale,
      deleteIcon: deleteIcon,
      showCheckmark: showCheckmark,
      textStyle: textStyle,
      boxShadow: boxShadow,
      duration: duration,
      curve: curve,
      transitionBuilder: transitionBuilder,
    ),
  );
  HyperChipStyle merge(HyperChipStyle? other) => other == null
      ? this
      : HyperChipStyle(
          background: other.background ?? background,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          overlayColor: other.overlayColor ?? overlayColor,
          borderColor: other.borderColor ?? borderColor,
          borderWidth: other.borderWidth ?? borderWidth,
          height: other.height ?? height,
          horizontalPadding: other.horizontalPadding ?? horizontalPadding,
          radius: other.radius ?? radius,
          iconSize: other.iconSize ?? iconSize,
          avatarSize: other.avatarSize ?? avatarSize,
          avatarOpacity: other.avatarOpacity ?? avatarOpacity,
          iconSpacing: other.iconSpacing ?? iconSpacing,
          deleteIconSize: other.deleteIconSize ?? deleteIconSize,
          deleteTargetWidth: other.deleteTargetWidth ?? deleteTargetWidth,
          minimumTapTargetSize:
              other.minimumTapTargetSize ?? minimumTapTargetSize,
          checkmarkIcon: other.checkmarkIcon ?? checkmarkIcon,
          checkmarkPlacement: other.checkmarkPlacement ?? checkmarkPlacement,
          checkmarkColor: other.checkmarkColor ?? checkmarkColor,
          selectedAvatarShape: other.selectedAvatarShape ?? selectedAvatarShape,
          selectedAvatarColor: other.selectedAvatarColor ?? selectedAvatarColor,
          checkmarkScale: other.checkmarkScale ?? checkmarkScale,
          deleteIcon: other.deleteIcon ?? deleteIcon,
          showCheckmark: other.showCheckmark ?? showCheckmark,
          textStyle: other.textStyle ?? textStyle,
          boxShadow: other.boxShadow ?? boxShadow,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperChipStyle lerp(HyperChipStyle a, HyperChipStyle b, double t) =>
      t == 0 || a == b
      ? a
      : t == 1
      ? b
      : HyperChipStyle(
          background: a.background == null || b.background == null
              ? (t < .5 ? a.background : b.background)
              : HyperFill.lerp(a.background!, b.background!, t),
          foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
          overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
          borderColor: Color.lerp(a.borderColor, b.borderColor, t),
          borderWidth: a.borderWidth == null || b.borderWidth == null
              ? (t < .5 ? a.borderWidth : b.borderWidth)
              : lerpDouble(a.borderWidth, b.borderWidth, t),
          height: a.height == null || b.height == null
              ? (t < .5 ? a.height : b.height)
              : lerpDouble(a.height, b.height, t),
          horizontalPadding:
              a.horizontalPadding == null || b.horizontalPadding == null
              ? (t < .5 ? a.horizontalPadding : b.horizontalPadding)
              : lerpDouble(a.horizontalPadding, b.horizontalPadding, t),
          radius: a.radius == null || b.radius == null
              ? (t < .5 ? a.radius : b.radius)
              : lerpDouble(a.radius, b.radius, t),
          iconSize: a.iconSize == null || b.iconSize == null
              ? (t < .5 ? a.iconSize : b.iconSize)
              : lerpDouble(a.iconSize, b.iconSize, t),
          avatarSize: a.avatarSize == null || b.avatarSize == null
              ? (t < .5 ? a.avatarSize : b.avatarSize)
              : lerpDouble(a.avatarSize, b.avatarSize, t),
          avatarOpacity: a.avatarOpacity == null || b.avatarOpacity == null
              ? (t < .5 ? a.avatarOpacity : b.avatarOpacity)
              : lerpDouble(a.avatarOpacity, b.avatarOpacity, t),
          iconSpacing: a.iconSpacing == null || b.iconSpacing == null
              ? (t < .5 ? a.iconSpacing : b.iconSpacing)
              : lerpDouble(a.iconSpacing, b.iconSpacing, t),
          deleteIconSize: a.deleteIconSize == null || b.deleteIconSize == null
              ? (t < .5 ? a.deleteIconSize : b.deleteIconSize)
              : lerpDouble(a.deleteIconSize, b.deleteIconSize, t),
          deleteTargetWidth:
              a.deleteTargetWidth == null || b.deleteTargetWidth == null
              ? (t < .5 ? a.deleteTargetWidth : b.deleteTargetWidth)
              : lerpDouble(a.deleteTargetWidth, b.deleteTargetWidth, t),
          minimumTapTargetSize:
              a.minimumTapTargetSize == null || b.minimumTapTargetSize == null
              ? (t < .5 ? a.minimumTapTargetSize : b.minimumTapTargetSize)
              : lerpDouble(a.minimumTapTargetSize, b.minimumTapTargetSize, t),
          checkmarkIcon: t < .5 ? a.checkmarkIcon : b.checkmarkIcon,
          checkmarkPlacement: t < .5
              ? a.checkmarkPlacement
              : b.checkmarkPlacement,
          checkmarkColor: Color.lerp(a.checkmarkColor, b.checkmarkColor, t),
          selectedAvatarShape: ShapeBorder.lerp(
            a.selectedAvatarShape,
            b.selectedAvatarShape,
            t,
          ),
          selectedAvatarColor: Color.lerp(
            a.selectedAvatarColor,
            b.selectedAvatarColor,
            t,
          ),
          checkmarkScale: a.checkmarkScale == null || b.checkmarkScale == null
              ? (t < .5 ? a.checkmarkScale : b.checkmarkScale)
              : lerpDouble(a.checkmarkScale, b.checkmarkScale, t),
          deleteIcon: t < .5 ? a.deleteIcon : b.deleteIcon,
          showCheckmark: t < .5 ? a.showCheckmark : b.showCheckmark,
          textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
          boxShadow: a.boxShadow == null && b.boxShadow == null
              ? null
              : BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
          duration: a.duration == null || b.duration == null
              ? (t < .5 ? a.duration : b.duration)
              : Duration(
                  microseconds:
                      (a.duration!.inMicroseconds +
                              (b.duration!.inMicroseconds -
                                      a.duration!.inMicroseconds) *
                                  t)
                          .round(),
                ),
          curve: t < .5 ? a.curve : b.curve,
          transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperChipStyle &&
      other.background == background &&
      other.foregroundColor == foregroundColor &&
      other.overlayColor == overlayColor &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.height == height &&
      other.horizontalPadding == horizontalPadding &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      other.avatarSize == avatarSize &&
      other.avatarOpacity == avatarOpacity &&
      other.iconSpacing == iconSpacing &&
      other.deleteIconSize == deleteIconSize &&
      other.deleteTargetWidth == deleteTargetWidth &&
      other.minimumTapTargetSize == minimumTapTargetSize &&
      other.checkmarkIcon == checkmarkIcon &&
      other.checkmarkPlacement == checkmarkPlacement &&
      other.checkmarkColor == checkmarkColor &&
      other.selectedAvatarShape == selectedAvatarShape &&
      other.selectedAvatarColor == selectedAvatarColor &&
      other.checkmarkScale == checkmarkScale &&
      other.deleteIcon == deleteIcon &&
      other.showCheckmark == showCheckmark &&
      other.textStyle == textStyle &&
      listEquals(other.boxShadow, boxShadow) &&
      other.duration == duration &&
      other.curve == curve &&
      other.transitionBuilder == transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    foregroundColor,
    overlayColor,
    borderColor,
    borderWidth,
    height,
    horizontalPadding,
    radius,
    iconSize,
    avatarSize,
    avatarOpacity,
    iconSpacing,
    deleteIconSize,
    deleteTargetWidth,
    minimumTapTargetSize,
    checkmarkIcon,
    checkmarkPlacement,
    checkmarkColor,
    selectedAvatarShape,
    selectedAvatarColor,
    checkmarkScale,
    deleteIcon,
    showCheckmark,
    textStyle,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    duration,
    curve,
    transitionBuilder,
  ]);
}
