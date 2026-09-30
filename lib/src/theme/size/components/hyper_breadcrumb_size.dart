import 'package:flutter/foundation.dart';

/// 当前设备的面包屑胶囊和分隔箭头尺寸。
@immutable
final class HyperBreadcrumbSize {
  const HyperBreadcrumbSize({
    required this.itemHeight,
    required this.itemHorizontalPadding,
    required this.itemMaxWidth,
    required this.separatorSize,
    required this.separatorSpacing,
  });

  final double itemHeight;
  final double itemHorizontalPadding;
  final double itemMaxWidth;
  final double separatorSize;
  final double separatorSpacing;

  HyperBreadcrumbSize copyWith({
    double? itemHeight,
    double? itemHorizontalPadding,
    double? itemMaxWidth,
    double? separatorSize,
    double? separatorSpacing,
  }) => HyperBreadcrumbSize(
    itemHeight: itemHeight ?? this.itemHeight,
    itemHorizontalPadding: itemHorizontalPadding ?? this.itemHorizontalPadding,
    itemMaxWidth: itemMaxWidth ?? this.itemMaxWidth,
    separatorSize: separatorSize ?? this.separatorSize,
    separatorSpacing: separatorSpacing ?? this.separatorSpacing,
  );

  static HyperBreadcrumbSize lerp(
    HyperBreadcrumbSize a,
    HyperBreadcrumbSize b,
    double t,
  ) => HyperBreadcrumbSize(
    itemHeight: a.itemHeight + (b.itemHeight - a.itemHeight) * t,
    itemHorizontalPadding:
        a.itemHorizontalPadding +
        (b.itemHorizontalPadding - a.itemHorizontalPadding) * t,
    itemMaxWidth: a.itemMaxWidth + (b.itemMaxWidth - a.itemMaxWidth) * t,
    separatorSize: a.separatorSize + (b.separatorSize - a.separatorSize) * t,
    separatorSpacing:
        a.separatorSpacing + (b.separatorSpacing - a.separatorSpacing) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperBreadcrumbSize &&
      other.itemHeight == itemHeight &&
      other.itemHorizontalPadding == itemHorizontalPadding &&
      other.itemMaxWidth == itemMaxWidth &&
      other.separatorSize == separatorSize &&
      other.separatorSpacing == separatorSpacing;

  @override
  int get hashCode => Object.hash(
    itemHeight,
    itemHorizontalPadding,
    itemMaxWidth,
    separatorSize,
    separatorSpacing,
  );
}
