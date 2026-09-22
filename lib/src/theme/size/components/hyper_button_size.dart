import 'package:flutter/widgets.dart';

/// 当前设备的 HyperButton 尺寸与输入方式规格。
@immutable
final class HyperButtonSize {
  const HyperButtonSize({
    required this.minimumSize,
    required this.padding,
    required this.radius,
    required this.fontSize,
    required this.iconSize,
    required this.iconSpacing,
    required this.progressSize,
    required this.hoverOverlayOpacity,
    required this.focusOverlayOpacity,
    required this.pressOverlayOpacity,
  });

  final Size minimumSize;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double fontSize;
  final double iconSize;
  final double iconSpacing;
  final double progressSize;
  final double hoverOverlayOpacity;
  final double focusOverlayOpacity;
  final double pressOverlayOpacity;

  HyperButtonSize copyWith({
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? radius,
    double? fontSize,
    double? iconSize,
    double? iconSpacing,
    double? progressSize,
    double? hoverOverlayOpacity,
    double? focusOverlayOpacity,
    double? pressOverlayOpacity,
  }) => HyperButtonSize(
    minimumSize: minimumSize ?? this.minimumSize,
    padding: padding ?? this.padding,
    radius: radius ?? this.radius,
    fontSize: fontSize ?? this.fontSize,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    progressSize: progressSize ?? this.progressSize,
    hoverOverlayOpacity: hoverOverlayOpacity ?? this.hoverOverlayOpacity,
    focusOverlayOpacity: focusOverlayOpacity ?? this.focusOverlayOpacity,
    pressOverlayOpacity: pressOverlayOpacity ?? this.pressOverlayOpacity,
  );

  static HyperButtonSize lerp(HyperButtonSize a, HyperButtonSize b, double t) {
    double value(double x, double y) => x + (y - x) * t;
    return HyperButtonSize(
      minimumSize: Size.lerp(a.minimumSize, b.minimumSize, t)!,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
      radius: value(a.radius, b.radius),
      fontSize: value(a.fontSize, b.fontSize),
      iconSize: value(a.iconSize, b.iconSize),
      iconSpacing: value(a.iconSpacing, b.iconSpacing),
      progressSize: value(a.progressSize, b.progressSize),
      hoverOverlayOpacity: value(a.hoverOverlayOpacity, b.hoverOverlayOpacity),
      focusOverlayOpacity: value(a.focusOverlayOpacity, b.focusOverlayOpacity),
      pressOverlayOpacity: value(a.pressOverlayOpacity, b.pressOverlayOpacity),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperButtonSize &&
          other.minimumSize == minimumSize &&
          other.padding == padding &&
          other.radius == radius &&
          other.fontSize == fontSize &&
          other.iconSize == iconSize &&
          other.iconSpacing == iconSpacing &&
          other.progressSize == progressSize &&
          other.hoverOverlayOpacity == hoverOverlayOpacity &&
          other.focusOverlayOpacity == focusOverlayOpacity &&
          other.pressOverlayOpacity == pressOverlayOpacity;

  @override
  int get hashCode => Object.hash(
    minimumSize,
    padding,
    radius,
    fontSize,
    iconSize,
    iconSpacing,
    progressSize,
    hoverOverlayOpacity,
    focusOverlayOpacity,
    pressOverlayOpacity,
  );
}
