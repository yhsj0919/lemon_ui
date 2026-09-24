import 'package:flutter/widgets.dart';

/// 当前设备的 HyperCard 布局规格。
@immutable
final class HyperCardSize {
  const HyperCardSize({
    required this.padding,
    required this.radius,
    required this.titlePadding,
    required this.titleSpacing,
    required this.outsideTitlePadding,
    required this.outsideTitleSpacing,
    required this.actionSpacing,
  });

  final EdgeInsetsGeometry padding;
  final double radius;

  /// 卡片内标题的边距与到内容的距离。
  final EdgeInsetsGeometry titlePadding;
  final double titleSpacing;

  /// 卡片外标题的边距与到卡片表面的距离。
  final EdgeInsetsGeometry outsideTitlePadding;
  final double outsideTitleSpacing;
  final double actionSpacing;

  HyperCardSize copyWith({
    EdgeInsetsGeometry? padding,
    double? radius,
    EdgeInsetsGeometry? titlePadding,
    double? titleSpacing,
    EdgeInsetsGeometry? outsideTitlePadding,
    double? outsideTitleSpacing,
    double? actionSpacing,
  }) => HyperCardSize(
    padding: padding ?? this.padding,
    radius: radius ?? this.radius,
    titlePadding: titlePadding ?? this.titlePadding,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    outsideTitlePadding: outsideTitlePadding ?? this.outsideTitlePadding,
    outsideTitleSpacing: outsideTitleSpacing ?? this.outsideTitleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
  );

  static HyperCardSize lerp(
    HyperCardSize a,
    HyperCardSize b,
    double t,
  ) => HyperCardSize(
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    radius: a.radius + (b.radius - a.radius) * t,
    titlePadding: EdgeInsetsGeometry.lerp(a.titlePadding, b.titlePadding, t)!,
    titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
    outsideTitlePadding: EdgeInsetsGeometry.lerp(
      a.outsideTitlePadding,
      b.outsideTitlePadding,
      t,
    )!,
    outsideTitleSpacing:
        a.outsideTitleSpacing +
        (b.outsideTitleSpacing - a.outsideTitleSpacing) * t,
    actionSpacing: a.actionSpacing + (b.actionSpacing - a.actionSpacing) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperCardSize &&
      other.padding == padding &&
      other.radius == radius &&
      other.titlePadding == titlePadding &&
      other.titleSpacing == titleSpacing &&
      other.outsideTitlePadding == outsideTitlePadding &&
      other.outsideTitleSpacing == outsideTitleSpacing &&
      other.actionSpacing == actionSpacing;

  @override
  int get hashCode => Object.hash(
    padding,
    radius,
    titlePadding,
    titleSpacing,
    outsideTitlePadding,
    outsideTitleSpacing,
    actionSpacing,
  );
}
