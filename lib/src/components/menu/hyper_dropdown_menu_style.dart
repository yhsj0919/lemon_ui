import 'package:flutter/material.dart';

/// 下拉选择器自身的尺寸和视觉覆盖；空字段继续继承。
@immutable
final class HyperDropdownMenuStyle {
  const HyperDropdownMenuStyle({
    this.width,
    this.arrowSize,
    this.arrowSpacing,
    this.popupSpacing,
    this.foregroundColor,
    this.arrowColor,
    this.disabledArrowColor,
    this.selectedBackgroundColor,
  });

  final double? width;
  final double? arrowSize;
  final double? arrowSpacing;
  final double? popupSpacing;
  final Color? foregroundColor;
  final Color? arrowColor;
  final Color? disabledArrowColor;
  final Color? selectedBackgroundColor;

  HyperDropdownMenuStyle copyWith({
    double? width,
    double? arrowSize,
    double? arrowSpacing,
    double? popupSpacing,
    Color? foregroundColor,
    Color? arrowColor,
    Color? disabledArrowColor,
    Color? selectedBackgroundColor,
  }) => merge(
    HyperDropdownMenuStyle(
      width: width,
      arrowSize: arrowSize,
      arrowSpacing: arrowSpacing,
      popupSpacing: popupSpacing,
      foregroundColor: foregroundColor,
      arrowColor: arrowColor,
      disabledArrowColor: disabledArrowColor,
      selectedBackgroundColor: selectedBackgroundColor,
    ),
  );

  HyperDropdownMenuStyle merge(HyperDropdownMenuStyle? other) => other == null
      ? this
      : HyperDropdownMenuStyle(
          width: other.width ?? width,
          arrowSize: other.arrowSize ?? arrowSize,
          arrowSpacing: other.arrowSpacing ?? arrowSpacing,
          popupSpacing: other.popupSpacing ?? popupSpacing,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          arrowColor: other.arrowColor ?? arrowColor,
          disabledArrowColor: other.disabledArrowColor ?? disabledArrowColor,
          selectedBackgroundColor:
              other.selectedBackgroundColor ?? selectedBackgroundColor,
        );

  static HyperDropdownMenuStyle lerp(
    HyperDropdownMenuStyle a,
    HyperDropdownMenuStyle b,
    double t,
  ) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperDropdownMenuStyle(
      width: number(a.width, b.width),
      arrowSize: number(a.arrowSize, b.arrowSize),
      arrowSpacing: number(a.arrowSpacing, b.arrowSpacing),
      popupSpacing: number(a.popupSpacing, b.popupSpacing),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      arrowColor: Color.lerp(a.arrowColor, b.arrowColor, t),
      disabledArrowColor: Color.lerp(
        a.disabledArrowColor,
        b.disabledArrowColor,
        t,
      ),
      selectedBackgroundColor: Color.lerp(
        a.selectedBackgroundColor,
        b.selectedBackgroundColor,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperDropdownMenuStyle &&
      other.width == width &&
      other.arrowSize == arrowSize &&
      other.arrowSpacing == arrowSpacing &&
      other.popupSpacing == popupSpacing &&
      other.foregroundColor == foregroundColor &&
      other.arrowColor == arrowColor &&
      other.disabledArrowColor == disabledArrowColor &&
      other.selectedBackgroundColor == selectedBackgroundColor;

  @override
  int get hashCode => Object.hash(
    width,
    arrowSize,
    arrowSpacing,
    popupSpacing,
    foregroundColor,
    arrowColor,
    disabledArrowColor,
    selectedBackgroundColor,
  );
}
