import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_indicator_style.dart';

/// 所有基础进度形态共用的全局或局部主题。
@immutable
final class HyperProgressIndicatorThemeData {
  const HyperProgressIndicatorThemeData({
    this.style = const HyperProgressIndicatorStyle(),
    this.linearStyle = const HyperProgressIndicatorStyle(),
    this.circularStyle = const HyperProgressIndicatorStyle(),
    this.infiniteStyle = const HyperProgressIndicatorStyle(),
  });

  /// 线性和圆形进度共同继承的属性。
  final HyperProgressIndicatorStyle style;

  /// 只覆盖线性进度的属性。
  final HyperProgressIndicatorStyle linearStyle;

  /// 只覆盖圆形进度的属性。
  final HyperProgressIndicatorStyle circularStyle;

  /// 只覆盖无限进度指示器的属性。
  final HyperProgressIndicatorStyle infiniteStyle;

  HyperProgressIndicatorThemeData merge(
    HyperProgressIndicatorThemeData? other,
  ) {
    if (other == null) return this;
    return HyperProgressIndicatorThemeData(
      style: style.merge(other.style),
      linearStyle: linearStyle.merge(other.linearStyle),
      circularStyle: circularStyle.merge(other.circularStyle),
      infiniteStyle: infiniteStyle.merge(other.infiniteStyle),
    );
  }

  static HyperProgressIndicatorThemeData lerp(
    HyperProgressIndicatorThemeData a,
    HyperProgressIndicatorThemeData b,
    double t,
  ) => HyperProgressIndicatorThemeData(
    style: HyperProgressIndicatorStyle.lerp(a.style, b.style, t),
    linearStyle: HyperProgressIndicatorStyle.lerp(
      a.linearStyle,
      b.linearStyle,
      t,
    ),
    circularStyle: HyperProgressIndicatorStyle.lerp(
      a.circularStyle,
      b.circularStyle,
      t,
    ),
    infiniteStyle: HyperProgressIndicatorStyle.lerp(
      a.infiniteStyle,
      b.infiniteStyle,
      t,
    ),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperProgressIndicatorThemeData &&
          other.style == style &&
          other.linearStyle == linearStyle &&
          other.circularStyle == circularStyle &&
          other.infiniteStyle == infiniteStyle;

  @override
  int get hashCode =>
      Object.hash(style, linearStyle, circularStyle, infiniteStyle);
}

/// 仅覆盖当前子树进度主题的轻量作用域。
class HyperProgressIndicatorTheme extends StatelessWidget {
  const HyperProgressIndicatorTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperProgressIndicatorThemeData data;
  final Widget child;

  static HyperProgressIndicatorThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).progressIndicatorTheme;

  static HyperProgressIndicatorThemeData? maybeOf(
    BuildContext context,
  ) => context
      .dependOnInheritedWidgetOfExactType<_HyperProgressIndicatorThemeScope>()
      ?.data;

  @override
  Widget build(BuildContext context) => _HyperProgressIndicatorThemeScope(
    data: of(context).merge(data),
    child: child,
  );
}

class _HyperProgressIndicatorThemeScope extends InheritedTheme {
  const _HyperProgressIndicatorThemeScope({
    required this.data,
    required super.child,
  });

  final HyperProgressIndicatorThemeData data;

  @override
  bool updateShouldNotify(_HyperProgressIndicatorThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperProgressIndicatorThemeScope(data: data, child: child);
}
