import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_style.dart';

/// 所有基础进度形态共用的全局或局部主题。
@immutable
final class HyperProgressThemeData {
  const HyperProgressThemeData({
    this.style = const HyperProgressStyle(),
    this.linearStyle = const HyperProgressStyle(),
    this.circularStyle = const HyperProgressStyle(),
    this.infiniteStyle = const HyperProgressStyle(),
  });

  /// 线性和圆形进度共同继承的属性。
  final HyperProgressStyle style;

  /// 只覆盖线性进度的属性。
  final HyperProgressStyle linearStyle;

  /// 只覆盖圆形进度的属性。
  final HyperProgressStyle circularStyle;

  /// 只覆盖无限进度指示器的属性。
  final HyperProgressStyle infiniteStyle;

  HyperProgressThemeData copyWith({
    HyperProgressStyle? style,
    HyperProgressStyle? linearStyle,
    HyperProgressStyle? circularStyle,
    HyperProgressStyle? infiniteStyle,
  }) => HyperProgressThemeData(
    style: style ?? this.style,
    linearStyle: linearStyle ?? this.linearStyle,
    circularStyle: circularStyle ?? this.circularStyle,
    infiniteStyle: infiniteStyle ?? this.infiniteStyle,
  );

  HyperProgressThemeData merge(HyperProgressThemeData? other) {
    if (other == null) return this;
    return HyperProgressThemeData(
      style: style.merge(other.style),
      linearStyle: linearStyle.merge(other.linearStyle),
      circularStyle: circularStyle.merge(other.circularStyle),
      infiniteStyle: infiniteStyle.merge(other.infiniteStyle),
    );
  }

  static HyperProgressThemeData lerp(
    HyperProgressThemeData a,
    HyperProgressThemeData b,
    double t,
  ) => HyperProgressThemeData(
    style: HyperProgressStyle.lerp(a.style, b.style, t),
    linearStyle: HyperProgressStyle.lerp(a.linearStyle, b.linearStyle, t),
    circularStyle: HyperProgressStyle.lerp(a.circularStyle, b.circularStyle, t),
    infiniteStyle: HyperProgressStyle.lerp(a.infiniteStyle, b.infiniteStyle, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperProgressThemeData &&
          other.style == style &&
          other.linearStyle == linearStyle &&
          other.circularStyle == circularStyle &&
          other.infiniteStyle == infiniteStyle;

  @override
  int get hashCode =>
      Object.hash(style, linearStyle, circularStyle, infiniteStyle);
}

/// 仅覆盖当前子树进度主题的轻量作用域。
class HyperProgressTheme extends StatelessWidget {
  const HyperProgressTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperProgressThemeData data;
  final Widget child;

  static HyperProgressThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).progressTheme;

  static HyperProgressThemeData? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_HyperProgressThemeScope>()
      ?.data;

  @override
  Widget build(BuildContext context) =>
      _HyperProgressThemeScope(data: of(context).merge(data), child: child);
}

class _HyperProgressThemeScope extends InheritedTheme {
  const _HyperProgressThemeScope({required this.data, required super.child});

  final HyperProgressThemeData data;

  @override
  bool updateShouldNotify(_HyperProgressThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperProgressThemeScope(data: data, child: child);
}
