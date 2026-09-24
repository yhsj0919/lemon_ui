import 'package:flutter/widgets.dart';

/// 按钮的视觉尺寸档位；具体数值由当前设备的尺寸主题提供。
enum HyperButtonSizeVariant { small, medium, large }

/// 当前设备的 HyperButton 尺寸与输入方式规格。
@immutable
final class HyperButtonSize {
  const HyperButtonSize({
    required this.minimumSize,
    required this.smallHeight,
    required this.largeHeight,
    required this.padding,
    required this.smallPadding,
    required this.largePadding,
    required this.radius,
    required this.iconSize,
    required this.iconSpacing,
    required this.progressSize,
    required this.hoverOverlayOpacity,
    required this.focusOverlayOpacity,
    required this.pressOverlayOpacity,
  });

  final Size minimumSize;
  final double smallHeight;
  final double largeHeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry smallPadding;
  final EdgeInsetsGeometry largePadding;
  final double radius;
  final double iconSize;
  final double iconSpacing;
  final double progressSize;
  final double hoverOverlayOpacity;
  final double focusOverlayOpacity;
  final double pressOverlayOpacity;

  double heightFor(HyperButtonSizeVariant size) => switch (size) {
    HyperButtonSizeVariant.small => smallHeight,
    HyperButtonSizeVariant.medium => minimumSize.height,
    HyperButtonSizeVariant.large => largeHeight,
  };

  EdgeInsetsGeometry paddingFor(HyperButtonSizeVariant size) => switch (size) {
    HyperButtonSizeVariant.small => smallPadding,
    HyperButtonSizeVariant.medium => padding,
    HyperButtonSizeVariant.large => largePadding,
  };

  HyperButtonSize copyWith({
    Size? minimumSize,
    double? smallHeight,
    double? largeHeight,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? smallPadding,
    EdgeInsetsGeometry? largePadding,
    double? radius,
    double? iconSize,
    double? iconSpacing,
    double? progressSize,
    double? hoverOverlayOpacity,
    double? focusOverlayOpacity,
    double? pressOverlayOpacity,
  }) => HyperButtonSize(
    minimumSize: minimumSize ?? this.minimumSize,
    smallHeight: smallHeight ?? this.smallHeight,
    largeHeight: largeHeight ?? this.largeHeight,
    padding: padding ?? this.padding,
    smallPadding: smallPadding ?? this.smallPadding,
    largePadding: largePadding ?? this.largePadding,
    radius: radius ?? this.radius,
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
      smallHeight: value(a.smallHeight, b.smallHeight),
      largeHeight: value(a.largeHeight, b.largeHeight),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
      smallPadding: EdgeInsetsGeometry.lerp(a.smallPadding, b.smallPadding, t)!,
      largePadding: EdgeInsetsGeometry.lerp(a.largePadding, b.largePadding, t)!,
      radius: value(a.radius, b.radius),
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
          other.smallHeight == smallHeight &&
          other.largeHeight == largeHeight &&
          other.padding == padding &&
          other.smallPadding == smallPadding &&
          other.largePadding == largePadding &&
          other.radius == radius &&
          other.iconSize == iconSize &&
          other.iconSpacing == iconSpacing &&
          other.progressSize == progressSize &&
          other.hoverOverlayOpacity == hoverOverlayOpacity &&
          other.focusOverlayOpacity == focusOverlayOpacity &&
          other.pressOverlayOpacity == pressOverlayOpacity;

  @override
  int get hashCode => Object.hash(
    minimumSize,
    smallHeight,
    largeHeight,
    padding,
    smallPadding,
    largePadding,
    radius,
    iconSize,
    iconSpacing,
    progressSize,
    hoverOverlayOpacity,
    focusOverlayOpacity,
    pressOverlayOpacity,
  );
}
