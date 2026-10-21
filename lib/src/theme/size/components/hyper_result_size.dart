import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

@immutable
final class HyperResultSize {
  const HyperResultSize({
    required this.iconSize,
    required this.illustrationSize,
    required this.maxWidth,
    required this.contentSpacing,
    required this.titleSpacing,
    required this.actionSpacing,
    required this.actionRunSpacing,
    required this.padding,
    // Named variant arguments stay public while storage remains optional.
    HyperResultSize? empty,
    // ignore: prefer_initializing_formals
  }) : _empty = empty;
  final HyperResultSize? _empty;

  /// 此形态的尺寸；未覆盖时继承当前规格。
  HyperResultSize get empty => _empty ?? this;

  final double iconSize,
      illustrationSize,
      maxWidth,
      contentSpacing,
      titleSpacing,
      actionSpacing,
      actionRunSpacing;
  final EdgeInsetsGeometry padding;
  HyperResultSize copyWith({
    double? iconSize,
    double? illustrationSize,
    double? maxWidth,
    double? contentSpacing,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    EdgeInsetsGeometry? padding,
    HyperResultSize? empty,
  }) => HyperResultSize(
    empty: empty ?? _empty,
    iconSize: iconSize ?? this.iconSize,
    illustrationSize: illustrationSize ?? this.illustrationSize,
    maxWidth: maxWidth ?? this.maxWidth,
    contentSpacing: contentSpacing ?? this.contentSpacing,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
    padding: padding ?? this.padding,
  );
  static HyperResultSize lerp(HyperResultSize a, HyperResultSize b, double t) =>
      t == 0
      ? a
      : t == 1
      ? b
      : HyperResultSize(
          empty: a._empty == null && b._empty == null
              ? null
              : HyperResultSize.lerp(a.empty, b.empty, t),
          iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
          illustrationSize:
              a.illustrationSize +
              (b.illustrationSize - a.illustrationSize) * t,
          maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
          contentSpacing:
              a.contentSpacing + (b.contentSpacing - a.contentSpacing) * t,
          titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
          actionSpacing:
              a.actionSpacing + (b.actionSpacing - a.actionSpacing) * t,
          actionRunSpacing:
              a.actionRunSpacing +
              (b.actionRunSpacing - a.actionRunSpacing) * t,
          padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperResultSize &&
      other._empty == _empty &&
      other.iconSize == iconSize &&
      other.illustrationSize == illustrationSize &&
      other.maxWidth == maxWidth &&
      other.contentSpacing == contentSpacing &&
      other.titleSpacing == titleSpacing &&
      other.actionSpacing == actionSpacing &&
      other.actionRunSpacing == actionRunSpacing &&
      other.padding == padding;
  @override
  int get hashCode => Object.hash(
    _empty,
    iconSize,
    illustrationSize,
    maxWidth,
    contentSpacing,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    padding,
  );
}
