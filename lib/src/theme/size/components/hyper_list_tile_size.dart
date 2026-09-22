import 'package:flutter/widgets.dart';

/// 当前设备的 HyperListTile 布局规格。
@immutable
final class HyperListTileSize {
  const HyperListTileSize({
    required this.minHeight,
    required this.compactMinHeight,
    required this.subtitleMinHeight,
    required this.compactSubtitleMinHeight,
    required this.padding,
    required this.compactPadding,
    required this.leadingSize,
    required this.leadingSpacing,
    required this.trailingSpacing,
    required this.trailingIconSize,
    required this.navigationSpacing,
    required this.navigationIconSize,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.titleLineHeight,
    required this.subtitleLineHeight,
  });

  final double minHeight;
  final double compactMinHeight;
  final double subtitleMinHeight;
  final double compactSubtitleMinHeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry compactPadding;
  final double leadingSize;
  final double leadingSpacing;
  final double trailingSpacing;
  final double trailingIconSize;

  /// 导航描述与箭头的间距，以及导航箭头尺寸。
  final double navigationSpacing;
  final double navigationIconSize;
  final double titleFontSize;
  final double subtitleFontSize;
  final double titleLineHeight;
  final double subtitleLineHeight;

  HyperListTileSize copyWith({
    double? minHeight,
    double? compactMinHeight,
    double? subtitleMinHeight,
    double? compactSubtitleMinHeight,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? compactPadding,
    double? leadingSize,
    double? leadingSpacing,
    double? trailingSpacing,
    double? trailingIconSize,
    double? navigationSpacing,
    double? navigationIconSize,
    double? titleFontSize,
    double? subtitleFontSize,
    double? titleLineHeight,
    double? subtitleLineHeight,
  }) => HyperListTileSize(
    minHeight: minHeight ?? this.minHeight,
    compactMinHeight: compactMinHeight ?? this.compactMinHeight,
    subtitleMinHeight: subtitleMinHeight ?? this.subtitleMinHeight,
    compactSubtitleMinHeight:
        compactSubtitleMinHeight ?? this.compactSubtitleMinHeight,
    padding: padding ?? this.padding,
    compactPadding: compactPadding ?? this.compactPadding,
    leadingSize: leadingSize ?? this.leadingSize,
    leadingSpacing: leadingSpacing ?? this.leadingSpacing,
    trailingSpacing: trailingSpacing ?? this.trailingSpacing,
    trailingIconSize: trailingIconSize ?? this.trailingIconSize,
    navigationSpacing: navigationSpacing ?? this.navigationSpacing,
    navigationIconSize: navigationIconSize ?? this.navigationIconSize,
    titleFontSize: titleFontSize ?? this.titleFontSize,
    subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
    titleLineHeight: titleLineHeight ?? this.titleLineHeight,
    subtitleLineHeight: subtitleLineHeight ?? this.subtitleLineHeight,
  );

  static HyperListTileSize lerp(
    HyperListTileSize a,
    HyperListTileSize b,
    double t,
  ) => HyperListTileSize(
    minHeight: a.minHeight + (b.minHeight - a.minHeight) * t,
    compactMinHeight:
        a.compactMinHeight + (b.compactMinHeight - a.compactMinHeight) * t,
    subtitleMinHeight:
        a.subtitleMinHeight + (b.subtitleMinHeight - a.subtitleMinHeight) * t,
    compactSubtitleMinHeight:
        a.compactSubtitleMinHeight +
        (b.compactSubtitleMinHeight - a.compactSubtitleMinHeight) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    compactPadding: EdgeInsetsGeometry.lerp(
      a.compactPadding,
      b.compactPadding,
      t,
    )!,
    leadingSize: a.leadingSize + (b.leadingSize - a.leadingSize) * t,
    leadingSpacing:
        a.leadingSpacing + (b.leadingSpacing - a.leadingSpacing) * t,
    trailingSpacing:
        a.trailingSpacing + (b.trailingSpacing - a.trailingSpacing) * t,
    trailingIconSize:
        a.trailingIconSize + (b.trailingIconSize - a.trailingIconSize) * t,
    navigationSpacing:
        a.navigationSpacing + (b.navigationSpacing - a.navigationSpacing) * t,
    navigationIconSize:
        a.navigationIconSize +
        (b.navigationIconSize - a.navigationIconSize) * t,
    titleFontSize: a.titleFontSize + (b.titleFontSize - a.titleFontSize) * t,
    subtitleFontSize:
        a.subtitleFontSize + (b.subtitleFontSize - a.subtitleFontSize) * t,
    titleLineHeight:
        a.titleLineHeight + (b.titleLineHeight - a.titleLineHeight) * t,
    subtitleLineHeight:
        a.subtitleLineHeight +
        (b.subtitleLineHeight - a.subtitleLineHeight) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperListTileSize &&
      other.minHeight == minHeight &&
      other.compactMinHeight == compactMinHeight &&
      other.subtitleMinHeight == subtitleMinHeight &&
      other.compactSubtitleMinHeight == compactSubtitleMinHeight &&
      other.padding == padding &&
      other.compactPadding == compactPadding &&
      other.leadingSize == leadingSize &&
      other.leadingSpacing == leadingSpacing &&
      other.trailingSpacing == trailingSpacing &&
      other.trailingIconSize == trailingIconSize &&
      other.navigationSpacing == navigationSpacing &&
      other.navigationIconSize == navigationIconSize &&
      other.titleFontSize == titleFontSize &&
      other.subtitleFontSize == subtitleFontSize &&
      other.titleLineHeight == titleLineHeight &&
      other.subtitleLineHeight == subtitleLineHeight;

  @override
  int get hashCode => Object.hash(
    minHeight,
    compactMinHeight,
    subtitleMinHeight,
    compactSubtitleMinHeight,
    padding,
    compactPadding,
    leadingSize,
    leadingSpacing,
    trailingSpacing,
    trailingIconSize,
    navigationSpacing,
    navigationIconSize,
    titleFontSize,
    subtitleFontSize,
    titleLineHeight,
    subtitleLineHeight,
  );
}
