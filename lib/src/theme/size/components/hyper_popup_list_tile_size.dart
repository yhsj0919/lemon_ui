import 'package:flutter/foundation.dart';

/// 当前端列表项选项浮窗的自适应宽度边界。
@immutable
final class HyperPopupListTileSize {
  const HyperPopupListTileSize({
    required this.minWidth,
    required this.maxWidth,
    required this.itemHorizontalPadding,
  });

  final double minWidth;
  final double maxWidth;

  /// 选项文字到弹窗边缘的水平距离。
  final double itemHorizontalPadding;

  HyperPopupListTileSize copyWith({
    double? minWidth,
    double? maxWidth,
    double? itemHorizontalPadding,
  }) => HyperPopupListTileSize(
    minWidth: minWidth ?? this.minWidth,
    maxWidth: maxWidth ?? this.maxWidth,
    itemHorizontalPadding: itemHorizontalPadding ?? this.itemHorizontalPadding,
  );

  static HyperPopupListTileSize lerp(
    HyperPopupListTileSize a,
    HyperPopupListTileSize b,
    double t,
  ) => HyperPopupListTileSize(
    minWidth: a.minWidth + (b.minWidth - a.minWidth) * t,
    maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
    itemHorizontalPadding:
        a.itemHorizontalPadding +
        (b.itemHorizontalPadding - a.itemHorizontalPadding) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperPopupListTileSize &&
      other.minWidth == minWidth &&
      other.maxWidth == maxWidth &&
      other.itemHorizontalPadding == itemHorizontalPadding;

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, itemHorizontalPadding);
}
