import 'package:flutter/foundation.dart';

/// 当前设备的交互标签尺寸，单位为逻辑像素。
@immutable
final class HyperChipSize {
  const HyperChipSize({
    required this.height,
    required this.horizontalPadding,
    required this.radius,
    required this.iconSize,
    required this.iconSpacing,
    required this.avatarSize,
    required this.deleteIconSize,
    required this.deleteTargetWidth,
  });

  final double height;
  final double horizontalPadding;
  final double radius;
  final double iconSize;
  final double iconSpacing;
  final double avatarSize, deleteIconSize, deleteTargetWidth;

  HyperChipSize copyWith({
    double? height,
    double? horizontalPadding,
    double? radius,
    double? iconSize,
    double? iconSpacing,
    double? avatarSize,
    double? deleteIconSize,
    double? deleteTargetWidth,
  }) => HyperChipSize(
    height: height ?? this.height,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    radius: radius ?? this.radius,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    avatarSize: avatarSize ?? this.avatarSize,
    deleteIconSize: deleteIconSize ?? this.deleteIconSize,
    deleteTargetWidth: deleteTargetWidth ?? this.deleteTargetWidth,
  );

  static HyperChipSize lerp(
    HyperChipSize a,
    HyperChipSize b,
    double t,
  ) => HyperChipSize(
    height: a.height + (b.height - a.height) * t,
    horizontalPadding:
        a.horizontalPadding + (b.horizontalPadding - a.horizontalPadding) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    iconSpacing: a.iconSpacing + (b.iconSpacing - a.iconSpacing) * t,
    avatarSize: a.avatarSize + (b.avatarSize - a.avatarSize) * t,
    deleteIconSize:
        a.deleteIconSize + (b.deleteIconSize - a.deleteIconSize) * t,
    deleteTargetWidth:
        a.deleteTargetWidth + (b.deleteTargetWidth - a.deleteTargetWidth) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperChipSize &&
      other.height == height &&
      other.horizontalPadding == horizontalPadding &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing &&
      other.avatarSize == avatarSize &&
      other.deleteIconSize == deleteIconSize &&
      other.deleteTargetWidth == deleteTargetWidth;

  @override
  int get hashCode => Object.hash(
    height,
    horizontalPadding,
    radius,
    iconSize,
    iconSpacing,
    avatarSize,
    deleteIconSize,
    deleteTargetWidth,
  );
}
