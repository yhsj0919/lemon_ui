import 'package:flutter/foundation.dart';

@immutable
final class HyperTextFieldSize {
  const HyperTextFieldSize({
    required this.minimumHeight,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.radius,
    required this.iconSize,
    required this.actionWidth,
    required this.labelGap,
    required this.errorMaxWidth,
  });
  final double minimumHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double radius;
  final double iconSize;
  final double actionWidth;
  final double labelGap;
  final double errorMaxWidth;
  HyperTextFieldSize copyWith({
    double? minimumHeight,
    double? horizontalPadding,
    double? verticalPadding,
    double? radius,
    double? iconSize,
    double? actionWidth,
    double? labelGap,
    double? errorMaxWidth,
  }) => HyperTextFieldSize(
    minimumHeight: minimumHeight ?? this.minimumHeight,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    verticalPadding: verticalPadding ?? this.verticalPadding,
    radius: radius ?? this.radius,
    iconSize: iconSize ?? this.iconSize,
    actionWidth: actionWidth ?? this.actionWidth,
    labelGap: labelGap ?? this.labelGap,
    errorMaxWidth: errorMaxWidth ?? this.errorMaxWidth,
  );
  static HyperTextFieldSize lerp(
    HyperTextFieldSize a,
    HyperTextFieldSize b,
    double t,
  ) => HyperTextFieldSize(
    minimumHeight: a.minimumHeight + (b.minimumHeight - a.minimumHeight) * t,
    horizontalPadding:
        a.horizontalPadding + (b.horizontalPadding - a.horizontalPadding) * t,
    verticalPadding:
        a.verticalPadding + (b.verticalPadding - a.verticalPadding) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    actionWidth: a.actionWidth + (b.actionWidth - a.actionWidth) * t,
    labelGap: a.labelGap + (b.labelGap - a.labelGap) * t,
    errorMaxWidth: a.errorMaxWidth + (b.errorMaxWidth - a.errorMaxWidth) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTextFieldSize &&
      minimumHeight == other.minimumHeight &&
      horizontalPadding == other.horizontalPadding &&
      verticalPadding == other.verticalPadding &&
      radius == other.radius &&
      iconSize == other.iconSize &&
      actionWidth == other.actionWidth &&
      labelGap == other.labelGap &&
      errorMaxWidth == other.errorMaxWidth;
  @override
  int get hashCode => Object.hashAll([
    minimumHeight,
    horizontalPadding,
    verticalPadding,
    radius,
    iconSize,
    actionWidth,
    labelGap,
    errorMaxWidth,
  ]);
}
