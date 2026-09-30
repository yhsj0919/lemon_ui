import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

enum HyperAvatarBlendVariant { smooth, windmill }

@immutable
final class HyperAvatarStyle {
  const HyperAvatarStyle({
    this.size,
    this.groupSize,
    this.blendGradient,
    this.blendRotation,
    this.blendPetalRotation,
    this.blendPetalOpacity,
    this.blendSoftness,
    this.blendTintColor,
    this.blendVariant,
    this.blendShapeBorder,
    this.blendPadding,
    this.blendPetalBorder,
    this.blendPetalShadowColor,
    this.blendPetalShadowBlur,
    this.radius,
    this.iconSize,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.textStyle,
    this.imageFit,
    this.imageAlignment,
    this.overlap,
    this.spacing,
    this.ringWidth,
    this.ringColor,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final double? size;

  /// 头像组整体边界，组内布局按比例自适应。
  final Size? groupSize;

  /// 替换混色头像的默认 360 度渐变。
  final Gradient? blendGradient;
  final double? blendRotation;

  /// 每片水滴围绕自身大头中心的偏转角，单位为弧度。
  final double? blendPetalRotation;

  /// 水滴材质的透光程度对应的不透明度，1 为实色。
  final double? blendPetalOpacity;

  /// 主色向柔化色混合的比例，0 保留原色，1 使用柔化色。
  final double? blendSoftness;
  final Color? blendTintColor;
  final HyperAvatarBlendVariant? blendVariant;
  final ShapeBorder? blendShapeBorder;
  final double? blendPadding;
  final BorderSide? blendPetalBorder;
  final Color? blendPetalShadowColor;
  final double? blendPetalShadowBlur;
  final double? radius;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final TextStyle? textStyle;
  final BoxFit? imageFit;
  final AlignmentGeometry? imageAlignment;

  /// 相邻头像的重叠距离，单位为逻辑像素。
  /// 横向和纵向共用；0 为不重叠，数值越大堆叠越紧密。
  /// 指定 groupSize 后与组内布局一起等比缩放。
  final double? overlap;
  final double? spacing;
  final double? ringWidth;
  final Color? ringColor;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperAvatarStyle copyWith({
    double? size,
    Size? groupSize,
    Gradient? blendGradient,
    double? blendRotation,
    double? blendPetalRotation,
    double? blendPetalOpacity,
    double? blendSoftness,
    Color? blendTintColor,
    HyperAvatarBlendVariant? blendVariant,
    ShapeBorder? blendShapeBorder,
    double? blendPadding,
    BorderSide? blendPetalBorder,
    Color? blendPetalShadowColor,
    double? blendPetalShadowBlur,
    double? radius,
    double? iconSize,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    List<BoxShadow>? boxShadow,
    TextStyle? textStyle,
    BoxFit? imageFit,
    AlignmentGeometry? imageAlignment,
    double? overlap,
    double? spacing,
    double? ringWidth,
    Color? ringColor,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => merge(
    HyperAvatarStyle(
      size: size,
      groupSize: groupSize,
      blendGradient: blendGradient,
      blendRotation: blendRotation,
      blendPetalRotation: blendPetalRotation,
      blendPetalOpacity: blendPetalOpacity,
      blendSoftness: blendSoftness,
      blendTintColor: blendTintColor,
      blendVariant: blendVariant,
      blendShapeBorder: blendShapeBorder,
      blendPadding: blendPadding,
      blendPetalBorder: blendPetalBorder,
      blendPetalShadowColor: blendPetalShadowColor,
      blendPetalShadowBlur: blendPetalShadowBlur,
      radius: radius,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      boxShadow: boxShadow,
      textStyle: textStyle,
      imageFit: imageFit,
      imageAlignment: imageAlignment,
      overlap: overlap,
      spacing: spacing,
      ringWidth: ringWidth,
      ringColor: ringColor,
      duration: duration,
      curve: curve,
      transitionBuilder: transitionBuilder,
    ),
  );
  HyperAvatarStyle merge(HyperAvatarStyle? other) => other == null
      ? this
      : HyperAvatarStyle(
          size: other.size ?? size,
          groupSize: other.groupSize ?? groupSize,
          blendGradient: other.blendGradient ?? blendGradient,
          blendRotation: other.blendRotation ?? blendRotation,
          blendPetalRotation: other.blendPetalRotation ?? blendPetalRotation,
          blendPetalOpacity: other.blendPetalOpacity ?? blendPetalOpacity,
          blendSoftness: other.blendSoftness ?? blendSoftness,
          blendTintColor: other.blendTintColor ?? blendTintColor,
          blendVariant: other.blendVariant ?? blendVariant,
          blendShapeBorder: other.blendShapeBorder ?? blendShapeBorder,
          blendPadding: other.blendPadding ?? blendPadding,
          blendPetalBorder: other.blendPetalBorder ?? blendPetalBorder,
          blendPetalShadowColor:
              other.blendPetalShadowColor ?? blendPetalShadowColor,
          blendPetalShadowBlur:
              other.blendPetalShadowBlur ?? blendPetalShadowBlur,
          radius: other.radius ?? radius,
          iconSize: other.iconSize ?? iconSize,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          borderColor: other.borderColor ?? borderColor,
          borderWidth: other.borderWidth ?? borderWidth,
          boxShadow: other.boxShadow ?? boxShadow,
          textStyle: other.textStyle ?? textStyle,
          imageFit: other.imageFit ?? imageFit,
          imageAlignment: other.imageAlignment ?? imageAlignment,
          overlap: other.overlap ?? overlap,
          spacing: other.spacing ?? spacing,
          ringWidth: other.ringWidth ?? ringWidth,
          ringColor: other.ringColor ?? ringColor,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperAvatarStyle lerp(
    HyperAvatarStyle a,
    HyperAvatarStyle b,
    double t,
  ) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperAvatarStyle(
      size: number(a.size, b.size),
      groupSize: Size.lerp(a.groupSize, b.groupSize, t),
      blendGradient: Gradient.lerp(a.blendGradient, b.blendGradient, t),
      blendRotation: number(a.blendRotation, b.blendRotation),
      blendPetalRotation: number(a.blendPetalRotation, b.blendPetalRotation),
      blendPetalOpacity: number(a.blendPetalOpacity, b.blendPetalOpacity),
      blendSoftness: number(a.blendSoftness, b.blendSoftness),
      blendTintColor: Color.lerp(a.blendTintColor, b.blendTintColor, t),
      blendVariant: t < .5 ? a.blendVariant : b.blendVariant,
      blendShapeBorder: ShapeBorder.lerp(
        a.blendShapeBorder,
        b.blendShapeBorder,
        t,
      ),
      blendPadding: number(a.blendPadding, b.blendPadding),
      blendPetalShadowColor: Color.lerp(
        a.blendPetalShadowColor,
        b.blendPetalShadowColor,
        t,
      ),
      blendPetalShadowBlur: number(
        a.blendPetalShadowBlur,
        b.blendPetalShadowBlur,
      ),
      blendPetalBorder: a.blendPetalBorder == null || b.blendPetalBorder == null
          ? (t < .5 ? a.blendPetalBorder : b.blendPetalBorder)
          : BorderSide.lerp(a.blendPetalBorder!, b.blendPetalBorder!, t),
      radius: number(a.radius, b.radius),
      iconSize: number(a.iconSize, b.iconSize),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: number(a.borderWidth, b.borderWidth),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      imageFit: t < .5 ? a.imageFit : b.imageFit,
      imageAlignment: AlignmentGeometry.lerp(
        a.imageAlignment,
        b.imageAlignment,
        t,
      ),
      overlap: number(a.overlap, b.overlap),
      spacing: number(a.spacing, b.spacing),
      ringWidth: number(a.ringWidth, b.ringWidth),
      ringColor: Color.lerp(a.ringColor, b.ringColor, t),
      duration: t < .5 ? a.duration : b.duration,
      curve: t < .5 ? a.curve : b.curve,
      transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperAvatarStyle &&
      other.size == size &&
      other.groupSize == groupSize &&
      other.blendGradient == blendGradient &&
      other.blendRotation == blendRotation &&
      other.blendPetalRotation == blendPetalRotation &&
      other.blendPetalOpacity == blendPetalOpacity &&
      other.blendSoftness == blendSoftness &&
      other.blendTintColor == blendTintColor &&
      other.blendVariant == blendVariant &&
      other.blendShapeBorder == blendShapeBorder &&
      other.blendPadding == blendPadding &&
      other.blendPetalBorder == blendPetalBorder &&
      other.blendPetalShadowColor == blendPetalShadowColor &&
      other.blendPetalShadowBlur == blendPetalShadowBlur &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      other.backgroundColor == backgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      listEquals(other.boxShadow, boxShadow) &&
      other.textStyle == textStyle &&
      other.imageFit == imageFit &&
      other.imageAlignment == imageAlignment &&
      other.overlap == overlap &&
      other.spacing == spacing &&
      other.ringWidth == ringWidth &&
      other.ringColor == ringColor &&
      other.duration == duration &&
      other.curve == curve &&
      other.transitionBuilder == transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    size,
    groupSize,
    blendGradient,
    blendRotation,
    blendPetalRotation,
    blendPetalOpacity,
    blendSoftness,
    blendTintColor,
    blendVariant,
    blendShapeBorder,
    blendPadding,
    blendPetalBorder,
    blendPetalShadowColor,
    blendPetalShadowBlur,
    radius,
    iconSize,
    backgroundColor,
    foregroundColor,
    borderColor,
    borderWidth,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    textStyle,
    imageFit,
    imageAlignment,
    overlap,
    spacing,
    ringWidth,
    ringColor,
    duration,
    curve,
    transitionBuilder,
  ]);
}
