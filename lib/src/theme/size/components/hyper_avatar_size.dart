import 'package:flutter/widgets.dart';

enum HyperAvatarSizeVariant { small, medium, large }

@immutable
final class HyperAvatarSize {
  const HyperAvatarSize({
    required this.small,
    required this.medium,
    required this.large,
    required this.radius,
    required this.iconSize,
    required this.overlap,
    this.spacing = 4,
    required this.ringWidth,
  });
  final double small, medium, large, radius, iconSize, overlap, ringWidth;
  final double spacing;
  double sizeFor(HyperAvatarSizeVariant size) => switch (size) {
    HyperAvatarSizeVariant.small => small,
    HyperAvatarSizeVariant.medium => medium,
    HyperAvatarSizeVariant.large => large,
  };
  HyperAvatarSize copyWith({
    double? small,
    double? medium,
    double? large,
    double? radius,
    double? iconSize,
    double? overlap,
    double? spacing,
    double? ringWidth,
  }) => HyperAvatarSize(
    small: small ?? this.small,
    medium: medium ?? this.medium,
    large: large ?? this.large,
    radius: radius ?? this.radius,
    iconSize: iconSize ?? this.iconSize,
    overlap: overlap ?? this.overlap,
    spacing: spacing ?? this.spacing,
    ringWidth: ringWidth ?? this.ringWidth,
  );
  static HyperAvatarSize lerp(HyperAvatarSize a, HyperAvatarSize b, double t) =>
      HyperAvatarSize(
        small: a.small + (b.small - a.small) * t,
        medium: a.medium + (b.medium - a.medium) * t,
        large: a.large + (b.large - a.large) * t,
        radius: a.radius + (b.radius - a.radius) * t,
        iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
        overlap: a.overlap + (b.overlap - a.overlap) * t,
        spacing: a.spacing + (b.spacing - a.spacing) * t,
        ringWidth: a.ringWidth + (b.ringWidth - a.ringWidth) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperAvatarSize &&
      other.small == small &&
      other.medium == medium &&
      other.large == large &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      other.overlap == overlap &&
      other.spacing == spacing &&
      other.ringWidth == ringWidth;
  @override
  int get hashCode => Object.hash(
    small,
    medium,
    large,
    radius,
    iconSize,
    overlap,
    ringWidth,
    spacing,
  );
}
